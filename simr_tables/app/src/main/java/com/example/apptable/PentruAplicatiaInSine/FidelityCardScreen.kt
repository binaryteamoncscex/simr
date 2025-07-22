package com.example.apptable.PentruAplicatiaInSine

import android.content.Context
import android.util.Log
import android.widget.Toast
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.google.firebase.Firebase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.database
import com.google.firebase.database.FirebaseDatabase
import kotlinx.coroutines.tasks.await
import java.util.UUID
import javax.mail.*
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeMessage
import java.util.Properties
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun FidelityCardScreen(navController: NavController) {
    val context = LocalContext.current
    val auth = FirebaseAuth.getInstance()
    val userId = auth.currentUser?.uid
    val database = Firebase.database

    var firstName by remember { mutableStateOf("") }
    var lastName by remember { mutableStateOf("") }
    var email by remember { mutableStateOf("") }
    var confirmEmail by remember { mutableStateOf("") }
    var isSendingEmail by remember { mutableStateOf(false) }

    val coroutineScope = rememberCoroutineScope()

    val emailError = remember(email, confirmEmail) {
        if (email.isNotBlank() && confirmEmail.isNotBlank() && email != confirmEmail) {
            "Emails do not match"
        } else {
            null
        }
    }

    val allFieldsFilled = remember(firstName, lastName, email, confirmEmail, emailError) {
        firstName.isNotBlank() && lastName.isNotBlank() && email.isNotBlank() && confirmEmail.isNotBlank() && emailError == null
    }

    // Definirea culorilor pentru tema Deep Sky Blue
    val primaryColor = Color(0xFF00BFFF) // Deep Sky Blue
    val onPrimaryColor = Color.White
    val accentColor = Color(0xFF4CAF50) // Un verde pentru accent/succes
    val errorColor = Color(0xFFD32F2F) // Roșu pentru erori
    val textColor = Color(0xFF003366) // Un albastru închis pentru text

    Scaffold(
        modifier = Modifier.fillMaxSize(),
        topBar = {
            TopAppBar(
                title = { Text("Create Fidelity Card", color = onPrimaryColor) },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back", tint = onPrimaryColor)
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = primaryColor,
                    titleContentColor = onPrimaryColor,
                    navigationIconContentColor = onPrimaryColor
                )
            )
        },
        content = { innerPadding ->
            Column(
                modifier = Modifier
                    .padding(innerPadding)
                    .fillMaxSize()
                    .padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                Text(
                    "Register for a Fidelity Card",
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Bold,
                    color = textColor,
                    modifier = Modifier.padding(bottom = 24.dp)
                )

                OutlinedTextField(
                    value = firstName,
                    onValueChange = { firstName = it },
                    label = { Text("First Name") },
                    modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
                    singleLine = true,
                    colors = TextFieldDefaults.colors(
                        focusedContainerColor = Color.White,
                        unfocusedContainerColor = Color.White,
                        focusedTextColor = textColor,
                        unfocusedTextColor = textColor,
                        focusedIndicatorColor = accentColor,
                        unfocusedIndicatorColor = primaryColor
                    )
                )

                OutlinedTextField(
                    value = lastName,
                    onValueChange = { lastName = it },
                    label = { Text("Last Name") },
                    modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
                    singleLine = true,
                    colors = TextFieldDefaults.colors(
                        focusedContainerColor = Color.White,
                        unfocusedContainerColor = Color.White,
                        focusedTextColor = textColor,
                        unfocusedTextColor = textColor,
                        focusedIndicatorColor = accentColor,
                        unfocusedIndicatorColor = primaryColor
                    )
                )

                OutlinedTextField(
                    value = email,
                    onValueChange = { email = it },
                    label = { Text("Email") },
                    modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email),
                    isError = emailError != null,
                    supportingText = { if (emailError != null) Text(emailError, color = errorColor) },
                    colors = TextFieldDefaults.colors(
                        focusedContainerColor = Color.White,
                        unfocusedContainerColor = Color.White,
                        focusedTextColor = textColor,
                        unfocusedTextColor = textColor,
                        focusedIndicatorColor = accentColor,
                        unfocusedIndicatorColor = primaryColor,
                        errorTextColor = errorColor,
                        errorSupportingTextColor = errorColor,
                        errorIndicatorColor = errorColor
                    )
                )

                OutlinedTextField(
                    value = confirmEmail,
                    onValueChange = { confirmEmail = it },
                    label = { Text("Confirm Email") },
                    modifier = Modifier.fillMaxWidth().padding(vertical = 8.dp),
                    singleLine = true,
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email),
                    isError = emailError != null,
                    supportingText = { if (emailError != null) Text(emailError, color = errorColor) },
                    colors = TextFieldDefaults.colors(
                        focusedContainerColor = Color.White,
                        unfocusedContainerColor = Color.White,
                        focusedTextColor = textColor,
                        unfocusedTextColor = textColor,
                        focusedIndicatorColor = accentColor,
                        unfocusedIndicatorColor = primaryColor,
                        errorTextColor = errorColor,
                        errorSupportingTextColor = errorColor,
                        errorIndicatorColor = errorColor
                    )
                )

                Spacer(modifier = Modifier.height(24.dp))

                Button(
                    onClick = {
                        if (userId == null) {
                            Toast.makeText(context, "User not authenticated.", Toast.LENGTH_SHORT).show()
                            return@Button
                        }
                        if (emailError != null) {
                            Toast.makeText(context, emailError, Toast.LENGTH_SHORT).show()
                            return@Button
                        }
                        if (!allFieldsFilled) {
                            Toast.makeText(context, "Please fill all fields.", Toast.LENGTH_SHORT).show()
                            return@Button
                        }

                        isSendingEmail = true
                        val cardCode = UUID.randomUUID().toString().substring(0, 8).uppercase() // Generăm un cod scurt și unic

                        val fidelityCardBaseRef = database.getReference("users").child(userId).child("FidelityCard")
                        val fidelityCardEntryRef = fidelityCardBaseRef.child("list").child(cardCode)

                        coroutineScope.launch {
                            try {
                                // Salvăm email-ul și inițializăm numărul de utilizări cu 0
                                // Includem si "procent" la nivelul cardului individual
                                val cardData = hashMapOf(
                                    "email" to email,
                                    "uses" to 0,
                                    // Adaugam procent cu o valoare default la crearea cardului
                                    // Aceasta poate fi setata manual in Firebase sau luate dintr-un input in viitor
                                    "procent" to 5 // Valoare implicita pentru discount, ajustati dupa nevoie
                                )
                                fidelityCardEntryRef.setValue(cardData).await() // Salvăm în baza de date

                                // Trimitem emailul de card de fidelitate
                                val emailSent = sendFidelityCardEmail(context, email, firstName, lastName, cardCode)

                                withContext(Dispatchers.Main) {
                                    if (emailSent) {
                                        Toast.makeText(context, "Fidelity card created and sent to your email!", Toast.LENGTH_LONG).show()
                                        navController.popBackStack() // Revenim la ecranul anterior
                                    } else {
                                        Toast.makeText(context, "Failed to send email. Please check your internet connection and sender email configuration.", Toast.LENGTH_LONG).show()
                                    }
                                }
                            } catch (e: Exception) {
                                withContext(Dispatchers.Main) {
                                    Toast.makeText(context, "Error creating card: ${e.message}", Toast.LENGTH_LONG).show()
                                    Log.e("FidelityCardScreen", "Error: ${e.message}", e)
                                }
                            } finally {
                                withContext(Dispatchers.Main) {
                                    isSendingEmail = false
                                }
                            }
                        }
                    },
                    enabled = allFieldsFilled && !isSendingEmail,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(50.dp),
                    colors = ButtonDefaults.buttonColors(
                        containerColor = primaryColor,
                        contentColor = onPrimaryColor
                    )
                ) {
                    if (isSendingEmail) {
                        CircularProgressIndicator(
                            modifier = Modifier.size(20.dp),
                            color = onPrimaryColor,
                            strokeWidth = 2.dp
                        )
                    } else {
                        Text("Send Email with Card Code", fontSize = 18.sp)
                    }
                }
            }
        }
    )
}

