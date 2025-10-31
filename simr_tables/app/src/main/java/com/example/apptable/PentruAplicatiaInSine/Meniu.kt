package com.example.apptable.PentruAplicatiaInSine

import android.content.Context
import android.util.Log
import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import coil.compose.AsyncImage
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.*
import com.google.firebase.database.ktx.database
import com.google.firebase.ktx.Firebase
import kotlinx.coroutines.delay
import java.util.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MeniuScreen(navController: NavController, tableId: String) {
    val context = LocalContext.current
    val auth = FirebaseAuth.getInstance()
    val userId = auth.currentUser?.uid
    val database = Firebase.database
    val menuRef = userId?.let { database.getReference("kitchen").child(it).child("menu").child("list") }
    val userCurrencyRef = userId?.let { database.getReference("users").child(it).child("currency") }

    val menuItems = remember { mutableStateListOf<MenuItem>() }
    val cartItems = remember { mutableMapOf<String, Int>() }
    var showCart by remember { mutableStateOf(false) }
    var showThankYou by remember { mutableStateOf(false) }
    var navigateToPreorder by remember { mutableStateOf(false) }
    var currencySymbol by remember { mutableStateOf("lei") }

    LaunchedEffect(Unit) {
        menuRef?.addValueEventListener(object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                menuItems.clear()

                // 1. Preluăm toate ingredientele și stocurile într-o mapă
                val ingredientsRef = userId?.let {
                    database.getReference("kitchen").child(it).child("ingredients").child("list")
                }

                ingredientsRef?.addListenerForSingleValueEvent(object : ValueEventListener {
                    override fun onDataChange(ingredientsSnap: DataSnapshot) {
                        val stockMap = mutableMapOf<String, Double>()
                        ingredientsSnap.children.forEach { ingrSnap ->
                            val ingrObj = ingrSnap.getValue(object : GenericTypeIndicator<Map<String, Any>>() {})
                            val name = ingrObj?.get("name") as? String
                            val qty = (ingrObj?.get("quantity") as? Number)?.toDouble() ?: 0.0
                            if (name != null) {
                                stockMap[name] = qty
                            }
                        }

                        // 2. Iterăm prin meniuri și verificăm disponibilitatea
                        snapshot.children.forEach { itemSnapshot ->
                            val id = itemSnapshot.key ?: return@forEach

                            val category = itemSnapshot.child("category").getValue(String::class.java) ?: "Other"
                            val name = itemSnapshot.child("name").getValue(String::class.java) ?: "Unknown"
                            val photo = itemSnapshot.child("photo").getValue(String::class.java) ?: ""
                            val price = itemSnapshot.child("price").getValue(String::class.java) ?: "0.0"
                            val ingredientsStr = itemSnapshot.child("ingredients").getValue(String::class.java) ?: ""
                            val quantitiesStr = itemSnapshot.child("quantities").getValue(String::class.java) ?: ""
                            val nutritional = itemSnapshot.child("nutritional").getValue(String::class.java)
                                ?: "No nutritional information available"
                            val allergens = itemSnapshot.child("allergens").getValue(String::class.java)
                                ?: "No allergens declared"

                            val ingredientNames = ingredientsStr.split(" ").filter { it.isNotBlank() }
                            val neededQuantities = quantitiesStr.split(" ").mapNotNull { it.toDoubleOrNull() }

                            var isAvailable = true
                            if (ingredientNames.size == neededQuantities.size) {
                                ingredientNames.forEachIndexed { index, ingrName ->
                                    val stock = stockMap[ingrName] ?: 0.0
                                    if (stock < neededQuantities[index]) {
                                        isAvailable = false
                                    }
                                }
                            } else {
                                isAvailable = false
                            }

                            if (isAvailable) {
                                menuItems.add(
                                    MenuItem(
                                        id = id,
                                        name = name,
                                        photo = photo,
                                        price = price,
                                        ingredients = ingredientsStr,
                                        quantities = quantitiesStr,
                                        isAvailable = true,
                                        category = category,
                                        nutritional = nutritional,
                                        allergens = allergens
                                    )
                                )
                            }
                        }
                        menuItems.sortBy { it.category }
                    }

                    override fun onCancelled(error: DatabaseError) {
                        Log.e("Firebase", "Failed to read ingredients", error.toException())
                    }
                })
            }


            override fun onCancelled(error: DatabaseError) {
                Log.e("Firebase", "Failed to read menu", error.toException())
            }
        })
    }

    // This DisposableEffect monitors the user's currency preference
    DisposableEffect(Unit) {
        if (userCurrencyRef != null) {
            val listener = object : ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    currencySymbol = snapshot.getValue(String::class.java) ?: "lei"
                }

                override fun onCancelled(error: DatabaseError) {
                    Log.e("Firebase", "Failed to read currency symbol: ${error.message}", error.toException())
                    currencySymbol = "lei"
                }
            }
            userCurrencyRef.addValueEventListener(listener)

            // The onDispose block is crucial for removing the listener when the composable leaves the composition
            onDispose {
                userCurrencyRef.removeEventListener(listener)
            }
        } else {
            // If userCurrencyRef is null, there's nothing to dispose of
            onDispose { }
        }
    }

    LaunchedEffect(showThankYou) {
        if (showThankYou) {
            delay(2500)
            showThankYou = false
        }
    }

    Scaffold(
        modifier = Modifier.fillMaxSize(),
        containerColor = Color.White,
        content = { innerPadding ->
            Box(modifier = Modifier.fillMaxSize().padding(innerPadding)) {
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(horizontal = 16.dp)
                        .verticalScroll(rememberScrollState())
                ) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.End,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Spacer(Modifier.weight(1f))
                        IconButton(
                            onClick = { showCart = true },
                            colors = IconButtonDefaults.iconButtonColors(
                                contentColor = Color(0xFF00BFFF)
                            )
                        ) {
                            Icon(imageVector = Icons.Default.ShoppingCart, contentDescription = "Cart")
                            if (cartItems.any { it.value > 0 }) {
                                Badge(
                                    containerColor = Color(0xFF00BFFF),
                                    contentColor = Color.White
                                ) {
                                    Text(text = cartItems.values.sum().toString())
                                }
                            }
                        }
                    }

                    val groupedItems = menuItems.groupBy { it.category }
                    groupedItems.forEach { (category, itemsInCategory) ->
                        Text(
                            text = category,
                            fontSize = 22.sp,
                            fontWeight = FontWeight.ExtraBold,
                            color = Color(0xFF003366),
                            modifier = Modifier.padding(vertical = 16.dp)
                        )
                        itemsInCategory.forEach { item ->
                            MenuItemCard(item, cartItems, currencySymbol)
                        }
                    }

                    Spacer(modifier = Modifier.height(64.dp))
                }

                // Butonul "Redeem Your Code"
                Column(
                    modifier = Modifier
                        .align(Alignment.BottomCenter)
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 16.dp),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Button(
                        onClick = { navController.navigate("redeem_code") },
                        modifier = Modifier.fillMaxWidth(),
                        colors = ButtonDefaults.buttonColors(
                            containerColor = Color(0xFF00BFFF),
                            contentColor = Color.White
                        )
                    ) {
                        Text("Redeem Your Code")
                    }
                }
            }
        }
    )

    if (showThankYou) {
        ThankYouDialog()
    }

    LaunchedEffect(navigateToPreorder) {
        if (navigateToPreorder) {
            delay(2500)
            navController.navigate("precomanda/$tableId") {
                popUpTo("meniu/$tableId") { inclusive = true }
            }
            navigateToPreorder = false
        }
    }

    if (showCart) {
        CartDialog(
            cartItems = cartItems,
            menuItems = menuItems,
            userId = userId,
            tableId = tableId,
            currency = currencySymbol,
            onDismiss = { showCart = false },
            onOrderPlaced = {
                showThankYou = true
                showCart = false
                navigateToPreorder = true
            }
        )
    }
}

