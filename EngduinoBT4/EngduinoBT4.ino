#include <EngduinoLEDs.h>
#include <EngduinoLight.h>
#include <EngduinoThermistor.h>

unsigned long l;
void setup() {
  // put your setup code here, to run once:
  EngduinoLight.begin();
  EngduinoThermistor.begin();
  Serial.begin(9600);
  Serial1.begin(9600);
}

void loop() {
  l = EngduinoLight.lightLevel();
  float t = EngduinoThermistor.temperature();
  // put your main code here, to run repeatedly:
  Serial1.println("Temp is: ");
  Serial.println(t);
  Serial1.println(t);
}
