#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <DHT.h>
#include <Wire.h> 

#define FIREBASE_HOST "restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app" //Without http:// or https:// schemes
#define FIREBASE_AUTH "AIzaSyDzUE_U7yqtyJQu3ikQfw5rbYHC_Dk-m9k"
#define WIFI_SSID "Mihai"
#define WIFI_PASSWORD "MihaiC2009"
#define UserID "SLIJplDtuncEpdZ0PuWYXDC7j0y1";
#define USER_EMAIL "patron@gmail.com" // Credentiale cont patron
#define USER_PASSWORD "123456789"
#define DHTPIN D2    // Data Pin of DHT 11 , for NodeMCU D5 GPIO no. is 14
#define DHTTYPE DHT11   // DHT 11

DHT dht(DHTPIN,DHTTYPE);
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
int relVent=D3;
unsigned long sendDataPrevMillis = 0;
const int interval = 2000;  // trimitere date la 2 secunde

void setup() {
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  pinMode(A2, INPUT);
  pinMode(A3, INPUT);
  pinMode(A6, INPUT);
  pinMode(A7, INPUT);
  pinMode(relVent, OUTPUT);
  Serial.begin(115200);
  // put your setup code here, to run once:
  WiFi.begin (WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  dht.begin();
  Serial.println ("");
  Serial.println ("WiFi Connected!");
  config.database_url = FIREBASE_HOST;
  config.api_key = FIREBASE_AUTH;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void loop() {
  // put your main code here, to run repeatedly:
  if (millis() - sendDataPrevMillis > interval) {
    sendDataPrevMillis = millis();

    int sensor1 = 4095-analogRead(A0);
    int sensor2 = 4095-analogRead(A1);
    int sensor3 = 4095-analogRead(A2);
    int sensor4 = 4095-analogRead(A3);
    int sensor5 = 4095-analogRead(A7);
    int sensor6 = 4095-analogRead(A4);
    int sensor7 = 4095-analogRead(A6);
    float temp=dht.readTemperature();
    float umiditate=dht.readHumidity();
    
    if (temp<25)
    {
      digitalWrite(relVent, HIGH);
      Serial.println("ventilator pornit");
    }
    else
    {
      digitalWrite(relVent, LOW);
      Serial.println("ventilator oprit");
    }
    Serial.println(temp);
    Serial.println(umiditate);
    Serial.printf("Sensor1: %d | Sensor2: %d | Sensor3: %d | Sensor4: %d | Sensor5: %d | Sensor6: %d | Sensor7: %d \n", sensor1, sensor2, sensor3, sensor4, sensor5, sensor6, sensor7);

    // Trimite datele la Firebase
    Firebase.RTDB.setInt(&fbdo, "/kitchen/SLIJplDtuncEpdZ0PuWYXDC7j0y1/ingredients/list/1/quantity", sensor1);
    Firebase.RTDB.setInt(&fbdo, "/kitchen/SLIJplDtuncEpdZ0PuWYXDC7j0y1/ingredients/list/2/quantity", sensor2);
    Firebase.RTDB.setInt(&fbdo, "/kitchen/SLIJplDtuncEpdZ0PuWYXDC7j0y1/ingredients/list/3/quantity", sensor3);
    Firebase.RTDB.setInt(&fbdo, "/kitchen/SLIJplDtuncEpdZ0PuWYXDC7j0y1/ingredients/list/4/quantity", sensor4);
    Firebase.RTDB.setInt(&fbdo, "/kitchen/SLIJplDtuncEpdZ0PuWYXDC7j0y1/ingredients/list/5/quantity", sensor5);
    Firebase.RTDB.setInt(&fbdo, "/kitchen/SLIJplDtuncEpdZ0PuWYXDC7j0y1/ingredients/list/6/quantity", sensor6);
    Firebase.RTDB.setInt(&fbdo, "/kitchen/SLIJplDtuncEpdZ0PuWYXDC7j0y1/ingredients/list/7/quantity", sensor7);
    Firebase.RTDB.setInt(&fbdo, "/users/SLIJplDtuncEpdZ0PuWYXDC7j0y1/DHT/temp", temp);
    Firebase.RTDB.setInt(&fbdo, "/users/SLIJplDtuncEpdZ0PuWYXDC7j0y1/DHT/umd", umiditate);
  }
}
