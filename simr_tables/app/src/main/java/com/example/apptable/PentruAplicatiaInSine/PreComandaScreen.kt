package com.example.apptable.PentruAplicatiaInSine

import android.content.Context
import android.util.Log
import android.widget.Toast
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import coil.compose.AsyncImage
import com.google.firebase.Firebase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.ValueEventListener
import com.google.firebase.database.database
import com.google.firebase.database.FirebaseDatabase
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.util.Properties
import java.util.UUID
import javax.mail.Authenticator
import javax.mail.Message
import javax.mail.PasswordAuthentication
import javax.mail.Session
import javax.mail.Transport
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeMessage


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun PreComandaScreen(navController: NavController, tableId: String) {
    val context = LocalContext.current
    val auth = FirebaseAuth.getInstance()
    val userId = auth.currentUser?.uid
    val database = Firebase.database
    val coroutineScope = rememberCoroutineScope()

    val menuRef = userId?.let { database.getReference("kitchen").child(it).child("menu").child("list") }
    val orderRef = userId?.let { database.getReference("kitchen").child(it).child("menu").child("orders").child("list") }
    val userCurrencyRef = userId?.let { database.getReference("users").child(it).child("currency") }


    val fidelityCardListRef = userId?.let { database.getReference("users").child(it).child("FidelityCard").child("list") }

    val menuItems = remember { mutableStateListOf<MenuItem>() }
    var currentImageIndex by remember { mutableStateOf(0) }
    var hasCancelableOrders by remember { mutableStateOf(false) }
    var currencySymbol by remember { mutableStateOf("lei") }

    var showFidelityCardDialog by remember { mutableStateOf(false) }
    var fidelityCardNumber by remember { mutableStateOf("") }


    DisposableEffect(Unit) {
        if (menuRef != null) {
            val listener = object : ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    val newItems = mutableListOf<MenuItem>()
                    snapshot.children.forEach { itemSnapshot ->
                        val id = itemSnapshot.key ?: return@forEach
                        val isAvailable = itemSnapshot.child("menuAvailability").getValue(Boolean::class.java) ?: true

                        newItems.add(
                            MenuItem(
                                id = id,
                                name = itemSnapshot.child("name").getValue(String::class.java) ?: "Unknown",
                                photo = itemSnapshot.child("photo").getValue(String::class.java) ?: "",
                                price = itemSnapshot.child("price").getValue(String::class.java) ?: "0.0",
                                ingredients = itemSnapshot.child("ingredients").getValue(String::class.java) ?: "",
                                quantities = itemSnapshot.child("quantities").getValue(String::class.java) ?: "",
                                isAvailable = isAvailable
                            )
                        )

                    }
                    menuItems.clear()
                    menuItems.addAll(newItems)
                }

                override fun onCancelled(error: DatabaseError) {
                    Log.e("Firebase", "Failed to read menu", error.toException())
                }
            }

            menuRef.addValueEventListener(listener)

            onDispose {
                menuRef.removeEventListener(listener)
            }
        } else {
            onDispose { }
        }
    }


    DisposableEffect(Unit) {
        if (orderRef != null) {
            val query = orderRef.orderByChild("table").equalTo(tableId)
            val listener = object : ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    val cancelableOrders = snapshot.children.filter { order ->
                        val status = order.child("status").getValue(String::class.java)
                        status == "placed" || status == "pending"
                    }
                    hasCancelableOrders = cancelableOrders.isNotEmpty()
                }

                override fun onCancelled(error: DatabaseError) {
                    Log.e("Firebase", "Failed to read orders for cancellation check: ${error.message}", error.toException())
                    hasCancelableOrders = false
                }
            }
            query.addValueEventListener(listener)

            onDispose {
                query.removeEventListener(listener)
            }
        } else {
            onDispose { }
        }
    }


    DisposableEffect(Unit) {
        if (userCurrencyRef != null) {
            val listener = object : ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    currencySymbol = snapshot.getValue(Any::class.java)?.toString() ?: "lei"
                }

                override fun onCancelled(error: DatabaseError) {
                    Log.e("Firebase", "Failed to read currency symbol: ${error.message}", error.toException())
                    currencySymbol = "lei"
                }
            }
            userCurrencyRef.addValueEventListener(listener)

            onDispose {
                userCurrencyRef.removeEventListener(listener)
            }
        } else {
            onDispose { }
        }
    }


    LaunchedEffect(menuItems.size) {
        if (menuItems.isNotEmpty()) {
            while (true) {
                delay(2000)
                currentImageIndex = (currentImageIndex + 1) % menuItems.size
            }
        }
    }

    Scaffold(
        modifier = Modifier.fillMaxSize(),
        topBar = {
            TopAppBar(
                title = {
                    Text(
                        if (tableId == "drive") "Drive Thru Preview"
                        else "Table $tableId Preview"
                    )
                },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back")
                    }
                }
            )
        },
        content = { innerPadding ->
            Column(
                modifier = Modifier
                    .padding(innerPadding)
                    .fillMaxSize()
            ) {

                if (menuItems.isNotEmpty()) {
                    val currentItem = menuItems[currentImageIndex]

                    Column(
                        modifier = Modifier
                            .fillMaxWidth()
                            .weight(1f)
                            .padding(16.dp),
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.Center
                    ) {
                        if (currentItem.photo.isNotBlank()) {
                            AsyncImage(
                                model = currentItem.photo,
                                contentDescription = currentItem.name,
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .height(250.dp),
                                contentScale = ContentScale.Fit
                            )
                        }

                        Spacer(modifier = Modifier.height(16.dp))

                        Text(
                            text = currentItem.name,
                            fontSize = 24.sp,
                            fontWeight = FontWeight.Bold,
                            color = Color(0xFF003366)
                        )

                        Spacer(modifier = Modifier.height(8.dp))

                        Text(
                            text = "${currentItem.price} $currencySymbol",
                            fontSize = 20.sp,
                            color = Color(0xFF00BFFF)
                        )

                    }
                } else {
                    Box(
                        modifier = Modifier
                            .fillMaxSize()
                            .weight(1f),
                        contentAlignment = Alignment.Center
                    ) {
                        CircularProgressIndicator()
                    }
                }


                Button(
                    onClick = {
                        navController.navigate("meniu/$tableId") {
                            popUpTo("precomanda/$tableId") { inclusive = true }
                        }
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp)
                        .height(50.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFF00BFFF),
                        contentColor = Color.White
                    )
                ) {
                    Text("Start Order", fontSize = 18.sp)
                }

                Spacer(modifier = Modifier.height(8.dp))

                Button(
                    onClick = {
                        showFidelityCardDialog = true
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp)
                        .height(50.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFF4CAF50),
                        contentColor = Color.White
                    )
                ) {
                    Text("Fidelity Card", fontSize = 18.sp)
                }

                Spacer(modifier = Modifier.height(8.dp))


                if (hasCancelableOrders) {
                    Button(
                        onClick = {
                            navController.navigate("order_cancellation/$tableId")
                        },
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 16.dp)
                            .height(50.dp),
                        colors = ButtonDefaults.buttonColors(
                            containerColor = Color(0xFFD32F2F),
                            contentColor = Color.White
                        )
                    ) {
                        Text("Anulează Comenzi", fontSize = 18.sp)
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))
            }
        }
    )

    if (showFidelityCardDialog) {
        AlertDialog(
            onDismissRequest = { showFidelityCardDialog = false },
            title = { Text("Fidelity Card", color = Color(0xFF4CAF50), fontWeight = FontWeight.Bold) },
            text = {
                Column {
                    Text(
                        "Please enter your fidelity card number:",
                        modifier = Modifier.padding(bottom = 8.dp),
                        color = Color(0xFF003366)
                    )
                    OutlinedTextField(
                        value = fidelityCardNumber,
                        onValueChange = { fidelityCardNumber = it },
                        label = { Text("Card Number") },
                        modifier = Modifier.fillMaxWidth(),
                        singleLine = true,
                        colors = TextFieldDefaults.colors(
                            focusedContainerColor = Color.White,
                            unfocusedContainerColor = Color.White,
                            focusedTextColor = Color(0xFF003366),
                            unfocusedTextColor = Color(0xFF003366),
                            focusedIndicatorColor = Color(0xFF4CAF50),
                            unfocusedIndicatorColor = Color(0xFF4CAF50)
                        )
                    )
                    Spacer(modifier = Modifier.height(16.dp))
                    TextButton(
                        onClick = {
                            showFidelityCardDialog = false
                            navController.navigate("fidelity_screen")
                        },
                        colors = ButtonDefaults.textButtonColors(
                            contentColor = Color(0xFF00BFFF)
                        )
                    ) {
                        Text("Don't have a fidelity card? Create one!")
                    }
                }
            },
            confirmButton = {
                Button(
                    onClick = {
                        if (userId == null) {

                            coroutineScope.launch(Dispatchers.Main) {
                                Toast.makeText(context, "User not authenticated.", Toast.LENGTH_SHORT).show()
                            }
                            return@Button
                        }
                        if (fidelityCardNumber.isBlank()) {

                            coroutineScope.launch(Dispatchers.Main) {
                                Toast.makeText(context, "Please enter a fidelity card number.", Toast.LENGTH_SHORT).show()
                            }
                            return@Button
                        }

                        coroutineScope.launch {
                            verifyAndIncrementFidelityCard(
                                userId = userId,
                                fidelityCardNumber = fidelityCardNumber,
                                database = database,
                                context = context
                            ) { success ->

                                if (success) {
                                    Toast.makeText(context, "Fidelity card applied!", Toast.LENGTH_SHORT).show()
                                } else {
                                    Toast.makeText(context, "Invalid fidelity card or an error occurred.", Toast.LENGTH_LONG).show()
                                }
                                showFidelityCardDialog = false
                                fidelityCardNumber = ""
                            }
                        }
                    },
                    colors = ButtonDefaults.buttonColors(
                        containerColor = Color(0xFF4CAF50),
                        contentColor = Color.White
                    )
                ) {
                    Text("Apply Card")
                }
            },
            dismissButton = {
                TextButton(
                    onClick = { showFidelityCardDialog = false },
                    colors = ButtonDefaults.textButtonColors(
                        contentColor = Color(0xFFD32F2F)
                    )
                ) {
                    Text("Cancel")
                }
            },
            containerColor = Color.White
        )
    }
}