// Funcție suspendată pentru trimiterea email-ului pentru cardul de fidelitate
suspend fun sendFidelityCardEmail(
    context: Context,
    recipientEmail: String,
    firstName: String,
    lastName: String,
    cardCode: String
): Boolean = withContext(Dispatchers.IO) {
    // !!! AICI SUNT DETALIILE CONTULUI TĂU DE GMAIL NOU CREAT ȘI PAROLA DE APLICAȚIE !!!
    val senderEmail = "noreply.simr1@gmail.com" // TODO: Pune AICI adresa de email creată (ex: "fidelity.restaurant.tău@gmail.com")
    val senderPassword = "tykp hktd naip avca" // TODO: Pune AICI parola de aplicație generată (ex: "abcd efgh ijkl mnop")

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
            subject = "Your Fidelity Card Code!"
            setText("Hello $firstName $lastName,\n\n" +
                    "Thank you for registering for our fidelity card!\n" +
                    "Your unique fidelity card code is: $cardCode\n\n" +
                    "Present this code at checkout to earn rewards.\n\n" +
                    "Best regards,\n" +
                    "SIMR") // TODO: Modifică numele companiei aici!
        }
        Transport.send(message)
        Log.d("FidelityCardEmail", "Fidelity card email sent successfully to $recipientEmail")
        true
    } catch (e: Exception) {
        Log.e("FidelityCardEmail", "Failed to send fidelity card email to $recipientEmail: ${e.message}", e)
        false
    }
}