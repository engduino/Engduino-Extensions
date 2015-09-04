#define __BOARD_ENGDUINOV3

#include "Arduino.h"

#include "libraries/EngduinoThermistor/EngduinoThermistor.h"
#include "libraries/EngduinoThermistor/EngduinoThermistor.cpp"

#include "libraries/EngduinoLight/EngduinoLight.h"
#include "libraries/EngduinoLight/EngduinoLight.cpp"

#include "libraries/SPI/SPI.h"
#include "libraries/SPI/SPI.cpp"
#include "libraries/EngduinoLEDs/EngduinoLEDs.h"
#include "libraries/EngduinoLEDs/EngduinoLEDs.cpp"

#include "libraries/Wire/twi.h"
#include "libraries/Wire/twi.c"
#include "libraries/Wire/Wire.h"
#include "libraries/Wire/Wire.cpp"
#include "libraries/EngduinoAccelerometer/EngduinoAccelerometer.h"
#include "libraries/EngduinoAccelerometer/EngduinoAccelerometer.cpp"
#include "libraries/EngduinoMagnetometer/EngduinoMagnetometer.h"
#include "libraries/EngduinoMagnetometer/EngduinoMagnetometer.cpp"

#include "libraries/EngduinoIR/EngduinoIR.h"
#include "libraries/EngduinoIR/EngduinoIR.cpp"

// #include "libraries/EngduinoSD/utility/FatStructs.h"
// #include "libraries/EngduinoSD/utility/Sd2Card.cpp"
// #include "libraries/EngduinoSD/utility/Sd2Card.h"
// #include "libraries/EngduinoSD/utility/Sd2PinMap.h"
// #include "libraries/EngduinoSD/utility/SdFat.h"
// #include "libraries/EngduinoSD/utility/SdFatmainpage.h"
// #include "libraries/EngduinoSD/utility/SdFatUtil.h"
// #include "libraries/EngduinoSD/utility/SdFile.cpp"
// #include "libraries/EngduinoSD/utility/SdInfo.h"
// #include "libraries/EngduinoSD/utility/SdVolume.cpp"
// #include "libraries/EngduinoSD/SD.cpp"
// #include "libraries/EngduinoSD/SD.h"
// #include "libraries/EngduinoSD/File.cpp"
// #include "libraries/EngduinoSD/EngduinoSD.cpp"
// #include "libraries/EngduinoSD/EngduinoSD.h"


extern "C" float thermistor_wrapper() {
	static uint8_t init = 0;
	if (init == 0) {
		EngduinoThermistor.begin();
		init = 1;
	}

	return EngduinoThermistor.temperature();
}

extern "C" uint16_t photodiode_wrapper() {
	static uint8_t init = 0;
	if (init == 0) {
		EngduinoLight.begin();
		init = 1;
	}

	return EngduinoLight.lightLevel();
}

extern "C" void rgb_leds_wrapper(uint8_t index, uint8_t r, uint8_t g, uint8_t b) {
	static uint8_t init = 0;
	if (init == 0) {
		EngduinoLEDs.begin();
		init = 1;
	}

	EngduinoLEDs.setLED(index, r, g, b);
}

extern "C" void accelerometer_wrapper(float accel[3]) {
	static uint8_t init = 0;
	if (init == 0) {
		EngduinoAccelerometer.begin();
		init = 1;
	}
	EngduinoAccelerometer.xyz(accel);
}

extern "C" void magnetometer_wrapper(float accel[3]) {
	static uint8_t init = 0;
	if (init == 0) {
		EngduinoMagnetometer.begin();
		init = 1;
	}
	EngduinoMagnetometer.xyz(accel);
}

extern "C" uint8_t button_wrapper() {
	static uint8_t init = 0;
	if (init == 0) {
		pinMode(BUTTON, INPUT);
		init = 1;
	}
	if (digitalRead(BUTTON) == LOW)
		return 1;
	else
		return 0;
}

void init_ir() {
	static uint8_t init = 0;
	if (init == 0) {
		EngduinoIR.begin();
		init = 1;
	}
}

extern "C" uint8_t ir_receive_wrapper() {
	init_ir();

	uint8_t buf[IRBUFSZ];
	int len = EngduinoIR.recv(buf, 1);
	if (len < 0)
		return 0;
	else
		return buf[0];

}

extern "C" void ir_send_wrapper(uint8_t data) {
	init_ir();

	EngduinoIR.send(data);
}

// extern "C" void sd_write_wrapper(double data) {
// 	static uint8_t init = 0;
// 	if (init == 0) {
// 		EngduinoLEDs.begin();
// 		EngduinoLEDs.setLED(14, 0, 0, 1);
// 		EngduinoSD.begin("data.txt", FILE_WRITE);
// 		init = 1;
// 	}
// 	String s = "mata";
// 	if (EngduinoSD.writeln(s))
// 		EngduinoLEDs.setLED(14, 0, 1, 0);
// 	else
// 		EngduinoLEDs.setLED(14, 1, 0, 0);
// }