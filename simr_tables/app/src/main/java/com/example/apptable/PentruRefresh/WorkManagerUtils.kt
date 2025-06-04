package com.example.apptable.PentruRefresh

import android.content.Context
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit

/** Pornește un worker care rulează clasa `class1` la fiecare minut. */
object WorkManagerUtils {
    fun startPeriodicMenuUpdate(context: Context) {
        val request = PeriodicWorkRequestBuilder<MenuAvailabilityWorker>(
            15, TimeUnit.MINUTES  // minim 15 minute - Android nu acceptă mai puțin
        ).build()

        WorkManager.getInstance(context).enqueueUniquePeriodicWork(
            "menu_availability_worker",
            ExistingPeriodicWorkPolicy.REPLACE,
            request
        )
    }
}