@Composable
private fun ThankYouDialog() {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0x80000000))
            .padding(32.dp),
        contentAlignment = Alignment.Center
    ) {
        Card(
            colors = CardDefaults.cardColors(containerColor = Color.White)
        ) {
            Column(
                modifier = Modifier.padding(24.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    "Order Placed Successfully!",
                    color = Color(0xFF00BFFF),
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Bold
                )
                Spacer(modifier = Modifier.height(16.dp))
                Text(
                    "Thank You!",
                    fontSize = 18.sp,
                    color = Color(0xFF003366)
                )
            }
        }
    }
}

@Composable
fun MenuItemCard(item: MenuItem, cartItems: MutableMap<String, Int>, currency: String) {
    var quantity by remember { mutableStateOf(cartItems[item.id] ?: 0) }
    var showNutritionInfo by remember { mutableStateOf(false) }
    var showAllergensInfo by remember { mutableStateOf(false) }

    LaunchedEffect(cartItems[item.id]) {
        quantity = cartItems[item.id] ?: 0
    }

    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 8.dp),
        elevation = CardDefaults.cardElevation(4.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White)
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            if (item.photo.isNotBlank()) {
                AsyncImage(
                    model = item.photo,
                    contentDescription = "Image of ${item.name}",
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(180.dp))
            }

            Text(
                text = item.name,
                color = Color(0xFF003366),
                fontSize = 20.sp,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(top = 8.dp)
            )

            Spacer(modifier = Modifier.height(4.dp))

            Text(
                text = "${item.price} $currency",
                color = Color(0xFF00BFFF),
                fontSize = 16.sp
            )

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = "Ingredients: ${item.ingredients}",
                color = Color.Gray,
                fontSize = 14.sp,
                modifier = Modifier.padding(bottom = 8.dp)
            )

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceEvenly
            ) {
                Button(
                    onClick = { showNutritionInfo = true },
                    modifier = Modifier.weight(1f).padding(end = 4.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFF4CAF50),
                        contentColor = Color.White
                    ),
                    elevation = ButtonDefaults.buttonElevation(defaultElevation = 2.dp)
                ) {
                    Text("Nutritional Values", fontSize = 12.sp)
                }

                Button(
                    onClick = { showAllergensInfo = true },
                    modifier = Modifier.weight(1f).padding(start = 4.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFFF44336),
                        contentColor = Color.White
                    ),
                    elevation = ButtonDefaults.buttonElevation(defaultElevation = 2.dp)
                ) {
                    Text("Allergens", fontSize = 12.sp)
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            QuantitySelector(
                currentQuantity = quantity,
                onQuantityChange = { newQuantity ->
                    quantity = newQuantity
                    cartItems[item.id] = newQuantity
                }
            )
        }
    }

    if (showNutritionInfo) {
        AlertDialog(
            onDismissRequest = { showNutritionInfo = false },
            title = {
                Text(
                    text = "Nutritional Values: ${item.name}",
                    color = Color(0xFF4CAF50),
                    fontWeight = FontWeight.Bold
                )
            },
            text = {
                Text(item.nutritional, color = Color(0xFF003366))
            },
            confirmButton = {
                TextButton(
                    onClick = { showNutritionInfo = false },
                    colors = ButtonDefaults.textButtonColors(
                        contentColor = Color(0xFF4CAF50)
                    )
                ) {
                    Text("OK")
                }
            }
        )
    }

    if (showAllergensInfo) {
        AlertDialog(
            onDismissRequest = { showAllergensInfo = false },
            title = {
                Text(
                    text = "Allergens: ${item.name}",
                    color = Color(0xFFF44336),
                    fontWeight = FontWeight.Bold
                )
            },
            text = {
                Text(item.allergens, color = Color(0xFF003366))
            },
            confirmButton = {
                TextButton(
                    onClick = { showAllergensInfo = false },
                    colors = ButtonDefaults.textButtonColors(
                        contentColor = Color(0xFFF44336)
                    )
                ) {
                    Text("OK")
                }
            }
        )
    }
}

