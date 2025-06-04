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
import com.google.gson.Gson
import kotlinx.coroutines.*
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.RequestBody.Companion.toRequestBody
import java.util.*

@Composable
fun MeniuScreen(navController: NavController, tableId: String) {
    val context = LocalContext.current
    val auth = FirebaseAuth.getInstance()
    val userId = auth.currentUser?.uid
    val database = FirebaseDatabase.getInstance()
    val menuRef = userId?.let { database.getReference("kitchen").child(it).child("menu").child("list") }
    val orderRef = userId?.let { database.getReference("kitchen").child(it).child("menu").child("orders").child("list") }

    val menuItems = remember { mutableStateListOf<MenuItem>() }
    val cartItems = remember { mutableStateMapOf<String, Int>() }
    var showCart by remember { mutableStateOf(false) }
    var showThankYou by remember { mutableStateOf(false) }
    var foodRecommendation by remember { mutableStateOf("Spune-mi preferințele tale și îți voi recomanda ceva din meniu!") }
    var showRecommendationDialog by remember { mutableStateOf(false) }
    var userMessage by remember { mutableStateOf("") }
    var showCancelDialog by remember { mutableStateOf(false) }
    var lastOrderSnapshot by remember { mutableStateOf<DataSnapshot?>(null) }
    var showCancelButton by remember { mutableStateOf(false) }
    var isLoadingRecommendation by remember { mutableStateOf(false) }

    LaunchedEffect(Unit) {
        menuRef?.addValueEventListener(object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                menuItems.clear()
                snapshot.children.forEach { itemSnapshot ->
                    val id = itemSnapshot.key ?: return@forEach
                    val isAvailable = itemSnapshot.child("menuAvailability").getValue(Boolean::class.java) ?: true

                    if (isAvailable) {
                        val name = itemSnapshot.child("name").getValue(String::class.java) ?: "Unknown"
                        val photo = itemSnapshot.child("photo").getValue(String::class.java) ?: ""
                        val price = itemSnapshot.child("price").getValue(String::class.java) ?: "0.0"
                        val ingredients = itemSnapshot.child("ingredients").getValue(String::class.java) ?: ""
                        val quantities = itemSnapshot.child("quantities").getValue(String::class.java) ?: ""

                        menuItems.add(MenuItem(id, name, photo, price, ingredients, quantities, isAvailable))
                    }
                }
            }

            override fun onCancelled(error: DatabaseError) {
                Log.e("Firebase", "Failed to read menu", error.toException())
            }
        })
    }

    LaunchedEffect(Unit) {
        orderRef?.addValueEventListener(object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                val lastOrder = snapshot.children.lastOrNull()
                val status = lastOrder?.child("status")?.getValue(String::class.java)
                showCancelButton = status == "placed" || status == "pending"
                lastOrderSnapshot = lastOrder
            }

            override fun onCancelled(error: DatabaseError) {
                Log.e("Firebase", "Failed to read orders", error.toException())
            }
        })
    }

    LaunchedEffect(showThankYou) {
        if (showThankYou) {
            delay(5000)
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
                        .padding(16.dp)
                        .verticalScroll(rememberScrollState())
                ) {
                    Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.End) {
                        IconButton(onClick = { showCart = true }) {
                            Icon(imageVector = Icons.Default.ShoppingCart, contentDescription = "Cart")
                            if (cartItems.any { it.value > 0 }) {
                                Badge {
                                    Text(text = cartItems.values.sum().toString())
                                }
                            }
                        }
                    }

                    menuItems.forEach { item ->
                        MenuItemCard(item, cartItems)
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    Button(
                        onClick = { showRecommendationDialog = true },
                        modifier = Modifier.fillMaxWidth().padding(8.dp),
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF003366))
                    ) {
                        Text("Obține recomandare personalizată", color = Color.White)
                    }

                    if (isLoadingRecommendation) {
                        CircularProgressIndicator(modifier = Modifier.align(Alignment.CenterHorizontally))
                    } else {
                        Text(
                            text = foodRecommendation,
                            color = Color(0xFF00BFFF),
                            fontSize = 16.sp,
                            modifier = Modifier.padding(8.dp)
                        )
                    }

                    Spacer(modifier = Modifier.height(100.dp))
                }

                if (showThankYou) {
                    ThankYouDialog()
                }

                if (showCancelButton) {
                    Button(
                        onClick = { showCancelDialog = true },
                        modifier = Modifier
                            .align(Alignment.BottomCenter)
                            .fillMaxWidth()
                            .padding(16.dp),
                        colors = ButtonDefaults.buttonColors(containerColor = Color.Red)
                    ) {
                        Text("Anulează ultima comandă", color = Color.White)
                    }
                }
            }
        }
    )

    if (showCart) {
        CartDialog(
            cartItems = cartItems,
            menuItems = menuItems,
            userId = userId,
            tableId = tableId,
            onDismiss = { showCart = false },
            onOrderPlaced = { showThankYou = true }
        )
    }

    if (showRecommendationDialog) {
        RecommendationDialog(
            userMessage = userMessage,
            onMessageChange = { userMessage = it },
            onDismiss = { showRecommendationDialog = false },
            onSubmit = {
                isLoadingRecommendation = true
                fetchDeepSeekRecommendation(
                    context = context,
                    userMessage = userMessage,
                    menuItems = menuItems,
                    onSuccess = { recommendation ->
                        foodRecommendation = recommendation
                        showRecommendationDialog = false
                        isLoadingRecommendation = false
                    },
                    onFailure = { error ->
                        foodRecommendation = "Eroare: $error\n${getFallbackRecommendation(menuItems)}"
                        showRecommendationDialog = false
                        isLoadingRecommendation = false
                    }
                )
            },
            isLoading = isLoadingRecommendation
        )
    }

    if (showCancelDialog && lastOrderSnapshot != null) {
        CancelOrderDialog(
            orderSnapshot = lastOrderSnapshot!!,
            onDismiss = {
                showCancelDialog = false
                showCancelButton = false
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
                    "Comandă plasată cu succes!",
                    color = Color(0xFF00BFFF),
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Bold
                )
                Spacer(modifier = Modifier.height(16.dp))
                Text(
                    "Vă mulțumim!",
                    fontSize = 18.sp
                )
            }
        }
    }
}

