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
    const kitchenRef = db.ref(`kitchen/${kitchenId}`);
    const ingredientListSnap = await kitchenRef.child("ingredients/list").once("value");
    const ingredientList = ingredientListSnap.val() || [];
    const menuSnap = await kitchenRef.child("menu/list").once("value");
    const menuList = menuSnap.val() || [];
    for (let i = 0; i < menuList.length; i++) {
      const menuItem = menuList[i];
      if (!menuItem || !menuItem.ingredients || !menuItem.quantities) continue;
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
          available = false;
          break;
        }
        const [, ing] = ingredientEntry;
        if ((ing.quantity || 0) < needed) {
          available = false;
          break;
        }
      }
      await kitchenRef.child(`menu/list/${i}/menuAvailability`).set(available);
      console.log(
        `📋 ${menuItem.name} availability set to ${available}`
      );
    }
  }
);
exports.dailyIngredientOrder = onSchedule(
  {
    schedule: "0 * * * *",
    timeZone: "UTC",
    region: "europe-west1",
  },
  async (event) => {
    console.log("✅ dailyIngredientOrder triggered at", new Date().toISOString());
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const kitchensSnap = await db.ref("kitchen").once("value");
    const kitchens = kitchensSnap.val() || {};
    for (const kitchenId of Object.keys(kitchens)) {
      console.log(`🔎 Processing kitchen ${kitchenId}`);
      const userSnap = await db.ref(`users/${kitchenId}`).once("value");
      const userData = userSnap.val() || {};
      const tz = userData.timezone;
      const updateHour = userData["updateHour"];
      if (!tz || updateHour == null) {
        console.log(`⚠️ Missing timezone or update-hour for ${kitchenId}, skipping...`);
        continue;
      }
      const formatter = new Intl.DateTimeFormat('en-US', { timeZone: tz, hour: 'numeric', hour12: false });
      const localHour = parseInt(formatter.format(now), 10);
      if (updateHour !== localHour) {
        console.log(`⏩ Skipping ${kitchenId}: localHour=${localHour}, updateHour=${updateHour}`);
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
            console.log(`❌ ${id} expired on ${expiryDate.toDateString()} → quantity set to 0`);
            continue;
          }
        }
        if (quantity < quarepl) {
          toOrder.push({ id, qty: replacement, cost: replacement * price });
          console.log(`🍴 ${id}: needs restock with ${replacement}`);
        }
      }
      if (toOrder.length === 0) {
        console.log(`✅ No ingredients to order for ${kitchenId}`);
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
          existingIngredients.forEach(ingr => alreadyOrderedIngredients.add(ingr));
        }
      }
      const newToOrder = toOrder.filter(item => !alreadyOrderedIngredients.has(item.id));
      if (newToOrder.length === 0) {
        console.log(`✅ All needed ingredients already have pending orders for ${kitchenId}`);
        continue;
      }
      newToOrder.sort((a, b) => a.id.localeCompare(b.id));
      const ingredientList = newToOrder.map(o => o.id);
      const qtyList = newToOrder.map(o => o.qty);
      const totalPrice = newToOrder.reduce((sum, o) => sum + o.cost, 0);
      await ordersRef.push({
        ingredient: ingredientList.join(","),
        quantity: qtyList.join(","),
        status: "requested",
        price: totalPrice
      });
      console.log(`🛒 New order created for ${kitchenId}: [${ingredientList.join(",")}] x [${qtyList.join(",")}]`);
    }
    console.log("🏁 All kitchens processed");
  }
);