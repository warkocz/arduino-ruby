#include <IRremote.h>
#include <Servo.h>

const int verticalServoPin = 2;
const int horizontalServoPin = 3;
const int laserPin = 4;
const int irPin = 5;
const int servoDelta = 5;

IRrecv irrecv(irPin);
decode_results results;

Servo verticalServo; 
Servo horizontalServo; 

int laserOn = LOW; 
int vertical = 90;
int horizontal = 90;

void setup() {
  irrecv.enableIRIn();  
  
  verticalServo.attach(verticalServoPin);
  horizontalServo.attach(horizontalServoPin);
  verticalServo.write(vertical);
  horizontalServo.write(horizontal);
   
  pinMode(laserPin, OUTPUT);
  
  Serial.begin(9600);
}

void loop() 
{  
   if (irrecv.decode(&results)) {
      switch (results.value) {
         case 0x7469BF81:
            Serial.println("l_forward");
            vertical += servoDelta;
            break;
         case 0x7569C112:
            Serial.println("l_backward");
            vertical -= servoDelta;
            break;
         case 0x139C80D1:
            Serial.println("l_right");
            horizontal -= servoDelta;     
            break;
         case 0x28A1120F:
            Serial.println("l_left");
            horizontal += servoDelta;  
            break;
         case 0xECB3BDC9:
            Serial.println("l_stop");
            laserOn = !laserOn;
            digitalWrite(laserPin, laserOn);
            break;    
         default:
            Serial.print("0x");
            Serial.println(results.value, HEX);
      }
      verticalServo.write(constrain(vertical, 0, 180));
      horizontalServo.write(constrain(horizontal, 0, 180));
      irrecv.resume();
   }  
}   