@Composable
private fun QuantitySelector(currentQuantity: Int, onQuantityChange: (Int) -> Unit) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.Center
    ) {
        IconButton(
            onClick = { if (currentQuantity > 0) onQuantityChange(currentQuantity - 1) },
            modifier = Modifier.size(48.dp),
            colors = IconButtonDefaults.iconButtonColors(
                contentColor = Color(0xFF00BFFF)
            )
        ) {
            Text("-", fontSize = 24.sp)
        }

        Text(
            text = currentQuantity.toString(),
            modifier = Modifier.padding(horizontal = 16.dp),
            fontSize = 20.sp,
            color = Color(0xFF003366)
        )

        IconButton(
            onClick = { onQuantityChange(currentQuantity + 1) },
            modifier = Modifier.size(48.dp),
            colors = IconButtonDefaults.iconButtonColors(
                contentColor = Color(0xFF00BFFF)
            )
        ) {
            Text("+", fontSize = 24.sp)
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CartDialog(
    cartItems: MutableMap<String, Int>,
    menuItems: List<MenuItem>,
    userId: String?,
    tableId: String,
    currency: String,
    onDismiss: () -> Unit,
    onOrderPlaced: () -> Unit
) {
    val database = Firebase.database
    val orderRef = userId?.let {
        database.getReference("kitchen").child(it).child("menu").child("orders").child("list")
    }

    val context = LocalContext.current
    var paymentMethod by remember { mutableStateOf("Card") }
    var observations by remember { mutableStateOf("") }
    var isPlacingOrder by remember { mutableStateOf(false) }
    // State to hold the active discount percentage from voucher
    var voucherDiscountPercent by remember { mutableStateOf(0.0) } // Initialize to 0.0

    // States for Happy Hour
    var happyHourProcent by remember { mutableStateOf(0) }
    var happyHourStart by remember { mutableStateOf(-1) }
    var happyHourStop by remember { mutableStateOf(-1) }

    // Listener for voucher active discount
    DisposableEffect(userId) {
        var voucherListener: ValueEventListener? = null
        var happyHourListener: ValueEventListener? = null

        if (userId != null) {
            // Listener for Voucher Discount
            val userDiscountRef = database.getReference("users").child(userId).child("activeDiscount")
            voucherListener = object : ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    voucherDiscountPercent = snapshot.getValue(String::class.java)?.toDoubleOrNull() ?: 0.0
                    Log.d("CartDialog", "Voucher discount loaded: $voucherDiscountPercent%")
                }

                override fun onCancelled(error: DatabaseError) {
                    Log.e("CartDialog", "Failed to read voucher discount: ${error.message}", error.toException())
                    voucherDiscountPercent = 0.0
                }
            }
            userDiscountRef.addValueEventListener(voucherListener)

            // Listener for Happy Hour Discount
            val happyHourRef = database.getReference("users").child(userId).child("HappyHour")
            happyHourListener = object : ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    happyHourProcent = snapshot.child("procent").getValue(Long::class.java)?.toInt() ?: 0
                    happyHourStart = snapshot.child("start").getValue(Long::class.java)?.toInt() ?: -1
                    happyHourStop = snapshot.child("stop").getValue(Long::class.java)?.toInt() ?: -1
                    Log.d("CartDialog", "Happy Hour loaded: Procent: $happyHourProcent%, Start: $happyHourStart, Stop: $happyHourStop")
                }

                override fun onCancelled(error: DatabaseError) {
                    Log.e("CartDialog", "Failed to read Happy Hour data: ${error.message}", error.toException())
                    happyHourProcent = 0
                    happyHourStart = -1
                    happyHourStop = -1
                }
            }
            happyHourRef.addValueEventListener(happyHourListener)
        }

        onDispose {
            voucherListener?.let {
                userId?.let { uid ->
                    database.getReference("users").child(uid).child("activeDiscount").removeEventListener(it)
                }
            }
            happyHourListener?.let {
                userId?.let { uid ->
                    database.getReference("users").child(uid).child("HappyHour").removeEventListener(it)
                }
            }
        }
    }

    val itemsInCart = cartItems.filterValues { it > 0 }
    val selectedMenuItems = menuItems.filter { itemsInCart.containsKey(it.id) }

    val totalPriceBeforeDiscount = selectedMenuItems.sumOf { item ->
        (item.price.toDoubleOrNull() ?: 0.0) * (itemsInCart[item.id] ?: 0)
    }

    // Calculate total applicable discount
    val currentHour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY)
    val isHappyHourActive = if (happyHourStart != -1 && happyHourStop != -1) {
        if (happyHourStart <= happyHourStop) {
            currentHour >= happyHourStart && currentHour < happyHourStop
        } else { // Handles cases like 22:00 - 02:00 (overnight)
            currentHour >= happyHourStart || currentHour < happyHourStop
        }
    } else false

    val totalDiscountPercent = voucherDiscountPercent + if (isHappyHourActive) happyHourProcent.toDouble() else 0.0

    // Calculate final price with combined discounts
    val finalPrice = totalPriceBeforeDiscount * (1 - (totalDiscountPercent / 100))

    AlertDialog(
        onDismissRequest = { if (!isPlacingOrder) onDismiss() },
        title = {
            Text(
                text = "Shopping Cart",
                color = Color(0xFF00BFFF),
                fontWeight = FontWeight.Bold
            )
        },
        text = {
            if (itemsInCart.isEmpty()) {
                Text("Your cart is empty.", modifier = Modifier.padding(16.dp))
            } else {
                Column {
                    Column(Modifier.verticalScroll(rememberScrollState()).weight(1f, fill = false)) {
                        selectedMenuItems.forEach { item ->
                            val quantity = itemsInCart[item.id] ?: 0
                            Row(
                                modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp),
                                horizontalArrangement = Arrangement.SpaceBetween
                            ) {
                                Text(item.name, color = Color(0xFF003366))
                                Text(
                                    "${"%.2f".format((item.price.toDoubleOrNull() ?: 0.0) * quantity)} $currency",
                                    color = Color(0xFF00BFFF)
                                )
                            }
                        }
                    }

                    Divider(
                        modifier = Modifier.padding(vertical = 8.dp),
                        color = Color(0xFF00BFFF).copy(alpha = 0.5f)
                    )

                    // Display Total Before Discount
                    Row(
                        modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text("Total (before discount):", color = Color(0xFF003366))
                        Text(
                            "${"%.2f".format(totalPriceBeforeDiscount)} $currency",
                            color = Color(0xFF00BFFF)
                        )
                    }

                    // Display Voucher Discount if applicable
                    if (voucherDiscountPercent > 0) {
                        Row(
                            modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text(
                                "Voucher Discount ($voucherDiscountPercent%):",
                                color = Color(0xFF4CAF50) // Green for discount
                            )
                            Text(
                                "-${"%.2f".format(totalPriceBeforeDiscount * (voucherDiscountPercent / 100))} $currency",
                                color = Color(0xFF4CAF50)
                            )
                        }
                    }

                    // Display Happy Hour Discount if applicable
                    if (isHappyHourActive && happyHourProcent > 0) {
                        Row(
                            modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text(
                                "Happy Hour Discount ($happyHourProcent%):",
                                color = Color(0xFF8BC34A) // A different shade of green for Happy Hour
                            )
                            Text(
                                "-${"%.2f".format(totalPriceBeforeDiscount * (happyHourProcent.toDouble() / 100))} $currency",
                                color = Color(0xFF8BC34A)
                            )
                        }
                    }

                    if (totalDiscountPercent > 0) {
                        Row(
                            modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text(
                                "Total Combined Discount ($totalDiscountPercent%):",
                                fontWeight = FontWeight.Bold,
                                color = Color(0xFF2196F3) // Blue for total discount
                            )
                            Text(
                                "-${"%.2f".format(totalPriceBeforeDiscount * (totalDiscountPercent / 100))} $currency",
                                fontWeight = FontWeight.Bold,
                                color = Color(0xFF2196F3)
                            )
                        }
                    }


                    // Display Final Price
                    Row(
                        modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text("Final Price:", fontWeight = FontWeight.Bold, color = Color(0xFF003366))
                        Text(
                            "${"%.2f".format(finalPrice)} $currency",
                            fontWeight = FontWeight.Bold,
                            color = Color(0xFF00BFFF)
                        )
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    Text(
                        "Payment Method:",
                        fontWeight = FontWeight.SemiBold,
                        color = Color(0xFF003366)
                    )
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        RadioButton(
                            selected = paymentMethod == "Card",
                            onClick = { paymentMethod = "Card" },
                            colors = RadioButtonDefaults.colors(
                                selectedColor = Color(0xFF00BFFF),
                                unselectedColor = Color(0xFF003366)
                            )
                        )
                        Text("Card", modifier = Modifier.padding(start = 4.dp), color = Color(0xFF003366))

                        Spacer(modifier = Modifier.width(16.dp))

                        RadioButton(
                            selected = paymentMethod == "Cash",
                            onClick = { paymentMethod = "Cash" },
                            colors = RadioButtonDefaults.colors(
                                selectedColor = Color(0xFF00BFFF),
                                unselectedColor = Color(0xFF003366)
                            )
                        )
                        Text("Cash", modifier = Modifier.padding(start = 4.dp), color = Color(0xFF003366))
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    Text(
                        "Notes:",
                        fontWeight = FontWeight.SemiBold,
                        color = Color(0xFF003366)
                    )
                    OutlinedTextField(
                        value = observations,
                        onValueChange = { observations = it },
                        modifier = Modifier.fillMaxWidth(),
                        placeholder = { Text("Ex: no onions, extra spicy...") },
                        singleLine = true,
                        colors = TextFieldDefaults.colors(
                            focusedContainerColor = Color.White,
                            unfocusedContainerColor = Color.White,
                            focusedTextColor = Color(0xFF003366),
                            unfocusedTextColor = Color(0xFF003366),
                            focusedIndicatorColor = Color(0xFF00BFFF),
                            unfocusedIndicatorColor = Color(0xFF00BFFF)
                        )
                    )
                }
            }
        },
        confirmButton = {
            if (itemsInCart.isNotEmpty()) {
                Button(
                    onClick = {
                        isPlacingOrder = true
                        val orderId = UUID.randomUUID().toString()

                        val orderDetails = hashMapOf(
                            "food" to itemsInCart.keys.joinToString(","),
                            "foodNames" to selectedMenuItems.joinToString(",") { it.name },
                            "observations" to observations,
                            "payment" to paymentMethod,
                            "price" to finalPrice, // Use the finalPrice (with combined discounts) here!
                            "quantities" to itemsInCart.values.joinToString(","),
                            "status" to "placed",
                            "table" to tableId,
                            "timestamp" to System.currentTimeMillis(),
                            "orderPosition" to ServerValue.TIMESTAMP,
                            "currency" to currency,
                            "discountApplied" to totalDiscountPercent // Add the total combined discount percentage
                        )

                        orderRef?.child(orderId)?.setValue(orderDetails)
                            ?.addOnCompleteListener { task ->
                                isPlacingOrder = false
                                if (task.isSuccessful) {
                                    // Optionally clear the active voucher discount after placing the order
                                    userId?.let {
                                        database.getReference("users").child(it).child("activeDiscount").removeValue()
                                            .addOnSuccessListener {
                                                Log.d("CartDialog", "Active voucher discount cleared for user $it")
                                            }
                                            .addOnFailureListener { e ->
                                                Log.e("CartDialog", "Failed to clear active voucher discount: ${e.message}", e)
                                            }
                                    }
                                    cartItems.clear()
                                    onOrderPlaced()
                                    onDismiss()
                                } else {
                                    Toast.makeText(
                                        context,
                                        "Error placing order: ${task.exception?.message}",
                                        Toast.LENGTH_LONG
                                    ).show()
                                }
                            }
                    },
                    enabled = !isPlacingOrder,
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFF00BFFF),
                        contentColor = Color.White
                    )
                ) {
                    if (isPlacingOrder) {
                        CircularProgressIndicator(
                            modifier = Modifier.size(20.dp),
                            color = Color.White,
                            strokeWidth = 2.dp
                        )
                    } else {
                        Text("Place Order")
                    }
                }
            }
        },
        dismissButton = {
            if (!isPlacingOrder) {
                TextButton(
                    onClick = onDismiss,
                    colors = ButtonDefaults.textButtonColors(
                        contentColor = Color(0xFF00BFFF)
                    )
                ) {
                    Text("Close")
                }
            }
        },
        containerColor = Color.White,
        tonalElevation = 8.dp
    )
}

data class MenuItem(
    val id: String,
    val name: String,
    val photo: String,
    val price: String,
    val ingredients: String,
    val quantities: String,
    val isAvailable: Boolean = true,
    val category: String = "Other",
    val calories: String = "0",
    val protein: String = "0g",
    val carbs: String = "0g",
    val fats: String = "0g",
    val allergens: String = "No allergens declared",
    val nutritional: String = "No nutritional information available"
)