@Composable
fun MenuItemCard(item: MenuItem, cartItems: MutableMap<String, Int>) {
    var quantity by remember { mutableStateOf(cartItems[item.id] ?: 0) }

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
                    contentDescription = "Imagine ${item.name}",
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(180.dp)
                        .padding(bottom = 8.dp)
                )
            }

            Text(
                text = item.name,
                color = Color(0xFF003366),
                fontSize = 20.sp,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(4.dp))

            Text(
                text = "${item.price} lei",
                color = Color(0xFF00BFFF),
                fontSize = 16.sp
            )

            Spacer(modifier = Modifier.height(8.dp))

            Text(
                text = item.ingredients,
                color = Color.Gray,
                fontSize = 14.sp
            )

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
}

@Composable
private fun QuantitySelector(currentQuantity: Int, onQuantityChange: (Int) -> Unit) {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.Center
    ) {
        IconButton(
            onClick = { if (currentQuantity > 0) onQuantityChange(currentQuantity - 1) },
            modifier = Modifier.size(48.dp)
        ) {
            Text("-", fontSize = 24.sp, color = Color(0xFF003366))
        }

        Text(
            text = currentQuantity.toString(),
            modifier = Modifier.padding(horizontal = 16.dp),
            fontSize = 20.sp,
            color = Color(0xFF003366)
        )

        IconButton(
            onClick = { onQuantityChange(currentQuantity + 1) },
            modifier = Modifier.size(48.dp)
        ) {
            Text("+", fontSize = 24.sp, color = Color(0xFF003366))
        }
    }
}

