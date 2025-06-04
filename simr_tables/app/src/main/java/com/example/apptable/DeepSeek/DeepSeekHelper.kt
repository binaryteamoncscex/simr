import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ValueEventListener
import com.google.firebase.database.ktx.getValue
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.Body
import retrofit2.http.Header
import retrofit2.http.POST
import com.google.gson.annotations.SerializedName
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.util.Random

// Interfață pentru API-ul DeepSeek
interface DeepSeekApiService {
    @POST("v1/chat/completions")
    fun getChatResponse(
        @Header("Authorization") authHeader: String,
        @Body request: ChatRequest
    ): Call<ChatResponse>
}

// Modele pentru request și response
data class ChatRequest(
    @SerializedName("model") val model: String = "deepseek-chat",
    @SerializedName("messages") val messages: List<Message>,
    @SerializedName("max_tokens") val maxTokens: Int = 150
)

data class Message(
    @SerializedName("role") val role: String,
    @SerializedName("content") val content: String
)

data class ChatResponse(
    @SerializedName("choices") val choices: List<Choice>
)

data class Choice(
    @SerializedName("message") val message: Message
)

data class MenuItem(
    val name: String = "",
    val description: String = "",
    val price: Double = 0.0,
    val menuAvailability: Boolean = false,
    val category: String = ""
)

class DeepSeekHelper(private val apiKey: String, private val userId: String) {
    private val database = FirebaseDatabase.getInstance()
    private val menuRef = database.getReference("kitchen/$userId/menu/list")
    private var availableMenuItems = mutableListOf<MenuItem>()
    private val deepSeekService: DeepSeekApiService by lazy {
        val client = OkHttpClient.Builder()
            .addInterceptor { chain ->
                val original = chain.request()
                val requestBuilder = original.newBuilder()
                    .header("Authorization", "Bearer $apiKey")
                    .header("Content-Type", "application/json")
                chain.proceed(requestBuilder.build())
            }
            .build()

        Retrofit.Builder()
            .baseUrl("https://api.deepseek.com/")
            .client(client)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(DeepSeekApiService::class.java)
    }

    init {
        setupMenuListener()
    }

    private fun setupMenuListener() {
        menuRef.orderByChild("menuAvailability").equalTo(true)
            .addValueEventListener(object : ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    availableMenuItems.clear()
                    for (itemSnapshot in snapshot.children) {
                        val item = itemSnapshot.getValue<MenuItem>()
                        item?.let { availableMenuItems.add(it) }
                    }
                }

                override fun onCancelled(error: DatabaseError) {
                    // Gestionează eroarea după necesități
                }
            })
    }

    fun getFoodRecommendation(
        userQuery: String,
        onSuccess: (String) -> Unit,
        onFailure: (String) -> Unit
    ) {
        if (availableMenuItems.isEmpty()) {
            onFailure("Nu sunt preparate disponibile în meniu.")
            return
        }

        val menuItemsString = availableMenuItems.joinToString(", ") { it.name }

        val messages = listOf(
            Message(
                role = "system",
                content = """
                Ești un asistent virtual pentru un restaurant. 
                Meniul disponibil conține: $menuItemsString.
                Recomandă doar preparate care se află în lista de mai sus.
                Include și descrierea preparatului din meniu.
                Răspunsurile trebuie să fie concise și relevante.
                Dacă nu găsești ceva potrivit în meniu, spune că nu ai recomandări.
                """.trimIndent()
            ),
            Message(
                role = "user",
                content = userQuery
            )
        )

        val request = ChatRequest(messages = messages)

        deepSeekService.getChatResponse("Bearer $apiKey", request).enqueue(
            object : Callback<ChatResponse> {
                override fun onResponse(
                    call: Call<ChatResponse>,
                    response: Response<ChatResponse>
                ) {
                    if (response.isSuccessful) {
                        val reply = response.body()?.choices?.firstOrNull()?.message?.content
                            ?: "Nu am primit un răspuns valid."
                        onSuccess(reply)
                    } else {
                        val randomRecommendation = getRandomRecommendation()
                        onSuccess("$randomRecommendation (recomandare locală)")
                    }
                }

                override fun onFailure(call: Call<ChatResponse>, t: Throwable) {
                    val randomRecommendation = getRandomRecommendation()
                    onSuccess("$randomRecommendation (recomandare locală - offline)")
                }
            }
        )
    }

    private fun getRandomRecommendation(): String {
        return if (availableMenuItems.isNotEmpty()) {
            val randomItem = availableMenuItems.random()
            "Vă recomand: ${randomItem.name} - ${randomItem.description} (${randomItem.price} RON)"
        } else {
            "Îmi pare rău, nu am găsit preparate disponibile în meniu."
        }
    }

    // Funcție pentru filtrare după categorie
    fun getRecommendationByCategory(
        category: String,
        userQuery: String,
        onSuccess: (String) -> Unit,
        onFailure: (String) -> Unit
    ) {
        val filteredItems = availableMenuItems.filter { it.category.equals(category, ignoreCase = true) }

        if (filteredItems.isEmpty()) {
            onFailure("Nu sunt preparate disponibile în categoria $category.")
            return
        }

        getFoodRecommendation(
            userQuery = "$userQuery (doar din categoria $category)",
            onSuccess = onSuccess,
            onFailure = onFailure
        )
    }
}