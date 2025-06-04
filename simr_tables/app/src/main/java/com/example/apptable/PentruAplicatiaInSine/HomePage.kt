package com.example.apptable.PentruAplicatiaInSine

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.*

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomePage(navController: NavController) {
    val auth = FirebaseAuth.getInstance()
    val userId = auth.currentUser?.uid
    val database = FirebaseDatabase.getInstance()
    val userRef = userId?.let { database.getReference("users").child(it) }

    var userName by remember { mutableStateOf("Loading...") }
    var tableCount by remember { mutableStateOf(0) }
    var isLoading by remember { mutableStateOf(true) }
    var driveThruEnabled by remember { mutableStateOf(false) }

    LaunchedEffect(userId) {
        if (userId != null) {
            userRef?.addListenerForSingleValueEvent(object : ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    userName = snapshot.child("Name").getValue(String::class.java) ?: "Nume necunoscut"
                    tableCount = snapshot.child("Tables").getValue(Int::class.java) ?: 0
                    driveThruEnabled = snapshot.child("drive_thru").getValue(String::class.java)?.lowercase() == "yes"
                    isLoading = false
                }

                override fun onCancelled(error: DatabaseError) {
                    userName = "Error"
                    isLoading = false
                }
            })
        } else {
            userName = "User is not logged in"
            isLoading = false
        }
    }

    Scaffold(
        modifier = Modifier.fillMaxSize(),
        topBar = {
            TopAppBar(
                title = { Text(if (isLoading) "Loading..." else "Welcome, $userName!") },
                actions = {
                    Button(
                        onClick = {
                            auth.signOut()
                            navController.navigate("login") {
                                popUpTo("home") { inclusive = true }
                            }
                        },
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF00BFFF))
                    ) {
                        Text("Log Out", color = Color.White)
                    }
                }
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
                if (isLoading) {
                    CircularProgressIndicator()
                } else {
                    Spacer(modifier = Modifier.height(32.dp))
                    Column(
                        horizontalAlignment = Alignment.CenterHorizontally,
                        verticalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        for (i in 1..tableCount) {
                            Button(
                                onClick = { navController.navigate("meniu/$i") },
                                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF00BFFF))
                            ) {
                                Text("Table $i", color = Color.White)
                            }
                        }

                        if (driveThruEnabled) {
                            Button(
                                onClick = { navController.navigate("meniu/drive") },
                                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF00BFFF))
                            ) {
                                Text("Drive Thru", color = Color.White)
                            }
                        }
                    }
                }
            }
        }
    )
}
