#include <Servo.h>

const int verticalServoPin = 2;
const int horizontalServoPin = 3;
const int laserPin = 4;
const int servoDelta = 5;

Servo verticalServo; 
Servo horizontalServo; 

int laserOn = LOW; 
int vertical = 90;
int horizontal = 90;


void setup() {
  verticalServo.attach(verticalServoPin);
  horizontalServo.attach(horizontalServoPin);
  verticalServo.write(vertical);
  horizontalServo.write(horizontal);
  
  pinMode(laserPin, OUTPUT);
  
  Serial.begin(9600);
}

void loop() 
{   
  digitalWrite(laserPin, laserOn);
  if (Serial.available()) {
    char direction = Serial.read();
    Serial.println("Received: " + String(direction));
    switch(direction) {
      case 'u':
        vertical += servoDelta;
        break;
      case 'd':
        vertical -= servoDelta;
        break;
      case 'l':
        horizontal += servoDelta;  
        break;
      case 'r':
        horizontal -= servoDelta; 
        break;
      case 'x':
        laserOn = !laserOn;
        digitalWrite(laserPin, laserOn);
        break;
    }
    vertical = constrain(vertical, 0, 180);
    horizontal = constrain(horizontal, 0, 180);
    verticalServo.write(vertical);
    horizontalServo.write(horizontal);
  } 
}   