suspend fun checkAndAwardDiscount(
    userId: String,
    cardCode: String,
    currentUsesAfterIncrement: Int,
    database: FirebaseDatabase,
    context: Context
) = withContext(Dispatchers.IO) {


    val fidelityCardRef = database.getReference("users")
        .child(userId)
        .child("FidelityCard")
        .child("list")
        .child(cardCode)

    val userProfileRef = database.getReference("users").child(userId) // Referință către profilul utilizatorului

    try {
        val cardSnapshot = fidelityCardRef.get().await()
        val userSnapshot = userProfileRef.get().await() // Obținem datele profilului utilizatorului

        // Citim "procent" de sub nodul cardului de fidelitate
        val discountProcent = cardSnapshot.child("procent").getValue(Long::class.java)?.toInt() ?: 0
        val cardEmail = cardSnapshot.child("email").getValue(String::class.java) ?: ""

        // Citim numele utilizatorului de la profil (nu de la cardul de fidelitate)
        val firstName = userSnapshot.child("firstName").getValue(String::class.java) ?: ""
        val lastName = userSnapshot.child("lastName").getValue(String::class.java) ?: ""


        Log.d("FidelityCardDiscount", "Card $cardCode: Uses=$currentUsesAfterIncrement, Procent=$discountProcent")

        // Verificăm dacă "uses" este un multiplu de 5 și este mai mare decât 0
        if (currentUsesAfterIncrement > 0 && currentUsesAfterIncrement % 5 == 0) {
            // Moved to Main Dispatcher
            withContext(Dispatchers.Main) {
                Toast.makeText(context, "Fidelity card uses reached a multiple of 5! Generating discount code.", Toast.LENGTH_SHORT).show()
            }

            val discountCode = UUID.randomUUID().toString().substring(0, 8).uppercase()
            // Calea către DiscountCard (presupunem că NU mai are "DHT")
            val discountCardListRef = database.getReference("users").child(userId).child("DiscountCard").child("list")
            // Valoarea discountului va fi stocată direct sub cod, nu într-un sub-nod "value"
            val discountCardEntryRef = discountCardListRef.child(discountCode)

            // Salvăm noul cod de discount cu valoarea procentuală direct
            // Aici salvăm doar procentul ca valoare directă a codului
            discountCardEntryRef.setValue(discountProcent).await()

            // Apelăm funcția de trimitere email direct din acest fișier
            val emailSent = sendDiscountCodeEmail(context, cardEmail, firstName, lastName, discountCode, discountProcent)

            // Moved to Main Dispatcher
            withContext(Dispatchers.Main) {
                if (emailSent) {
                    Toast.makeText(context, "Discount code '$discountCode' sent to your email!", Toast.LENGTH_LONG).show()
                } else {
                    Toast.makeText(context, "Failed to send discount email.", Toast.LENGTH_LONG).show()
                }
            }
        }
    } catch (e: Exception) {
        Log.e("FidelityCardDiscount", "Error checking uses for discount: ${e.message}", e)
        // Moved to Main Dispatcher
        withContext(Dispatchers.Main) {
            Toast.makeText(context, "Error processing fidelity card rewards: ${e.message}", Toast.LENGTH_LONG).show()
        }
    }
}


