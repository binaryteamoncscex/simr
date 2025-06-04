package com.example.apptable.PentruRefresh

import android.content.Context
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import com.google.firebase.auth.FirebaseAuth

/**  Rulează actualizarea disponibilității o dată.  */
class MenuAvailabilityWorker(
    ctx: Context,
    params: WorkerParameters
) : CoroutineWorker(ctx, params) {

    override suspend fun doWork(): Result {
        val uid = FirebaseAuth.getInstance().currentUser?.uid ?: return Result.failure()
        // apelează clasa ta Java
        class1(uid).updateAllItemsAvailability()
        return Result.success()
    }
}