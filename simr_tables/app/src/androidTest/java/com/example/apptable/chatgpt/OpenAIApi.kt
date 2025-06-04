package com.example.apptable.network

import OpenAIRequest
import OpenAIResponse
import retrofit2.http.Body
import retrofit2.http.Headers
import retrofit2.http.POST
import retrofit2.Call

interface OpenAIApi {
    @Headers(
        "Content-Type: application/json",
        "Authorization: Bearer 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"
    )
    @POST("v1/chat/completions")
    fun getChatResponse(@Body request: OpenAIRequest): Call<OpenAIResponse>
}