// Funcția actualizată pentru verificarea și incrementarea cardului de fidelitate
// Adaugă 'suspend' aici pentru a permite apeluri la await()
suspend fun verifyAndIncrementFidelityCard(
    userId: String,
    fidelityCardNumber: String,
    database: FirebaseDatabase,
    context: Context,
    onResult: (Boolean) -> Unit
) = withContext(Dispatchers.IO) { // Rulează operațiunile de rețea pe un thread de I/O
    // Calea corectă către nodul cardului de fidelitate.
    // Acum, sub "list", avem un obiect cu "email" și "uses".
    val fidelityCardRef = database.getReference("users")
        .child(userId)
        .child("FidelityCard")
        .child("list")
        .child(fidelityCardNumber) // Acesta e nodul părinte pentru "email" și "uses"

    try {
        val cardSnapshot = fidelityCardRef.get().await() // Folosim await pentru a aștepta rezultatul

        if (cardSnapshot.exists()) {
            val currentUses = cardSnapshot.child("uses").getValue(Long::class.java)?.toInt() ?: 0
            val newValue = currentUses + 1

            // Actualizăm "uses" în Firebase
            fidelityCardRef.child("uses").setValue(newValue).await()
            Log.d("FidelityCard", "Fidelity card $fidelityCardNumber uses incremented to $newValue")

            // Apelăm checkAndAwardDiscount cu noua valoare a lui uses și celelalte detalii necesare
            checkAndAwardDiscount(
                userId = userId,
                cardCode = fidelityCardNumber,
                currentUsesAfterIncrement = newValue,
                database = database,
                context = context
            )

            // Moved to Main Dispatcher
            withContext(Dispatchers.Main) {
                onResult(true) // Indică succes
            }
        } else {
            Log.d("FidelityCard", "Fidelity card $fidelityCardNumber (or its 'uses' field) does not exist.")
            // Moved to Main Dispatcher
            withContext(Dispatchers.Main) {
                onResult(false) // Indică eșec
            }
        }
    } catch (e: Exception) {
        Log.e("FidelityCard", "Error processing fidelity card: ${e.message}", e)
        // Moved to Main Dispatcher
        withContext(Dispatchers.Main) {
            onResult(false) // Indică eșec
        }
    }
}

