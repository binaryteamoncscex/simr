package com.example.apptable.PentruAplicatiaInSine

import android.util.Log
import android.widget.Toast
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ValueEventListener
import kotlinx.coroutines.delay

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun RedeemCodeScreen(navController: NavController) {
    val context = LocalContext.current
    val auth = FirebaseAuth.getInstance()
    val userId = auth.currentUser?.uid // Obținem UID-ul utilizatorului curent
    val database = FirebaseDatabase.getInstance()

    var voucherCode by remember { mutableStateOf(TextFieldValue("")) }
    var isLoading by remember { mutableStateOf(false) }

    // Culori consistente
    val primaryBlue = Color(0xFF00BFFF) // Light Blue
    val darkBlue = Color(0xFF003366)    // Dark Blue (pentru text)

    Scaffold(
        modifier = Modifier.fillMaxSize(),
        containerColor = Color.White,
        content = { innerPadding ->
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(innerPadding)
                    .background(Color.White),
                contentAlignment = Alignment.Center // Centrează cardul pe ecran
            ) {
                Card(
                    modifier = Modifier
                        .fillMaxWidth(0.9f)
                        .wrapContentHeight(),
                    shape = RoundedCornerShape(12.dp),
                    colors = CardDefaults.cardColors(containerColor = Color.White),
                    elevation = CardDefaults.cardElevation(8.dp)
                ) {
                    Column(
                        modifier = Modifier
                            .padding(24.dp)
                            .fillMaxWidth(),
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.spacedBy(16.dp)
                    ) {
                        Text(
                            text = "Voucher Redemption",
                            fontSize = 28.sp,
                            fontWeight = FontWeight.Bold,
                            color = darkBlue
                        )
                        Text(
                            text = "To redeem a voucher, please use the form below.",
                            fontSize = 16.sp,
                            color = Color.Gray
                        )

                        Spacer(modifier = Modifier.height(16.dp))

                        OutlinedTextField(
                            value = voucherCode,
                            onValueChange = { voucherCode = it },
                            label = { Text("Voucher code") },
                            placeholder = { Text("EXAMPLE-CODE") },
                            singleLine = true,
                            modifier = Modifier.fillMaxWidth(),
                            colors = OutlinedTextFieldDefaults.colors(
                                focusedBorderColor = primaryBlue,
                                unfocusedBorderColor = darkBlue,
                                focusedLabelColor = primaryBlue,
                                unfocusedLabelColor = darkBlue,
                                cursorColor = primaryBlue,
                                focusedTextColor = darkBlue,
                                unfocusedTextColor = darkBlue,
                            )
                        )

                        Spacer(modifier = Modifier.height(8.dp))

                        Button(
                            onClick = {
                                // VERIFICARE CRUCIALĂ: Asigură-te că userId nu este null înainte de a folosi Firebase
                                if (userId == null) {
                                    Toast.makeText(context, "Eroare: Utilizatorul nu este autentificat. Vă rugăm să vă conectați.", Toast.LENGTH_LONG).show()
                                    Log.e("RedeemCode", "User ID is null. Cannot proceed with redemption.")
                                    isLoading = false // Oprim indicatorul de încărcare dacă e pornit
                                    return@Button // Oprim execuția funcției aici
                                }
                                if (voucherCode.text.isBlank()) {
                                    Toast.makeText(context, "Vă rugăm să introduceți un cod de voucher.", Toast.LENGTH_SHORT).show()
                                    isLoading = false // Oprim indicatorul de încărcare dacă e pornit
                                    return@Button
                                }

                                isLoading = true // Activăm indicatorul de încărcare

                                // Calea corectă, incluzând "DHT"
                                val codesListRef = database.getReference("users").child(userId).child("DiscountCard").child("list")
                                // Referința către discountul activ al utilizatorului
                                val userDiscountRef = database.getReference("users").child(userId).child("activeDiscount")

                                codesListRef.addListenerForSingleValueEvent(object : ValueEventListener {
                                    override fun onDataChange(snapshot: DataSnapshot) {
                                        var codeFound = false // Variabilă pentru a urmări dacă am găsit codul
                                        val enteredCode = voucherCode.text.trim() // Curățăm spațiile albe din codul introdus

                                        // Parcurgem toate intrările din lista de coduri
                                        for (childSnapshot in snapshot.children) {
                                            val codeKey = childSnapshot.key // Acesta este codul de reducere (ex: "123")

                                            // 🎉 CORECȚIE FINALĂ AICI: Citim valoarea DIRECT, nu un sub-nod "value"
                                            val discountValue = childSnapshot.getValue(Long::class.java) // Presupunem că este un Long (număr întreg)
                                            val discountValueString = discountValue?.toString()


                                            if (codeKey == enteredCode) {
                                                // Codul introdus se potrivește cu o cheie din baza de date
                                                if (discountValueString != null && discountValue != null) { // Verificăm dacă valoarea este validă
                                                    userDiscountRef.setValue(discountValueString) // Setăm valoarea ca String
                                                        .addOnSuccessListener {
                                                            // Ștergem intrarea specifică a codului din Firebase
                                                            childSnapshot.ref.removeValue() // Șterge direct codul (key-ul) și valoarea sa
                                                                .addOnSuccessListener {
                                                                    Toast.makeText(context, "Codul a fost răscumpărat cu succes! Reducerea de ${discountValueString}% a fost aplicată.", Toast.LENGTH_LONG).show()
                                                                    Log.d("RedeemCode", "Code $enteredCode redeemed successfully for user $userId. Discount: $discountValueString%")
                                                                    isLoading = false
                                                                    codeFound = true // Marcam că am găsit și răscumpărat codul
                                                                    navController.popBackStack() // Ne întoarcem la ecranul anterior (meniu)
                                                                }
                                                                .addOnFailureListener { e ->
                                                                    Toast.makeText(context, "Eroare la ștergerea codului: ${e.message}", Toast.LENGTH_LONG).show()
                                                                    Log.e("RedeemCode", "Error removing code: ${e.message}", e)
                                                                    isLoading = false
                                                                }
                                                        }
                                                        .addOnFailureListener { e ->
                                                            Toast.makeText(context, "Eroare la aplicarea reducerii: ${e.message}", Toast.LENGTH_LONG).show()
                                                            Log.e("RedeemCode", "Error setting active discount: ${e.message}", e)
                                                            isLoading = false
                                                        }
                                                    return@onDataChange // Ieșim din funcția onDataChange, deoarece am găsit și procesat codul
                                                } else {
                                                    // Valoarea discountului nu este validă sau lipsește
                                                    Log.w("RedeemCode", "Valoare discount invalidă sau lipsă pentru codul $codeKey: '$discountValue'. Ignoră această intrare.")
                                                }
                                            }
                                        }

                                        // Dacă bucla s-a terminat și codul nu a fost găsit
                                        if (!codeFound) {
                                            Toast.makeText(context, "Codul '$enteredCode' este incorect sau a expirat.", Toast.LENGTH_LONG).show()
                                            Log.d("RedeemCode", "Codul '$enteredCode' nu a fost găsit în lista 'DiscountCard/list'.")
                                            isLoading = false
                                        }
                                    }

                                    override fun onCancelled(error: DatabaseError) {
                                        Toast.makeText(context, "Eroare de bază de date: ${error.message}", Toast.LENGTH_LONG).show()
                                        Log.e("RedeemCode", "Firebase database error: ${error.message}", error.toException())
                                        isLoading = false
                                    }
                                })
                            },
                            modifier = Modifier.fillMaxWidth(),
                            enabled = !isLoading,
                            colors = ButtonDefaults.buttonColors(
                                containerColor = primaryBlue,
                                contentColor = Color.White
                            )
                        ) {
                            if (isLoading) {
                                CircularProgressIndicator(
                                    modifier = Modifier.size(24.dp),
                                    color = Color.White,
                                    strokeWidth = 2.dp
                                )
                            } else {
                                Text("Redeem code", fontSize = 18.sp)
                            }
                        }
                    }
                }
            }
        }
    )
}