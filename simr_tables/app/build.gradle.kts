import java.util.Properties

plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.compose)
    alias(libs.plugins.google.gms.google.services)
}

val properties = Properties()
project.rootProject.file("local.properties").inputStream().use { inputStream ->
    properties.load(inputStream)
}

android {
    namespace = "com.example.apptable"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.example.apptable"
        minSdk = 24
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            buildConfigField("String", "GEMINI_API_KEY", properties.getProperty("GEMINI_API_KEY") ?: "")
        }
        debug {
            buildConfigField("String", "GEMINI_API_KEY", properties.getProperty("GEMINI_API_KEY") ?: "")
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = "11"
    }
    buildFeatures {
        compose = true
        buildConfig = true
    }
    packagingOptions {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
            excludes += "META-INF/LICENSE.md"
            excludes += "META-INF/NOTICE.md"
        }
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.10.1")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.6.1")
    implementation("androidx.activity:activity-compose:1.8.0")
    implementation(platform("androidx.compose:compose-bom:2024.09.00"))
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-graphics")
    implementation("androidx.compose.ui:ui-tooling-preview")
    implementation("androidx.compose.material3:material3")

    // Asigură-te că folosești BOM-ul pentru toate dependențele Firebase
    implementation(platform("com.google.firebase:firebase-bom:32.8.1")) // Folosește ultima versiune stabilă

    // Acum adaugă bibliotecile Firebase FĂRĂ a specifica versiunea,
    // deoarece BOM-ul se va ocupa de asta.
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-database-ktx") // Aici era duplicat

    implementation("androidx.navigation:navigation-runtime-ktx:2.9.0-alpha08")
    implementation("androidx.navigation:navigation-compose:2.8.9")

    implementation("androidx.work:work-runtime-ktx:2.9.0")

    implementation("io.coil-kt:coil-compose:2.4.0")

    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.12.0")

    testImplementation("junit:junit:4.13.2")
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
    androidTestImplementation(platform("androidx.compose:compose-bom:2024.09.00"))
    androidTestImplementation("androidx.compose.ui:ui-test-junit4")
    debugImplementation("androidx.compose.ui:ui-tooling")
    debugImplementation("androidx.compose.ui:ui-test-manifest")

    implementation("com.google.ai.client.generativeai:generativeai:0.8.0")
    implementation("androidx.compose.material:material-icons-extended:1.6.7")

    implementation ("com.sun.mail:android-mail:1.6.7")
    implementation ("com.sun.mail:android-activation:1.6.7")

}