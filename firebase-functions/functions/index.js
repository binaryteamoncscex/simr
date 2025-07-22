const admin = require("firebase-admin");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const { onValueWritten } = require("firebase-functions/v2/database");
admin.initializeApp();
const db = admin.database();

exports.checkMenuAvailability = onValueWritten(
  {
    ref: "kitchen/{kitchenId}/ingredients/list/{ingredientId}/quantity",
    region: "europe-west1",
  },
  async (event) => {
    const { kitchenId } = event.params;
    console.log(`Verific disponibilitatea meniului pentru bucătăria: ${kitchenId}`);

    const kitchenRef = db.ref(`kitchen/${kitchenId}`);

    const ingredientListSnap = await kitchenRef.child("ingredients/list").once("value");
    const ingredientList = ingredientListSnap.val() || [];
    console.log(`Lista ingrediente încărcată. Total ingrediente: ${Object.keys(ingredientList).length}`);

    const menuSnap = await kitchenRef.child("menu/list").once("value");
    const menuList = menuSnap.val() || [];
    console.log(`Lista meniului încărcată. Total preparate: ${menuList.length}`);

    for (let i = 0; i < menuList.length; i++) {
      const menuItem = menuList[i];
      if (!menuItem || !menuItem.ingredients || !menuItem.quantities) {
        console.log(`Preparatul de pe poziția ${i} este invalid sau incomplet.`);
        continue;
      }

      const ingredientNames = menuItem.ingredients.split(" ");
      const quantities = menuItem.quantities.split(" ").map(Number);

      let available = true;

      for (let j = 0; j < ingredientNames.length; j++) {
        const name = ingredientNames[j];
        const needed = quantities[j];

        const ingredientEntry = Object.entries(ingredientList).find(
          ([, val]) => val?.name === name
        );

        if (!ingredientEntry) {
          console.log(`Lipsă ingredient '${name}' pentru preparatul ${menuItem.name || i}`);
          available = false;
          break;
        }

        const [, ing] = ingredientEntry;
        if ((ing.quantity || 0) < needed) {
          console.log(`Ingredientul '${name}' are cantitate insuficientă: necesar ${needed}, disponibil ${ing.quantity || 0}`);
          available = false;
          break;
        }
      }

      console.log(`Disponibilitatea preparatului '${menuItem.name || i}': ${available}`);
      await kitchenRef.child(`menu/list/${i}/menuAvailability`).set(available);
    }

    console.log(`Verificare disponibilitate meniului finalizată pentru bucătăria: ${kitchenId}`);
  }
);

exports.dailyIngredientOrder = onSchedule(
  {
    schedule: "0 * * * *",
    timeZone: "UTC",
    region: "europe-west1",
  },
  async (event) => {
    console.log("Încep procesarea comenzilor zilnice de ingrediente");

    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const currentDay = now.getDate();

    const usersSnap = await db.ref("users").once("value");
    const allUsers = usersSnap.val() || {};
    console.log(`Utilizatori încărcați: ${Object.keys(allUsers).length}`);

    for (const [uid, user] of Object.entries(allUsers)) {
      const type = user.Type;
      const atWork = user.at_work === true;

      if (type !== "owner" && atWork) {
        const currentHours = typeof user.hours === "number" ? user.hours : 0;
        await db.ref(`users/${uid}/hours`).set(currentHours + 1);
        console.log(`Actualizat ore pentru utilizatorul ${uid}, ore noi: ${currentHours + 1}`);
      }
    }

    for (const [managerId, managerData] of Object.entries(allUsers)) {
      if (managerData.Type !== "owner") continue;

      const payday = Number(managerData.payday);
      const payhour = Number(managerData.payhour);
      const timezone = managerData.timezone || "UTC";

      if (!payday || isNaN(payday) || isNaN(payhour)) continue;

      if (currentDay === payday) {
        const formatter = new Intl.DateTimeFormat("en-US", {
          timeZone: timezone,
          hour: "numeric",
          hour12: false,
        });
        const localHour = Number(formatter.format(now));

        if (localHour === payhour) {
          console.log(`Este ora de resetare ore pentru managerul ${managerId}`);
          for (const [empId, empData] of Object.entries(allUsers)) {
            if (empData.Owner === managerId) {
              await db.ref(`users/${empId}/hours`).set(0);
              console.log(`Resetat orele pentru angajatul ${empId} al managerului ${managerId}`);
            }
          }
        }
      }
    }

    const kitchensSnap = await db.ref("kitchen").once("value");
    const kitchens = kitchensSnap.val() || {};
    console.log(`Bucătării încărcate: ${Object.keys(kitchens).length}`);

    for (const kitchenId of Object.keys(kitchens)) {
      const userSnap = await db.ref(`users/${kitchenId}`).once("value");
      const userData = userSnap.val() || {};
      const tz = userData.timezone;
      const updateHour = userData["updateHour"];

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

      const ingrSnap = await db.ref(`kitchen/${kitchenId}/ingredients/list`).once("value");
      const ingredients = ingrSnap.val() || {};
      const toOrder = [];

      for (const [id, data] of Object.entries(ingredients)) {
        const { quantity, quarepl, replacement, price, days, date } = data;

        if (date && days != null) {
          const [dd, mm, yyyy] = date.split("/").map(Number);
          const expiryDate = new Date(yyyy, mm - 1, dd + days);
          if (today >= expiryDate && quantity > 0) {
            await db.ref(`kitchen/${kitchenId}/ingredients/list/${id}/quantity`).set(0);
            console.log(`Ingredientul ${id} a expirat și a fost resetat cantitatea la 0.`);
            continue;
          }
        }

        if (quantity < quarepl) {
          toOrder.push({ id, qty: replacement, cost: replacement * price });
          console.log(`Ingredientul ${id} trebuie comandat. Cantitate necesară: ${replacement}`);
        }
      }

      if (toOrder.length === 0) {
        console.log(`Nicio comandă nouă necesară pentru bucătăria ${kitchenId}`);
        continue;
      }

      const ordersRef = db.ref(`kitchen/${kitchenId}/ingredients/orders`);
      const existing = await ordersRef.once("value");
      const existingOrders = existing.val() || {};
      const alreadyOrderedIngredients = new Set();

      for (const orderId in existingOrders) {
        const order = existingOrders[orderId];
        if (["requested", "approved"].includes(order.status)) {
          const existingIngredients = order.ingredient.split(",");
          existingIngredients.forEach((ingr) => alreadyOrderedIngredients.add(ingr));
        }
      }

      const newToOrder = toOrder.filter((item) => !alreadyOrderedIngredients.has(item.id));

      if (newToOrder.length === 0) {
        console.log(`Ingredientele necesare sunt deja comandate pentru bucătăria ${kitchenId}`);
        continue;
      }

      newToOrder.sort((a, b) => a.id.localeCompare(b.id));
      const ingredientList = newToOrder.map((o) => o.id);
      const qtyList = newToOrder.map((o) => o.qty);
      const totalPrice = newToOrder.reduce((sum, o) => sum + o.cost, 0);

      await ordersRef.push({
        ingredient: ingredientList.join(","),
        quantity: qtyList.join(","),
        status: "requested",
        price: totalPrice,
      });

      console.log(`Comandă nouă creată pentru bucătăria ${kitchenId}: ingrediente ${ingredientList.join(", ")}, preț total ${totalPrice}`);
    }

    console.log("Procesarea comenzilor zilnice de ingrediente s-a încheiat");
  }
);