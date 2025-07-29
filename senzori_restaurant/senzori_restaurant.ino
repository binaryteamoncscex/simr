#include <WiFi.h>
#include <WebServer.h>
#include <Preferences.h>
#include <Firebase_ESP_Client.h>
#include <DHT.h>

#define FIREBASE_HOST "restaurant-3e115-default-rtdb.europe-west1.firebasedatabase.app"
#define FIREBASE_AUTH "AIzaSyDzUE_U7yqtyJQu3ikQfw5rbYHC_Dk-m9k"
#define DHTPIN D2
#define DHTTYPE DHT11
const int fanRelay = D3;
const int interval = 2000;

DHT dht(DHTPIN, DHTTYPE);

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

Preferences prefs;
WebServer server(80);

unsigned long sendDataPrevMillis = 0;
String userID = "";

const char* htmlForm = R"rawliteral(
<!DOCTYPE html>
<html><body>
<h2>Configurare ESP32</h2>
<form action="/save" method="GET">
WiFi SSID:<br><input type="text" name="ssid"><br>
WiFi Parolă:<br><input type="password" name="pass"><br>
Email SIMR:<br><input type="text" name="email"><br>
Parolă SIMR:<br><input type="password" name="fpass"><br>
<input type="submit" value="Salvează">
</form>
</body></html>)rawliteral";

void startConfigPortal() {
  WiFi.softAP("ESP32-Setup", "12345678");
  Serial.println("Intru pe modul configurare...");
  Serial.println("Conectează-te la rețeaua WiFi ESP32-Setup cu parola 12345678");
  server.on("/", []() {
    server.send(200, "text/html", htmlForm);
  });
  server.on("/save", []() {
    String ssid = server.arg("ssid");
    String pass = server.arg("pass");
    String email = server.arg("email");
    String fpass = server.arg("fpass");
    Serial.println("Salvez setările:");
    Serial.print("  WiFi SSID: "); Serial.println(ssid);
    Serial.print("  Email: "); Serial.println(email);
    prefs.begin("config", false);
    prefs.putString("ssid", ssid);
    prefs.putString("pass", pass);
    prefs.putString("email", email);
    prefs.putString("fpass", fpass);
    prefs.end();
    server.send(200, "text/html", "<h3>Datele au fost salvate! ESP32 se va reporni...</h3>");
    Serial.println("Repornesc placa...");
    delay(3000);
    ESP.restart();
  });
  server.begin();
}

void connectToWiFi() {
  Serial.println("Citesc datele WiFi din memorie...");
  prefs.begin("config", true);
  String ssid = prefs.getString("ssid", "");
  String pass = prefs.getString("pass", "");
  String email = prefs.getString("email", "");
  String fpass = prefs.getString("fpass", "");
  prefs.end();

  if (ssid == "" || pass == "") {
    Serial.println("Nu am găsit date WiFi salvate!");
    startConfigPortal();
    return;
  }

  Serial.print("Mă conectez la WiFi: ");
  Serial.println(ssid);
  WiFi.begin(ssid.c_str(), pass.c_str());

  int retries = 0;
  while (WiFi.status() != WL_CONNECTED && retries < 20) {
    delay(500);
    Serial.print(".");
    retries++;
  }

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\nConexiune WiFi reușită!");
    Serial.print("IP-ul este: ");
    Serial.println(WiFi.localIP());

    Serial.println("Mă conectez la Firebase...");
    config.database_url = FIREBASE_HOST;
    config.api_key = FIREBASE_AUTH;
    auth.user.email = email.c_str();
    auth.user.password = fpass.c_str();

    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);

    unsigned long start = millis();
    while (!Firebase.ready() && millis() - start < 10000) {
      Serial.print(".");
      delay(500);
    }

    if (Firebase.ready()) {
      userID = auth.token.uid.c_str();
      Serial.println("\nFirebase conectat!");
      Serial.print("UID-ul utilizatorului: ");
      Serial.println(userID);
    } else {
      Serial.println("\nNu s-a reușit conectarea la Firebase!");
    }
  } else {
    Serial.println("\nNu am reușit să mă conectez la WiFi!");
    startConfigPortal();
  }
}


