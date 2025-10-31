const admin = require("firebase-admin");
const { onSchedule } = require("firebase-functions/v2/scheduler");

admin.initializeApp();
const db = admin.database();

exports.dailyIngredientOrder = onSchedule(
  {
    schedule: "0 * * * *", // se execută la fiecare oră fixă
    timeZone: "UTC",
    region: "europe-west1",
  },
  async (event) => {
    console.log("Încep procesarea comenzilor zilnice de ingrediente");
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const currentDay = now.getDate();

    try {
      // Obține toți utilizatorii
      const usersSnap = await db.ref("users").once("value");
      const allUsers = usersSnap.val() || {};
      console.log(`Utilizatori încărcați: ${Object.keys(allUsers).length}`);

      // Actualizare ore pentru angajați (incrementare cu 1 ora pentru cei la lucru)
      const updatePromises = [];
      for (const [uid, user] of Object.entries(allUsers)) {
        const type = user.Type;
        const atWork = user.at_work === true;
        if (type !== "owner" && atWork) {
          const currentHours = typeof user.hours === "number" ? user.hours : Number(user.hours) || 0;
          updatePromises.push(db.ref(`users/${uid}/hours`).set(currentHours + 1));
          console.log(`Actualizat ore pentru utilizatorul ${uid}, ore noi: ${currentHours + 1}`);
        }
      }
      await Promise.all(updatePromises);

      // Resetare ore angajați la ziua/oră de plată + adăugare cheltuieli în expenses pentru luna curentă
      // Observație: calculăm și adăugăm cheltuiala (salarială) managerului înainte de a reseta orele angajaților.
      for (const [managerId, managerData] of Object.entries(allUsers)) {
        if (!managerData || managerData.Type !== "owner") continue;

        const payday = Number(managerData.payday);
        const payhour = Number(managerData.payhour);
        const timezone = managerData.timezone || "UTC";

        if (!payday || isNaN(payday) || isNaN(payhour)) continue;

        if (currentDay === payday) {
          // Determinăm ora locală a managerului în timezone-ul său
          const formatter = new Intl.DateTimeFormat("en-US", {
            timeZone: timezone,
            hour: "numeric",
            hour12: false,
          });
          const localHour = Number(formatter.format(now));

          if (localHour === payhour) {
            console.log(`Este ora de resetare ore pentru managerul ${managerId}`);

            // 1) Calculăm totalul salariilor datorate pentru toți angajații managerului
            let totalPayroll = 0;
            const employees = [];
            for (const [empId, empData] of Object.entries(allUsers)) {
              if (!empData) continue;
              if (empData.Owner === managerId && empData.Type && empData.Type !== "owner") {
                const empHours = Number(empData.hours) || 0;
                const wagePerHour = Number(empData.WagePerHour) || 0;
                const empPay = empHours * wagePerHour;
                if (empPay !== 0) {
                  console.log(`Calcul salariu pentru angajat ${empId}: ${empHours}h * ${wagePerHour} = ${empPay}`);
                }
                totalPayroll += empPay;
                employees.push({ empId, empHours });
              }
            }

            // 2) Determinăm cheia lunii curente în timezone-ul managerului, format MM-YYYY (ex: 10-2025)
            const monthYearFormatter = new Intl.DateTimeFormat("en-GB", {
              timeZone: timezone,
              month: "2-digit",
              year: "numeric",
            });
            const parts = monthYearFormatter.formatToParts(now);
            let mm = "00", yyyy = "0000";
            for (const p of parts) {
              if (p.type === "month") mm = p.value;
              if (p.type === "year") yyyy = p.value;
            }
            const monthKey = `${mm}-${yyyy}`;

            // 3) Actualizăm users/{managerId}/expenses/{monthKey} = (existentă || 0) + totalPayroll
            try {
              const expensesRef = db.ref(`users/${managerId}/expenses/${monthKey}`);
              const expenseSnap = await expensesRef.once("value");
              const existingExpense = Number(expenseSnap.val()) || 0;
              const newExpense = existingExpense + totalPayroll;
              await expensesRef.set(newExpense);
              console.log(
                `Am actualizat cheltuieli pentru manager ${managerId} la cheia ${monthKey}: ${existingExpense} -> ${newExpense}`
              );
            } catch (err) {
              console.error(`Eroare la actualizarea expenses pentru manager ${managerId}:`, err);
            }

            // 4) Resetează orele angajaților la 0 (după calcul)
            const resetPromises = [];
            for (const { empId } of employees) {
              resetPromises.push(db.ref(`users/${empId}/hours`).set(0));
              console.log(`Resetat orele pentru angajatul ${empId} al managerului ${managerId}`);
            }
            // Așteptăm toate resetările
            await Promise.all(resetPromises);
          }
        }
      }

      // Procesare pentru fiecare bucătărie
      const kitchensSnap = await db.ref("kitchen").once("value");
      const kitchens = kitchensSnap.val() || {};
      console.log(`Bucătării încărcate: ${Object.keys(kitchens).length}`);

      for (const kitchenId of Object.keys(kitchens)) {
        try {
          const userSnap = await db.ref(`users/${kitchenId}`).once("value");
          const userData = userSnap.val() || {};
          const tz = userData.timezone;
          const updateHour = userData["updateHour"];
          const currency = userData.currency || "RON";

          if (!tz || updateHour == null) {
            console.log(`Date lipsă pentru bucătăria ${kitchenId}, se sare peste procesare.`);
            continue;
          }

          const formatter = new Intl.DateTimeFormat("en-US", {
            timeZone: tz,
            hour: "numeric",
            hour12: false,
          });
          const localHour = Number(formatter.format(now));
          const expectedHour = Number(updateHour);

          if (isNaN(expectedHour)) {
            console.log(`Ora de update nevalidă pentru bucătăria ${kitchenId}`);
            continue;
          }

          if (localHour !== expectedHour) {
            console.log(`Nu este ora de update pentru bucătăria ${kitchenId} (ora locală: ${localHour}, ora așteptată: ${expectedHour})`);
            continue;
          }

          // Procesează ingredientele
          const ingrSnap = await db.ref(`kitchen/${kitchenId}/ingredients/list`).once("value");
          const ingredients = ingrSnap.val() || {};
          const toOrder = [];
          const expiryUpdates = [];

          for (const [id, data] of Object.entries(ingredients)) {
            if (!data) continue;

            const { quantity, quarepl, replacement, price, days, date } = data;

            // Verifică expirare
            if (date && days != null) {
              try {
                const [dd, mm, yyyy] = date.split("/").map(Number);
                const expiryDate = new Date(yyyy, mm - 1, dd + (days || 0));
                if (today >= expiryDate && quantity > 0) {
                  expiryUpdates.push(db.ref(`kitchen/${kitchenId}/ingredients/list/${id}/quantity`).set(0));
                  console.log(`Ingredientul ${id} a expirat și a fost resetat cantitatea la 0.`);
                  continue;
                }
              } catch (error) {
                console.error(`Eroare la procesarea expirării pentru ingredientul ${id}:`, error);
              }
            }

            // Verifică necesitatea comenzii
            if (quantity < quarepl && replacement > 0) {
              toOrder.push({
                id,
                name: data.name || `Ingredient ${id}`,
                unit: data.unit || "",
                qty: replacement,
                cost: replacement * (price || 0),
              });
              console.log(`Ingredientul ${id} (${data.name}) trebuie comandat. Cantitate necesară: ${replacement}`);
            }
          }
          await Promise.all(expiryUpdates);

          if (toOrder.length === 0) {
            console.log(`Nicio comandă nouă necesară pentru bucătăria ${kitchenId}`);
            continue;
          }

          // Verifică comenzile existente
          const ordersRef = db.ref(`kitchen/${kitchenId}/ingredients/orders`);
          const existing = await ordersRef.once("value");
          const existingOrders = existing.val() || {};
          const alreadyOrderedIngredients = new Set();

          for (const orderId in existingOrders) {
            const order = existingOrders[orderId];
            if (order && ["requested", "approved"].includes(order.status)) {
              const existingIngredients = (order.ingredient || "").split(",");
              existingIngredients.forEach((ingr) => ingr && alreadyOrderedIngredients.add(ingr.trim()));
            }
          }

          const newToOrder = toOrder.filter((item) => !alreadyOrderedIngredients.has(item.id));
          if (newToOrder.length === 0) {
            console.log(`Ingredientele necesare sunt deja comandate pentru bucătăria ${kitchenId}`);
            continue;
          }

          // Creează comanda nouă
          newToOrder.sort((a, b) => a.id.localeCompare(b.id));
          const ingredientList = newToOrder.map((o) => o.id);
          const qtyList = newToOrder.map((o) => o.qty);
          const totalPrice = newToOrder.reduce((sum, o) => sum + (o.cost || 0), 0);

          const newOrderRef = await ordersRef.push({
            ingredient: ingredientList.join(","),
            quantity: qtyList.join(","),
            status: "requested",
            price: totalPrice,
            timestamp: Date.now(),
          });

          console.log(`Comandă nouă creată pentru bucătăria ${kitchenId}: ${ingredientList.join(", ")}, preț total ${totalPrice} ${currency}`);

          // --- NOTIFICĂRI ---
          const devicesSnap = await db.ref(`users/${kitchenId}/devices`).once("value");
          if (!devicesSnap.exists()) {
            console.log(`Niciun dispozitiv înregistrat pentru bucătăria ${kitchenId}`);
            continue;
          }

          const tokens = [];
          devicesSnap.forEach((child) => {
            const token = child.child("token").val();
            if (token && typeof token === "string" && token.length > 0) {
              tokens.push(token);
            }
          });

          if (tokens.length === 0) {
            console.log(`Niciun token FCM valid pentru bucătăria ${kitchenId}`);
            continue;
          }

          // Construiește textul notificării cu denumiri clare
          const ingredientDetails = newToOrder
            .map((o) => `${o.qty} ${o.unit} x ${o.name}`)
            .join(", ");
          const totalFormatted = `${totalPrice.toFixed(2)} ${currency}`;

          const notificationPromises = tokens.map(async (token) => {
            try {
              const message = {
                token: token,
                notification: {
                  title: "New order of ingredients",
                  body: `Ordered: ${ingredientDetails} (Total: ${totalFormatted})`,
                },
                data: {
                  type: "new_order",
                  kitchenId: kitchenId,
                  orderId: newOrderRef.key,
                  timestamp: Date.now().toString(),
                },
                android: { priority: "high" },
                apns: {
                  payload: {
                    aps: { sound: "default", badge: 1 },
                  },
                },
              };

              const response = await admin.messaging().send(message);
              return { success: true, token, response };
            } catch (error) {
              console.error(`Eroare la trimiterea notificării pentru token ${token.substring(0, 10)}...:`, error.message);
              if (
                error.code === "messaging/invalid-registration-token" ||
                error.code === "messaging/registration-token-not-registered"
              ) {
                console.log(`Ștergem token invalid: ${token.substring(0, 10)}...`);
                await db
                  .ref(`users/${kitchenId}/devices`)
                  .orderByChild("token")
                  .equalTo(token)
                  .once("value")
                  .then((snap) => {
                    if (snap.exists()) snap.forEach((child) => child.ref.remove());
                  });
              }
              return { success: false, token, error };
            }
          });

          const results = await Promise.all(notificationPromises);
          const successful = results.filter((r) => r.success).length;
          const failed = results.filter((r) => !r.success).length;

          console.log(`Notificări trimise pentru bucătăria ${kitchenId}: ${successful} reușite, ${failed} eșuate`);
        } catch (kitchenError) {
          console.error(`Eroare la procesarea bucătăriei ${kitchenId}:`, kitchenError);
        }
      }

      console.log("Procesarea comenzilor zilnice de ingrediente s-a încheiat cu succes");
    } catch (error) {
      console.error("Eroare generală în funcție:", error);
      throw error;
    }
  }
);