// Funcțiile de trimitere email (le-am mutat AICI pentru a fi complete în acest fișier)
// Asigură-te că ai adăugat dependințele de mail în build.gradle (module:app)
// implementation("com.sun.mail:android-mail:1.6.7")
// implementation("com.sun.mail:android-activation:1.6.7")


suspend fun sendDiscountCodeEmail(
    context: Context,
    recipientEmail: String,
    firstName: String,
    lastName: String,
    discountCode: String,
    discountPercent: Int
): Boolean = withContext(Dispatchers.IO) {
    val senderEmail = "noreply.simr1@gmail.com"
    // 🔥 CRITICAL: You MUST replace this with your actual App Password generated from Google.
    // Steps to get it: myaccount.google.com/security -> 2-Step Verification -> App Passwords
    val senderPassword = "algd wgeo qvka emlw" // Example: "abcd efgh ijkl mnop"

    val props = Properties().apply {
        put("mail.smtp.host", "smtp.gmail.com")
        put("mail.smtp.socketFactory.port", "465")
        put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory")
        put("mail.smtp.auth", "true")
        put("mail.smtp.port", "465")
    }

    val session = Session.getInstance(props, object : Authenticator() {
        override fun getPasswordAuthentication(): PasswordAuthentication {
            return PasswordAuthentication(senderEmail, senderPassword)
        }
    })

    try {
        val message = MimeMessage(session).apply {
            setFrom(InternetAddress(senderEmail))
            addRecipient(Message.RecipientType.TO, InternetAddress(recipientEmail))
            subject = "Your Exclusive Discount Code!"
            setText("Hello $firstName $lastName,\n\n" +
                    "Congratulations! You've earned a special discount code for being a loyal customer.\n" +
                    "Your exclusive $discountPercent% discount code is: $discountCode\n\n" +
                    "Use this code on your next purchase to enjoy your discount!\n\n" +
                    "Best regards,\n" +
                    "SIMR")
        }
        Transport.send(message)
        Log.d("PreComandaScreen", "Discount email sent successfully to $recipientEmail")
        true
    } catch (e: Exception) {
        Log.e("PreComandaScreen", "Failed to send discount email to $recipientEmail: ${e.message}", e)
        false
    }
}