void setup() {
  Serial.begin(115200);
  delay(2000);
  Serial.println("Pornește ESP32...");
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  pinMode(A2, INPUT);
  pinMode(A3, INPUT);
  pinMode(A4, INPUT);
  pinMode(A5, INPUT);
  pinMode(A6, INPUT);
  pinMode(A7, INPUT);
  pinMode(fanRelay, OUTPUT);
  Serial.println("Inițializez senzorul de temperatură și umiditate...");
  dht.begin();
  Serial.println("Mă conectez la WiFi și Firebase...");
  connectToWiFi();
}

void loop() {
  server.handleClient();

  if (WiFi.status() != WL_CONNECTED) return;

  if (millis() - sendDataPrevMillis > interval) {
    sendDataPrevMillis = millis();

    int sensor1 = analogRead(A0)-1000;
    if (sensor1<0)
      sensor1=0;
    int sensor2 = analogRead(A1)-1000;
    if (sensor2<0) 
        sensor2=0;
    int sensor3 = analogRead(A2)-1000;
    if (sensor3<0) 
        sensor3=0;
    int sensor4 = analogRead(A3)-1000;
    if (sensor4<0) 
        sensor4=0;
    int sensor5 = analogRead(A4)-1000;
    if (sensor5<0) 
        sensor5=0;
    int sensor6 = analogRead(A5)-1000;
    if (sensor6<0) 
        sensor6=0;
    int sensor7 = analogRead(A6)-1000;
    if (sensor7<0) 
        sensor7=0;
    int sensor8 = analogRead(A7)-1000;
    if (sensor8<0) 
        sensor8=0;

    float temp = dht.readTemperature();
    float humidity = dht.readHumidity();

    Serial.println("Citiri de la senzori:");
    Serial.print("  Senzor 1: "); Serial.println(sensor1);
    Serial.print("  Senzor 2: "); Serial.println(sensor2);
    Serial.print("  Senzor 3: "); Serial.println(sensor3);
    Serial.print("  Senzor 4: "); Serial.println(sensor4);
    Serial.print("  Senzor 5: "); Serial.println(sensor5);
    Serial.print("  Senzor 6: "); Serial.println(sensor6);
    Serial.print("  Senzor 7: "); Serial.println(sensor7);
    Serial.print("  Senzor 8: "); Serial.println(sensor8);

    Serial.print("Temperatura: "); Serial.print(temp); Serial.println(" °C");
    Serial.print("Umiditatea: "); Serial.print(humidity); Serial.println(" %");

    if (temp > 25) {
      digitalWrite(fanRelay, HIGH);
      Serial.println("Ventilatorul este pornit (temperatura peste 25°C)");
    } else {
      digitalWrite(fanRelay, LOW);
      Serial.println("Ventilatorul este oprit (temperatura sub sau egală cu 25°C)");
    }

    Serial.println("Trimit datele către Firebase...");

    Firebase.RTDB.setInt(&fbdo, "/kitchen/" + userID + "/ingredients/list/1/quantity", sensor1);
    Firebase.RTDB.setInt(&fbdo, "/kitchen/" + userID + "/ingredients/list/2/quantity", sensor2);
    Firebase.RTDB.setInt(&fbdo, "/kitchen/" + userID + "/ingredients/list/3/quantity", sensor3);
    Firebase.RTDB.setInt(&fbdo, "/kitchen/" + userID + "/ingredients/list/4/quantity", sensor4);
    Firebase.RTDB.setInt(&fbdo, "/kitchen/" + userID + "/ingredients/list/5/quantity", sensor5);
    Firebase.RTDB.setInt(&fbdo, "/kitchen/" + userID + "/ingredients/list/6/quantity", sensor6);
    Firebase.RTDB.setInt(&fbdo, "/kitchen/" + userID + "/ingredients/list/7/quantity", sensor7);
    Firebase.RTDB.setInt(&fbdo, "/kitchen/" + userID + "/ingredients/list/8/quantity", sensor8);

    Firebase.RTDB.setFloat(&fbdo, "/users/" + userID + "/DHT/temp", temp);
    Firebase.RTDB.setFloat(&fbdo, "/users/" + userID + "/DHT/umd", humidity);

    Serial.println("Datele au fost trimise cu succes.");
  }
}
