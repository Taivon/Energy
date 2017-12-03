/*
 I/O control via IP addresses

 created Fall 2107
 by Taivon Thompson

 */

#include <SPI.h>
#include <Ethernet.h>

/*-----( Import needed libraries )-----*/
/*-----( Declare Constants )-----*/
#define RELAY_ON 0
#define RELAY_OFF 1
/*-----( Declare objects )-----*/
/*-----( Declare Variables )-----*/
#define Relay_1  2  // Arduino Digital I/O pin number
#define Relay_2  3
#define Relay_3  4
#define Relay_4  5
#define Relay_5  6  // Arduino Digital I/O pin number
#define Relay_6  7
#define Relay_7  8
#define Relay_8  9

boolean incoming = 0;

// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xDD};

IPAddress ip(10, 10, 10, 25);
//IPAddress ip(192, 168, 1, 25);
//IPAddress ip(10, 101, 66, 25);

// (port 80 is default for HTTP):
EthernetServer server(80);

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  digitalWrite(Relay_1, RELAY_OFF);
  digitalWrite(Relay_2, RELAY_OFF);
  digitalWrite(Relay_3, RELAY_OFF);
  digitalWrite(Relay_4, RELAY_OFF);  
  digitalWrite(Relay_5, RELAY_OFF);
  digitalWrite(Relay_6, RELAY_OFF);
  digitalWrite(Relay_7, RELAY_OFF);
  digitalWrite(Relay_8, RELAY_OFF);
  
//---( THEN set pins as outputs )----  
  pinMode(Relay_1, OUTPUT);   
  pinMode(Relay_2, OUTPUT);  
  pinMode(Relay_3, OUTPUT);  
  pinMode(Relay_4, OUTPUT); 
  pinMode(Relay_5, OUTPUT);   
  pinMode(Relay_6, OUTPUT);  
  pinMode(Relay_7, OUTPUT);  
  pinMode(Relay_8, OUTPUT); 
  
  // start the Ethernet connection and the server:
  Ethernet.begin(mac, ip);
  server.begin();
  Serial.print("server is at ");
  Serial.println(Ethernet.localIP());
}


