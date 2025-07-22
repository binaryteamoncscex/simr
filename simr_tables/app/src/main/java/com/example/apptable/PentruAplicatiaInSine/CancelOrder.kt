package com.example.apptable.PentruAplicatiaInSine

import android.util.Log
import android.widget.Toast
import androidx.compose.animation.animateContentSize
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
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
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.*
import com.google.firebase.database.ktx.database
import com.google.firebase.ktx.Firebase

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun OrderCancellationScreen(navController: NavController, tableId: String) {
    val context = LocalContext.current
    val auth = FirebaseAuth.getInstance()
    val userId = auth.currentUser?.uid
    val database = Firebase.database
    val ordersRef = userId?.let { database.getReference("kitchen").child(it).child("menu").child("orders").child("list") }

    val activeOrders = remember { mutableStateListOf<DataSnapshot>() }
    var isLoadingOrders by remember { mutableStateOf(true) }


    var showCancelConfirmationDialog by remember { mutableStateOf(false) }
    var orderToCancelSnapshot by remember { mutableStateOf<DataSnapshot?>(null) }

    DisposableEffect(Unit) {
        if (userId == null) {
            Toast.makeText(context, "Eroare: Utilizator neautentificat.", Toast.LENGTH_SHORT).show()
            navController.popBackStack()

            return@DisposableEffect object : DisposableEffectResult {
                override fun dispose() {

                }
            }

        }

        val query = ordersRef?.orderByChild("table")?.equalTo(tableId)
        val listener = object : ValueEventListener {
            override fun onDataChange(snapshot: DataSnapshot) {
                activeOrders.clear()
                snapshot.children.forEach { orderSnapshot ->
                    val status = orderSnapshot.child("status").getValue(String::class.java)
                    if (status != "completed" && status != "canceled" && status != "canceled_with_fee") {
                        activeOrders.add(orderSnapshot)
                    }
                }
                isLoadingOrders = false
            }

            override fun onCancelled(error: DatabaseError) {
                Log.e("Firebase", "Failed to load orders for cancellation", error.toException())
                Toast.makeText(context, "Eroare la încărcarea comenzilor: ${error.message}", Toast.LENGTH_LONG).show()
                isLoadingOrders = false
            }
        }
        query?.addValueEventListener(listener)

        onDispose {
            query?.removeEventListener(listener)
        }
    }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Anulează Comenzi pentru Masa $tableId", color = Color(0xFF003366)) },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.Filled.ArrowBack, "Back", tint = Color(0xFF00BFFF))
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = Color.White,
                    titleContentColor = Color(0xFF003366)
                )
            )
        },
        containerColor = Color.White
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(horizontal = 16.dp, vertical = 8.dp)
        ) {
            if (isLoadingOrders) {
                CircularProgressIndicator(modifier = Modifier.align(Alignment.CenterHorizontally).padding(16.dp))
                Text("Se încarcă comenzile...", modifier = Modifier.align(Alignment.CenterHorizontally))
            } else if (activeOrders.isEmpty()) {
                Text(
                    "Nu există comenzi active de anulat pentru masa $tableId.",
                    modifier = Modifier.fillMaxWidth().padding(16.dp),
                    textAlign = androidx.compose.ui.text.style.TextAlign.Center,
                    color = Color(0xFF003366)
                )
            } else {
                Text(
                    "Apasă pe o comandă pentru a o anula.",
                    modifier = Modifier.fillMaxWidth().padding(bottom = 8.dp),
                    textAlign = androidx.compose.ui.text.style.TextAlign.Center,
                    color = Color.Gray
                )
                LazyColumn(
                    modifier = Modifier.fillMaxSize(),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    items(activeOrders, key = { it.key!! }) { orderSnapshot ->
                        OrderCardForCancellation(orderSnapshot) {
                            orderToCancelSnapshot = orderSnapshot
                            showCancelConfirmationDialog = true
                        }
                    }
                }
            }
        }
    }

    if (showCancelConfirmationDialog && orderToCancelSnapshot != null) {
        CancelOrderConfirmationDialog(
            orderSnapshot = orderToCancelSnapshot!!,
            onDismiss = {
                showCancelConfirmationDialog = false
                orderToCancelSnapshot = null
            },
            onCancelSuccess = {
                showCancelConfirmationDialog = false
                orderToCancelSnapshot = null
            }
        )
    }
}

@Composable
fun OrderCardForCancellation(orderSnapshot: DataSnapshot, onClick: () -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp)
            .clickable(onClick = onClick),
        elevation = CardDefaults.cardElevation(4.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            val orderId = orderSnapshot.key ?: "N/A"
            val totalPrice = orderSnapshot.child("price").getValue(Double::class.java) ?: 0.0
            val status = orderSnapshot.child("status").getValue(String::class.java) ?: "unknown"
            val foodNames = orderSnapshot.child("foodNames").getValue(String::class.java)?.split(",")?.filter { it.isNotBlank() } ?: emptyList()
            val quantitiesStr = orderSnapshot.child("quantities").getValue(String::class.java) ?: ""
            val quantities = quantitiesStr.chunked(4).map { it.toIntOrNull() ?: 0 }

            Text("Comanda ID: ${orderId.take(8)}...", fontWeight = FontWeight.Bold, color = Color(0xFF003366))
            Spacer(modifier = Modifier.height(4.dp))

            foodNames.forEachIndexed { index, name ->
                if (index < quantities.size) {
                    Text("• $name x${quantities[index]}", color = Color.Gray, fontSize = 14.sp)
                }
            }

            Spacer(modifier = Modifier.height(8.dp))
            Text("Total: ${"%.2f".format(totalPrice)} lei", color = Color(0xFF00BFFF), fontWeight = FontWeight.Bold)
            Text("Status: $status", color = Color(0xFF003366), fontSize = 14.sp)

            if (status == "pending") {
                val surcharge = totalPrice * 0.2
                Text("Taxă de anulare estimată: ${"%.2f".format(surcharge)} lei", color = Color(0xFFF44336), fontWeight = FontWeight.SemiBold, fontSize = 14.sp)
            }
        }
    }
}

