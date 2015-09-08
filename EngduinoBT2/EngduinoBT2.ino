#include <EngduinoLEDs.h>
#include <EngduinoLight.h>
#include <SoftwareSerial.h>

// This example shows sending data through 
// bluetooth and send back data via bluetooth

char inChar;

// Define I/O pin numbers.
int gLedPin = 13;
int gKeyPin = 12;
int gResetPin = 6;

void setup() {
  pinMode(gLedPin, OUTPUT);
  pinMode(gResetPin, OUTPUT);
  pinMode(gKeyPin, OUTPUT);
  digitalWrite(gResetPin, LOW);
  digitalWrite(gKeyPin, LOW);
  // put your setup code here, to run once:
  Serial.begin(9600);
  Serial1.begin(9600);
  EngduinoLEDs.begin();
  EngduinoLight.begin();
}

void loop() {
  if(Serial1.available())
  {
  //while(!Serial1.available()); // wait for serial cmd
  //inChar = Serial1.read();
  //if(inChar=='0') 
    //EngduinoLEDs.setLED(1,OFF);
  //if(inChar=='1')
    char tmp = Serial1.read();
    
    EngduinoLEDs.setLED(1,WHITE,3); 
    Serial1.println(tmp);
    Serial.println("Hello");
  }
}