void loop() {
    
  // listen for incoming clients
  EthernetClient client = server.available();
  if (client) {
    //Serial.print("server is at ");
    //Serial.println("new client");
    // an http request ends with a blank line
    boolean currentLineIsBlank = true;
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        //Serial.write(c);
        // if you've gotten to the end of the line (received a newline
        // character) and the line is blank, the http request has ended,
        // so you can send a reply
        
        if(incoming && c == ' ')
        //reads URL string from $ to first blank space
        { 
          incoming = 0;
        }
        if(c == '$'){ 
        // if we received a $ sign then we have received a request
          incoming = 1; 
        }
                //Check for the URL string $1 or $2
        if(incoming == 1){
          //Serial.println(c);
          // printing the result on the serial port (on your computer)
          if(c == '1'){
            //Serial.println("LED 1 ON");
            // printing "ON" to your screen.
            digitalWrite(Relay_1,RELAY_ON );
            // setting the 2nd pin state to HIGH (turning on the LED)
            //delay
          }
          if(c == '2'){
            //Serial.println("LED 1 OFF");
            // printing "OFF" to your screen.
            digitalWrite(Relay_1, RELAY_OFF);
            // setting the our LED state to off (turning it off)
          }
          if(c == '3'){
            //Serial.println("ON");
            // printing "ON" to your screen.
            digitalWrite(Relay_2,RELAY_ON );
            // setting the 2nd pin state to HIGH (turning on the LED)
          }
          if(c == '4'){
            //Serial.println("LED 2 OFF");
            // printing "OFF" to your screen.
            digitalWrite(Relay_2, RELAY_OFF);
            // setting the our LED state to off (turning it off)
          }
          if(c == '5'){
            //Serial.println("ON");
            // printing "ON" to your screen.
            digitalWrite(Relay_3,RELAY_ON );
            // setting the 2nd pin state to HIGH (turning on the LED)
          }
          if(c == '6'){
            //Serial.println("LED 3 OFF");
            // printing "OFF" to your screen.
            digitalWrite(Relay_3, RELAY_OFF);
            // setting the our LED state to off (turning it off)
          }
          if(c == '7'){
           // Serial.println("ON");
            // printing "ON" to your screen.
            digitalWrite(Relay_4,RELAY_ON );
            // setting the 2nd pin state to HIGH (turning on the LED)
          }
          if(c == '8'){
            //Serial.println("LED 4 OFF");
            // printing "OFF" to your screen.
            digitalWrite(Relay_4, RELAY_OFF);
            // setting the our LED state to off (turning it off)
          }
          if(c == '9'){
            //Serial.println("ON");
            // printing "ON" to your screen.
            digitalWrite(Relay_5,RELAY_ON );
            // setting the 2nd pin state to HIGH (turning on the LED)
          }
          if(c == '0'){
            //Serial.println("LED 5 OFF");
            // printing "OFF" to your screen.
            digitalWrite(Relay_5, RELAY_OFF);
            // setting the our LED state to off (turning it off)
          }
          if(c == 'a'){
            //Serial.println("ON");
            // printing "ON" to your screen.
            digitalWrite(Relay_6,RELAY_ON );
            // setting the 2nd pin state to HIGH (turning on the LED)
          }
          if(c == 'b'){
            //Serial.println("OFF");
            // printing "OFF" to your screen.
            digitalWrite(Relay_6, RELAY_OFF);
            // setting the our LED state to off (turning it off)
          }
          if(c == 'c'){
            //Serial.println("ON");
            // printing "ON" to your screen.
            digitalWrite(Relay_7,RELAY_ON );
            // setting the 2nd pin state to HIGH (turning on the LED)
          }
          if(c == 'd'){
            //Serial.println("OFF");
            // printing "OFF" to your screen.
            digitalWrite(Relay_7, RELAY_OFF);
            // setting the our LED state to off (turning it off)
          }
          if(c == 'e'){
            //Serial.println("ON");
            // printing "ON" to your screen.
            digitalWrite(Relay_8,RELAY_ON );
            // setting the 2nd pin state to HIGH (turning on the LED)
          }
          if(c == 'f'){
            //Serial.println("OFF");
            // printing "OFF" to your screen.
            digitalWrite(Relay_8, RELAY_OFF);
            
            // setting the our LED state to off (turning it off)
          }
          //Group A
          if(c == 'g'){
            //Serial.println("OFF");
            // printing "OFF" to your screen.
            digitalWrite(Relay_1, RELAY_OFF);
            digitalWrite(Relay_2, RELAY_OFF);
            digitalWrite(Relay_3, RELAY_OFF);
            digitalWrite(Relay_4, RELAY_ON);
            digitalWrite(Relay_5, RELAY_ON);
            digitalWrite(Relay_6, RELAY_ON);
            digitalWrite(Relay_7, RELAY_OFF);
            digitalWrite(Relay_8, RELAY_OFF);
            
            // setting the our LED state to off (turning it off)
          }
          //Group B
          if(c == 'h'){
            //Serial.println("OFF");
            // printing "OFF" to your screen.
            digitalWrite(Relay_1, RELAY_OFF);
            digitalWrite(Relay_2, RELAY_ON);
            digitalWrite(Relay_3, RELAY_OFF);
            digitalWrite(Relay_4, RELAY_ON);
            digitalWrite(Relay_5, RELAY_OFF);
            digitalWrite(Relay_6, RELAY_OFF);
            digitalWrite(Relay_7, RELAY_OFF);
            digitalWrite(Relay_8, RELAY_ON);
            
            // setting the our LED state to off (turning it off)
          }
          //Group C
          if(c == 'i'){
            //Serial.println("OFF");
            // printing "OFF" to your screen.
            digitalWrite(Relay_1, RELAY_ON);
            digitalWrite(Relay_2, RELAY_ON);
            digitalWrite(Relay_3, RELAY_ON);
            digitalWrite(Relay_4, RELAY_OFF);
            digitalWrite(Relay_5, RELAY_OFF);
            digitalWrite(Relay_6, RELAY_OFF);
            digitalWrite(Relay_7, RELAY_ON);
            digitalWrite(Relay_8, RELAY_OFF);
            
            // setting the our LED state to off (turning it off)
          }
          //Group D
          if(c == 'j'){
            //Serial.println("OFF");
            // printing "OFF" to your screen.
            digitalWrite(Relay_1, RELAY_OFF);
            digitalWrite(Relay_2, RELAY_ON);
            digitalWrite(Relay_3, RELAY_ON);
            digitalWrite(Relay_4, RELAY_OFF);
            digitalWrite(Relay_5, RELAY_OFF);
            digitalWrite(Relay_6, RELAY_OFF);
            digitalWrite(Relay_7, RELAY_ON);
            digitalWrite(Relay_8, RELAY_OFF);
            
            // setting the our LED state to off (turning it off)
          }
          
        
        }

        if (c == '\n') {
          // you're starting a new line
          currentLineIsBlank = true;
        } else if (c != '\r') {
          // you've gotten a character on the current line
          currentLineIsBlank = false;
        }
      }
    }
    // give the web browser time to receive the data
    delay(1);
    // close the connection:
    client.stop();
    //Serial.println("client disconnected");
  }
}

