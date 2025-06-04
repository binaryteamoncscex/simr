package com.example.apptable.PentruAplicatiaInSine

import android.content.Context
import android.content.SharedPreferences
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import com.example.apptable.R
import com.google.firebase.auth.FirebaseAuth
import kotlinx.coroutines.launch

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LoginScreen(navController: NavController) {
    val context = LocalContext.current
    val sharedPreferences = remember { context.getSharedPreferences("LoginPrefs", Context.MODE_PRIVATE) }
    val auth = FirebaseAuth.getInstance()
    val coroutineScope = rememberCoroutineScope()
    val snackbarHostState = remember { SnackbarHostState() }

    val savedEmail = sharedPreferences.getString("email", "") ?: ""
    val savedPassword = sharedPreferences.getString("password", "") ?: ""
    val isRemembered = sharedPreferences.getBoolean("rememberMe", false)

    val email = remember { mutableStateOf(TextFieldValue(savedEmail)) }
    val password = remember { mutableStateOf(TextFieldValue(savedPassword)) }
    var rememberMe by remember { mutableStateOf(isRemembered) }
    var isLoading by remember { mutableStateOf(false) }

    // Define colors
    val deepSkyBlue = Color(0xFF00BFFF)
    val darkBlue = Color(0xFF003366)
    val white = Color.White
    val black = Color.Black
    val gray = Color.Gray

    LaunchedEffect(Unit) {
        if (auth.currentUser != null) {
            navController.navigate("home") {
                popUpTo(0) { inclusive = true }
            }
        }
    }

    Scaffold(
        modifier = Modifier.fillMaxSize(),
        snackbarHost = { SnackbarHost(snackbarHostState) },
        content = { innerPadding ->
            Column(
                modifier = Modifier
                    .padding(innerPadding)
                    .fillMaxSize()
                    .background(white)
                    .padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Top
            ) {
                Spacer(modifier = Modifier.height(40.dp))

                Box(
                    modifier = Modifier
                        .size(200.dp)
                        .clip(CircleShape),
                    contentAlignment = Alignment.Center
                ) {
                    Image(
                        painter = painterResource(id = R.drawable.masa),
                        contentDescription = "Decor",
                        modifier = Modifier.size(180.dp)
                    )
                }

                Spacer(modifier = Modifier.height(16.dp))

                Text(text = "Welcome!", fontSize = 24.sp, color = black)
                Text(text = "Sign in to continue!", fontSize = 16.sp, color = gray)

                Spacer(modifier = Modifier.height(24.dp))

                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Box(
                        modifier = Modifier
                            .size(50.dp)
                            .clip(CircleShape)
                            .background(deepSkyBlue),
                        contentAlignment = Alignment.Center
                    ) {
                        Image(
                            painter = painterResource(id = R.drawable.usericon),
                            contentDescription = "User Icon",
                            modifier = Modifier.size(30.dp)
                        )
                    }
                    Spacer(modifier = Modifier.width(8.dp))
                    TextField(
                        value = email.value,
                        onValueChange = { email.value = it },
                        label = { Text("Email", color = gray) },
                        modifier = Modifier.fillMaxWidth(),
                        singleLine = true,
                        colors = TextFieldDefaults.colors(
                            focusedContainerColor = white,
                            unfocusedContainerColor = white,
                            focusedIndicatorColor = deepSkyBlue,
                            unfocusedIndicatorColor = gray
                        )
                    )
                }

                Spacer(modifier = Modifier.height(16.dp))

                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Box(
                        modifier = Modifier
                            .size(50.dp)
                            .clip(CircleShape)
                            .background(deepSkyBlue),
                        contentAlignment = Alignment.Center
                    ) {
                        Image(
                            painter = painterResource(id = R.drawable.parola),
                            contentDescription = "Password Icon",
                            modifier = Modifier.size(30.dp)
                        )
                    }
                    Spacer(modifier = Modifier.width(8.dp))
                    TextField(
                        value = password.value,
                        onValueChange = { password.value = it },
                        label = { Text("Password", color = gray) },
                        modifier = Modifier.fillMaxWidth(),
                        singleLine = true,
                        visualTransformation = PasswordVisualTransformation(),
                        colors = TextFieldDefaults.colors(
                            focusedContainerColor = white,
                            unfocusedContainerColor = white,
                            focusedIndicatorColor = deepSkyBlue,
                            unfocusedIndicatorColor = gray
                        )
                    )
                }

                Spacer(modifier = Modifier.height(8.dp))

                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Checkbox(
                        checked = rememberMe,
                        onCheckedChange = { rememberMe = it },
                        colors = CheckboxDefaults.colors(
                            checkedColor = deepSkyBlue,
                            uncheckedColor = gray,
                            checkmarkColor = white
                        )
                    )
                    Text(text = "Remember Me", color = gray)
                }

                Spacer(modifier = Modifier.height(16.dp))

                Button(
                    onClick = {
                        val emailText = email.value.text.trim()
                        val passwordText = password.value.text.trim()

                        if (emailText.isNotEmpty() && passwordText.isNotEmpty()) {
                            isLoading = true
                            auth.signInWithEmailAndPassword(emailText, passwordText)
                                .addOnCompleteListener { task ->
                                    isLoading = false
                                    if (task.isSuccessful) {
                                        if (rememberMe) {
                                            saveLoginDetails(sharedPreferences, emailText, passwordText, true)
                                        } else {
                                            clearLoginDetails(sharedPreferences)
                                        }

                                        navController.navigate("home") {
                                            popUpTo(0) { inclusive = true }
                                        }
                                    } else {
                                        coroutineScope.launch {
                                            snackbarHostState.showSnackbar(
                                                message = "Login Failed: ${task.exception?.message}",
                                                duration = SnackbarDuration.Short
                                            )
                                        }
                                    }
                                }
                        } else {
                            coroutineScope.launch {
                                snackbarHostState.showSnackbar(
                                    message = "Please enter email and password",
                                    duration = SnackbarDuration.Short
                                )
                            }
                        }
                    },
                    modifier = Modifier.fillMaxWidth(),
                    enabled = !isLoading,
                    colors = ButtonDefaults.buttonColors(
                        containerColor = deepSkyBlue,
                        contentColor = white,
                        disabledContainerColor = gray,
                        disabledContentColor = white
                    )
                ) {
                    if (isLoading) {
                        CircularProgressIndicator(color = white)
                    } else {
                        Text(text = "Sign In", color = white)
                    }
                }
            }
        }
    )
}

fun saveLoginDetails(sharedPreferences: SharedPreferences, email: String, password: String, rememberMe: Boolean) {
    with(sharedPreferences.edit()) {
        putString("email", email)
        putString("password", password)
        putBoolean("rememberMe", rememberMe)
        apply()
    }
}

fun clearLoginDetails(sharedPreferences: SharedPreferences) {
    with(sharedPreferences.edit()) {
        remove("email")
        remove("password")
        putBoolean("rememberMe", false)
        apply()
    }
}