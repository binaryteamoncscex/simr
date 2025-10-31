#include <DHT.h>
#include <DHT_U.h>
#include <MD_Parola.h>
#include <MD_MAX72xx.h>
#include <DistanceSensor.h>
#include <LiquidCrystal_I2C.h>
#include <Wire.h>
constexpr int TrigPin = 2;
constexpr int EchoPin = 3;
DistanceSensor sensor(TrigPin, EchoPin);
LiquidCrystal_I2C lcd(0x27,  16, 2);
#define HARDWARE_TYPE MD_MAX72XX::FC16_HW
#define MAX_DEVICES 8
#define CLK_PIN   13
#define DATA_PIN  11
#define CS_PIN    10
#define CS_PIN1    8
#define DHTPIN 7    
#define DHTTYPE DHT11   

int rosu= 4;
int verde= 5;
int vent=6;
int sensGaz = 9;

MD_Parola P = MD_Parola(HARDWARE_TYPE, CS_PIN, MAX_DEVICES);
MD_Parola F = MD_Parola(HARDWARE_TYPE, CS_PIN1, MAX_DEVICES);
DHT dht(DHTPIN, DHTTYPE);

struct animations
{
  textEffect_t   anim_in; 
  textEffect_t   anim_out;
  const char *   textOut;   
  uint16_t       speed;       
  uint16_t       pause;       
  textPosition_t just;
};
animations text1= { PA_SCROLL_LEFT, PA_SCROLL_LEFT , "BINE ATI VENIT  ", 4, 0, PA_LEFT };
animations text2= { PA_SCROLL_LEFT, PA_SCROLL_LEFT , "Va rugam asteptati  ", 4, 0, PA_LEFT };
animations text3= { PA_SCROLL_LEFT, PA_SCROLL_LEFT , "Va multumim si va mai asteptam  ", 4, 0, PA_LEFT };
animations text4= { PA_SCROLL_LEFT, PA_SCROLL_LEFT , "SIMR  ", 4, 0, PA_LEFT };

void setup() {
  
  dht.begin();
  Serial.begin(9600);
  P.begin();
  F.begin();
  pinMode(rosu, OUTPUT);
  pinMode(verde, OUTPUT);
  pinMode(vent, OUTPUT);
  pinMode(sensGaz, OUTPUT);
  text1.speed *= P.getSpeed(); 
  text1.pause *= 500;
  text2.speed *= P.getSpeed(); 
  text2.pause *= 500;
  text3.speed *= P.getSpeed(); 
  text3.pause *= 500;
  text4.speed *= P.getSpeed(); 
  text4.pause *= 500;
  lcd.init();
  lcd.backlight();
}
 
void loop() {
  int distanta = sensor.getCM();
  Serial.println(digitalRead(sensGaz));
 
  if (P.displayAnimate() || F.displayAnimate())
  {
    if (distanta>=20)
    {
      P.displayText(text1.textOut, text1.just, text1.speed, text1.pause, text1.anim_in, text1.anim_out);
      F.displayText(text3.textOut, text3.just, text3.speed, text3.pause, text3.anim_in, text3.anim_out);
      digitalWrite(rosu, HIGH);
      digitalWrite(verde, LOW);
      Serial.print("Auto in drive: ");
      Serial.println("rosu aprins");
    }
    else
    {
      P.displayText(text2.textOut, text2.just, text2.speed, text2.pause, text2.anim_in, text2.anim_out);
      F.displayText(text4.textOut, text4.just, text4.speed, text4.pause, text4.anim_in, text4.anim_out);
      digitalWrite(rosu, LOW);
      digitalWrite(verde, HIGH);
      Serial.print("Auto in asteptare ");
      Serial.println("verde aprins");
    }
  } 
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  float hic = dht.computeHeatIndex(t, h, false);
  /*if (isnan(t) || isnan(h)) {
    Serial.println("Failed to read from DHT sensor!");
    lcd.setCursor(0, 0);
    lcd.print("Failed to read!");
    lcd.setCursor(0, 1);
    lcd.print("Retrying...");
    delay(2000);
    return;
  }*/
  if (t>25)
  {
     digitalWrite(vent, HIGH);
     Serial.println("Ventilator pornit");
  }
  else
  {
    digitalWrite(vent, LOW);
    Serial.println("Ventilator oprit");
  }
  Serial.print(t);
  Serial.print(F("°C "));
  Serial.print("Temperatura: ");
  Serial.print(t);
  Serial.println(" °C");
  Serial.print("Umiditatea: ");
  Serial.print(h);
  Serial.println(" %");
  lcd.setCursor(0, 0);
  lcd.print("Temp: "); 
  lcd.print(t);     
  lcd.print(" C");     
  lcd.setCursor(0, 1);
  lcd.print("Humi: ");
  lcd.print(h);
  lcd.print(" %");     
  //delay(1000);
}
