#include <EngduinoLEDs.h>
// This example uses bluetooth to light up the engduino led
char tmp;
int digit;

void setup() {
  // put your setup code here, to run once:
  EngduinoLEDs.begin();
  Serial1.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  if(Serial1.available())
  {
    tmp = Serial1.read();
    if(isDigit(tmp))
    {
      digit = int(tmp);
      if(47<digit<58)
      {
        digit = digit -48;
        Serial.println(digit);
        EngduinoLEDs.setLED(digit,WHITE,3);
      }
    }
  }
}