@Composable
fun CancelOrderConfirmationDialog(
    orderSnapshot: DataSnapshot,
    onDismiss: () -> Unit,
    onCancelSuccess: () -> Unit
) {
    val context = LocalContext.current
    var isCanceling by remember { mutableStateOf(false) }

    val orderId = orderSnapshot.key ?: ""
    val totalPrice = orderSnapshot.child("price").getValue(Double::class.java) ?: 0.0
    val status = orderSnapshot.child("status").getValue(String::class.java) ?: ""
    val foodNames = orderSnapshot.child("foodNames").getValue(String::class.java)?.split(",")?.filter { it.isNotBlank() } ?: emptyList()
    val quantitiesStr = orderSnapshot.child("quantities").getValue(String::class.java) ?: ""
    val paymentMethod = orderSnapshot.child("payment").getValue(String::class.java) ?: ""
    val observations = orderSnapshot.child("observations").getValue(String::class.java) ?: ""
    val table = orderSnapshot.child("table").getValue(String::class.java) ?: ""

    val quantities = quantitiesStr.chunked(4).map { it.toIntOrNull() ?: 0 }
    val surcharge = if (status == "pending") totalPrice * 0.2 else 0.0

    AlertDialog(
        onDismissRequest = { if (!isCanceling) onDismiss() },
        title = {
            Text(
                text = when (status) {
                    "completed" -> "Comandă finalizată"
                    "canceled", "canceled_with_fee" -> "Comandă anulată"
                    else -> "Anulare comandă"
                },
                color = Color(0xFF00BFFF),
                fontWeight = FontWeight.Bold
            )
        },
        text = {
            Column {
                Text("Detalii comandă:", fontWeight = FontWeight.SemiBold, color = Color(0xFF003366))
                Spacer(modifier = Modifier.height(8.dp))

                foodNames.forEachIndexed { index, name ->
                    if (index < quantities.size) {
                        Text("• $name x${quantities[index]}", color = Color(0xFF003366))
                    }
                }

                Spacer(modifier = Modifier.height(8.dp))

                Text("Metodă plată: $paymentMethod", color = Color(0xFF003366))
                if (observations.isNotBlank()) {
                    Text("Observații: $observations", color = Color(0xFF003366))
                }

                Spacer(modifier = Modifier.height(8.dp))
                Text("Total: ${"%.2f".format(totalPrice)} lei",
                    color = Color(0xFF00BFFF),
                    fontWeight = FontWeight.Bold)

                Spacer(modifier = Modifier.height(16.dp))
                when (status) {
                    "pending" -> Text(
                        "Atenție: Anularea va atrage o taxă de 20% (${"%.2f".format(surcharge)} lei)",
                        color = Color(0xFFF44336),
                        fontWeight = FontWeight.Bold
                    )
                    "canceled_with_fee" -> Text(
                        "Taxa de anulare: ${"%.2f".format(surcharge)} lei",
                        color = Color(0xFF00BFFF)
                    )
                }
            }
        },
        confirmButton = {
            if (status == "placed" || status == "pending") {
                Button(
                    onClick = {
                        isCanceling = true
                        val newStatus = if (status == "pending") "canceled_with_fee" else "canceled"

                        val updates = hashMapOf<String, Any>(
                            "status" to newStatus,
                            "canceledAt" to ServerValue.TIMESTAMP
                        )

                        orderSnapshot.ref.updateChildren(updates)
                            .addOnCompleteListener { task ->
                                isCanceling = false
                                if (task.isSuccessful) {
                                    Toast.makeText(
                                        context,
                                        if (newStatus == "canceled_with_fee")
                                            "Comandă anulată. Taxa aplicată: ${"%.2f".format(surcharge)} lei"
                                        else
                                            "Comandă anulată cu succes",
                                        Toast.LENGTH_LONG
                                    ).show()
                                    onCancelSuccess()
                                } else {
                                    Toast.makeText(
                                        context,
                                        "Eroare: ${task.exception?.message ?: "Nu s-a putut anula comanda"}",
                                        Toast.LENGTH_LONG
                                    ).show()
                                }
                            }
                    },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFFD32F2F),
                        contentColor = Color.White
                    ),
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
            }
        },
        dismissButton = {
            TextButton(
                onClick = onDismiss,
                colors = ButtonDefaults.textButtonColors(
                    contentColor = Color(0xFF00BFFF)
                )
            ) {
                Text(if (status == "completed" || status == "canceled" || status == "canceled_with_fee") "OK" else "Înapoi")
            }
        },
        containerColor = Color.White
    )
}