@Composable
fun CartDialog(
    cartItems: MutableMap<String, Int>,
    menuItems: List<MenuItem>,
    userId: String?,
    tableId: String,
    onDismiss: () -> Unit,
    onOrderPlaced: () -> Unit
) {
    val database = FirebaseDatabase.getInstance()
    val orderRef = userId?.let {
        database.getReference("kitchen").child(it).child("menu").child("orders").child("list")
    }

    val context = LocalContext.current
    var paymentMethod by remember { mutableStateOf("Card") }
    var observations by remember { mutableStateOf("") }
    var isPlacingOrder by remember { mutableStateOf(false) }

    val itemsInCart = cartItems.filterValues { it > 0 }
    val selectedMenuItems = menuItems.filter { itemsInCart.containsKey(it.id) }

    val totalPrice = selectedMenuItems.sumOf { item ->
        val quantity = itemsInCart[item.id] ?: 0
        item.price.toDoubleOrNull() ?: 0.0 * quantity
    }

    AlertDialog(
        onDismissRequest = { if (!isPlacingOrder) onDismiss() },
        title = {
            Text(
                text = "Coș de cumpărături",
                color = Color(0xFF003366),
                fontWeight = FontWeight.Bold
            )
        },
        text = {
            if (itemsInCart.isEmpty()) {
                Text("Coșul tău este gol.", modifier = Modifier.padding(16.dp))
            } else {
                Column {
                    selectedMenuItems.forEach { item ->
                        val quantity = itemsInCart[item.id] ?: 0
                        Row(
                            modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text("${item.name} x$quantity")
                            Text("${(item.price.toDoubleOrNull() ?: 0.0) * quantity} lei")
                        }
                    }

                    Divider(modifier = Modifier.padding(vertical = 8.dp))

                    Row(
                        modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text("Total:", fontWeight = FontWeight.Bold)
                        Text("${"%.2f".format(totalPrice)} lei", fontWeight = FontWeight.Bold)
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    Text("Metodă de plată:", fontWeight = FontWeight.SemiBold)
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        RadioButton(
                            selected = paymentMethod == "Card",
                            onClick = { paymentMethod = "Card" }
                        )
                        Text("Card", modifier = Modifier.padding(start = 4.dp))

                        Spacer(modifier = Modifier.width(16.dp))

                        RadioButton(
                            selected = paymentMethod == "Cash",
                            onClick = { paymentMethod = "Cash" }
                        )
                        Text("Cash", modifier = Modifier.padding(start = 4.dp))
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    Text("Observații:", fontWeight = FontWeight.SemiBold)
                    OutlinedTextField(
                        value = observations,
                        onValueChange = { observations = it },
                        modifier = Modifier.fillMaxWidth(),
                        placeholder = { Text("Ex: fără ceapă, extra picant...") },
                        singleLine = true
                    )
                }
            }
        },
        confirmButton = {
            if (itemsInCart.isNotEmpty()) {
                Button(
                    onClick = {
                        isPlacingOrder = true
                        val orderId = orderRef?.push()?.key ?: UUID.randomUUID().toString()
                        val orderDetails = hashMapOf(
                            "id" to orderId,
                            "table" to tableId,
                            "items" to itemsInCart.mapKeys { entry ->
                                menuItems.find { it.id == entry.key }?.name ?: "Unknown"
                            },
                            "totalPrice" to totalPrice,
                            "status" to "placed",
                            "paymentMethod" to paymentMethod,
                            "observations" to observations,
                            "timestamp" to System.currentTimeMillis()
                        )

                        orderRef?.child(orderId)?.setValue(orderDetails)
                            ?.addOnCompleteListener { task ->
                                isPlacingOrder = false
                                if (task.isSuccessful) {
                                    cartItems.clear()
                                    onOrderPlaced()
                                    onDismiss()
                                } else {
                                    Toast.makeText(
                                        context,
                                        "Eroare la plasarea comenzii",
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                            }
                    },
                    enabled = !isPlacingOrder
                ) {
                    if (isPlacingOrder) {
                        CircularProgressIndicator(
                            modifier = Modifier.size(20.dp),
                            color = Color.White,
                            strokeWidth = 2.dp
                        )
                    } else {
                        Text("Plasează comanda")
                    }
                }
            }
        },
        dismissButton = {
            if (!isPlacingOrder) {
                Button(onClick = onDismiss) {
                    Text("Închide")
                }
            }
        }
    )
}

@Composable
fun RecommendationDialog(
    userMessage: String,
    onMessageChange: (String) -> Unit,
    onDismiss: () -> Unit,
    onSubmit: () -> Unit,
    isLoading: Boolean
) {
    AlertDialog(
        onDismissRequest = { if (!isLoading) onDismiss() },
        title = {
            Text(
                text = "Recomandare personalizată",
                color = Color(0xFF003366),
                fontWeight = FontWeight.Bold
            )
        },
        text = {
            Column {
                Text(
                    "Spune-ne ce preferințe ai (ex: 'vegetarian', 'fără lactate', 'picant')",
                    modifier = Modifier.padding(bottom = 8.dp)
                )
                OutlinedTextField(
                    value = userMessage,
                    onValueChange = onMessageChange,
                    modifier = Modifier.fillMaxWidth(),
                    placeholder = { Text("Introdu preferințele tale aici...") },
                    enabled = !isLoading
                )
            }
        },
        confirmButton = {
            Button(
                onClick = onSubmit,
                enabled = userMessage.isNotBlank() && !isLoading
            ) {
                if (isLoading) {
                    CircularProgressIndicator(
                        modifier = Modifier.size(20.dp),
                        color = Color.White,
                        strokeWidth = 2.dp
                    )
                } else {
                    Text("Obține recomandare")
                }
            }
        },
        dismissButton = {
            if (!isLoading) {
                Button(onClick = onDismiss) {
                    Text("Anulează")
                }
            }
        }
    )
}

@Composable
fun CancelOrderDialog(
    orderSnapshot: DataSnapshot,
    onDismiss: () -> Unit
) {
    val context = LocalContext.current
    var isCanceling by remember { mutableStateOf(false) }
    val order = remember(orderSnapshot) {
        orderSnapshot.getValue(Order::class.java) ?: Order()
    }

    val surcharge = order.totalPrice * 0.2

    AlertDialog(
        onDismissRequest = { if (!isCanceling) onDismiss() },
        title = {
            Text(
                text = "Anulare comandă",
                color = Color.Red,
                fontWeight = FontWeight.Bold
            )
        },
        text = {
            Column {
                Text("Detalii comandă:", fontWeight = FontWeight.SemiBold)
                Spacer(modifier = Modifier.height(8.dp))

                order.items?.forEach { (itemName, quantity) ->
                    Text("• $itemName x$quantity")
                }

                Spacer(modifier = Modifier.height(8.dp))
                Text("Total: ${"%.2f".format(order.totalPrice)} lei")
                Spacer(modifier = Modifier.height(16.dp))

                if (order.status == "pending") {
                    Text(
                        "Atenție: Anularea acestei comenzi va atrage o taxă de 20% (${"%.2f".format(surcharge)} lei)",
                        color = Color.Red,
                        fontWeight = FontWeight.Bold
                    )
                }
            }
        },
        confirmButton = {
            Button(
                onClick = {
                    isCanceling = true
                    val newStatus = if (order.status == "pending") "canceled_with_fee" else "canceled"
                    orderSnapshot.ref.child("status").setValue(newStatus)
                        .addOnCompleteListener {
                            isCanceling = false
                            if (it.isSuccessful) {
                                Toast.makeText(
                                    context,
                                    if (order.status == "pending")
                                        "Comandă anulată. Taxa de ${"%.2f".format(surcharge)} lei va fi aplicată."
                                    else
                                        "Comandă anulată cu succes",
                                    Toast.LENGTH_LONG
                                ).show()
                                onDismiss()
                            }
                        }
                },
                colors = ButtonDefaults.buttonColors(containerColor = Color.Red),
                enabled = !isCanceling
            ) {
                if (isCanceling) {
                    CircularProgressIndicator(
                        modifier = Modifier.size(20.dp),
                        color = Color.White,
                        strokeWidth = 2.dp
                    )
                } else {
                    Text("Confirmă anularea")
                }
            }
        },
        dismissButton = {
            if (!isCanceling) {
                Button(onClick = onDismiss) {
                    Text("Înapoi")
                }
            }
        }
    )
}

// Funcții pentru recomandări DeepSeek
private fun fetchDeepSeekRecommendation(
    context: Context,
    userMessage: String,
    menuItems: List<MenuItem>,
    onSuccess: (String) -> Unit,
    onFailure: (String) -> Unit
) {
    CoroutineScope(Dispatchers.IO).launch {
        try {
            val availableItems = menuItems.filter { it.isAvailable }
            if (availableItems.isEmpty()) {
                onFailure("Nu sunt preparate disponibile în meniu")
                return@launch
            }

            val recommendation = DeepSeekApi.getRecommendation(
                context = context,
                userMessage = userMessage,
                menuItems = availableItems
            )

            withContext(Dispatchers.Main) {
                onSuccess(recommendation)
            }
        } catch (e: Exception) {
            withContext(Dispatchers.Main) {
                onFailure(e.message ?: "Eroare necunoscută")
            }
        }
    }
}

private fun getFallbackRecommendation(menuItems: List<MenuItem>): String {
    val availableItems = menuItems.filter { it.isAvailable }
    return if (availableItems.isNotEmpty()) {
        val randomItem = availableItems.random()
        "Recomandare: ${randomItem.name} - ${randomItem.ingredients}"
    } else {
        "Nu sunt preparate disponibile în meniu"
    }
}

// Modele de date
data class MenuItem(
    val id: String,
    val name: String,
    val photo: String,
    val price: String,
    val ingredients: String,
    val quantities: String,
    val isAvailable: Boolean = true
)

data class Order(
    val id: String = "",
    val table: String = "",
    val items: Map<String, Int> = emptyMap(),
    val totalPrice: Double = 0.0,
    val status: String = "",
    val paymentMethod: String = "",
    val observations: String = "",
    val timestamp: Long = 0L
)

object DeepSeekApi {
    private const val API_KEY = "sk-71a1b4376efb466e88aeb96cb6888244" // Înlocuiește cu cheia ta reală
    private const val BASE_URL = "https://api.deepseek.com/v1/"
    private val client = OkHttpClient()
    private val gson = Gson()

    suspend fun getRecommendation(
        context: Context,
        userMessage: String,
        menuItems: List<MenuItem>
    ): String {
        val menuContext = buildMenuContext(menuItems)

        val messages = listOf(
            Message(
                role = "system",
                content = """
                Ești asistentul unui restaurant sofisticat. 
                Meniul disponibil este:
                $menuContext
                
                Reguli stricte:
                1. Recomandă DOAR preparate din lista de mai sus
                2. Menționează ingredientele principale
                3. Explică de ce ai ales acel preparat (max 2 propoziții)
                4. Dacă cererea nu se potrivește, sugerează ceva similar din meniu
                5. Răspunsul să fie în limba română
                """.trimIndent()
            ),
            Message(
                role = "user",
                content = userMessage
            )
        )

        val requestBody = gson.toJson(
            ChatRequest(
                model = "deepseek-chat",
                messages = messages,
                max_tokens = 200,
                temperature = 0.7
            )
        )

        val request = Request.Builder()
            .url("${BASE_URL}chat/completions")
            .post(requestBody.toRequestBody("application/json".toMediaType()))
            .addHeader("Authorization", "Bearer $API_KEY")
            .addHeader("Content-Type", "application/json")
            .build()

        val response = withContext(Dispatchers.IO) {
            client.newCall(request).execute()
        }

        if (!response.isSuccessful) {
            throw Exception("Eroare API: ${response.code}")
        }

        val responseBody = response.body?.string() ?: throw Exception("Răspuns gol")
        val chatResponse = gson.fromJson(responseBody, ChatResponse::class.java)

        return chatResponse.choices.firstOrNull()?.message?.content
            ?: throw Exception("Nu am putut genera recomandarea")
    }

    private fun buildMenuContext(menuItems: List<MenuItem>): String {
        return menuItems.joinToString("\n") { item ->
            "- ${item.name} (${item.price} lei): ${item.ingredients}"
        }
    }

    private data class ChatRequest(
        val model: String,
        val messages: List<Message>,
        val max_tokens: Int,
        val temperature: Double = 0.7
    )

    private data class Message(
        val role: String,
        val content: String
    )

    private data class ChatResponse(
        val choices: List<Choice>
    )

    private data class Choice(
        val message: Message
    )
}