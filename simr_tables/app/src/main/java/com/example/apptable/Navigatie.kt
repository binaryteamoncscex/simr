package com.example.apptable

import android.content.Context
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.navigation.compose.rememberNavController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import com.example.apptable.PentruAplicatiaInSine.HomePage
import com.example.apptable.PentruAplicatiaInSine.LoginScreen
import com.example.apptable.PentruAplicatiaInSine.MeniuScreen
import com.google.firebase.auth.FirebaseAuth


class Navigatie : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            val context = applicationContext
            val sharedPreferences = context.getSharedPreferences("LoginPrefs", Context.MODE_PRIVATE)
            val rememberMe = sharedPreferences.getBoolean("rememberMe", false)
            val auth = FirebaseAuth.getInstance()

            val startDestination = if (rememberMe && auth.currentUser != null) "home" else "login"

            val navController = rememberNavController()
                    NavHost(navController = navController, startDestination = startDestination) {
                        composable("login") { LoginScreen(navController) }
                        composable("home") { HomePage(navController) }
                        composable("meniu/{masaId}") { backStackEntry ->
                            val masaId = backStackEntry.arguments?.getString("masaId") ?: "1"
                            MeniuScreen(navController, masaId)
                        }
                    }

                }
            }
        }


