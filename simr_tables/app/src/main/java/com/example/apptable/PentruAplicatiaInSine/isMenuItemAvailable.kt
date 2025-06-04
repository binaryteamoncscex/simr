import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.ValueEventListener
import kotlinx.coroutines.tasks.await

suspend fun isMenuItemAvailable(userId: String, menuItemId: String): Boolean {
    val database = FirebaseDatabase.getInstance()
    val ref = database.getReference("kitchen")
        .child(userId)
        .child("menu")
        .child("list")
        .child(menuItemId)
        .child("menuAvailability")

    return try {
        val snapshot = ref.get().await()
        snapshot.getValue(Boolean::class.java) == true
    } catch (e: Exception) {
        false // În caz de eroare sau dacă nu există valoarea, presupunem că nu este disponibil
    }
}
