#include <SoftwareSerial.h>

SoftwareSerial espSerial(2, 3);  // RX, TX

void setup() {
  Serial.begin(9600);
  espSerial.begin(9600);

  // Connect to Wi-Fi
  sendCommand("AT+CWMODE=1", 2000);
  sendCommand("AT+CWJAP=\"your_SSID\",\"your_PASSWORD\"", 5000);

  delay(1000);
}

void loop() {
  // Send data to Firebase Cloud Firestore
  String data = "{\"field1\":\"value1\",\"field2\":\"value2\"}";
  String collection = "your_collection_name";
  String document = "your_document_name";

  String command = "AT+CIPSEND=";
  String url = "https://your_project_id.firebaseio.com/";
  url += collection + "/" + document + ".json";

  command += String(url.length() + data.length() + 15);
  sendCommand(command, 2000);

  String request = "POST " + url + " HTTP/1.1\r\n";
  request += "Host: your_project_id.firebaseio.com\r\n";
  request += "Content-Type: application/json\r\n";
  request += "Content-Length: ";
  request += String(data.length()) + "\r\n\r\n";
  request += data;

  espSerial.print(request);

  delay(5000);
}

void sendCommand(String command, const int timeout) {
  espSerial.println(command);
  long int time = millis();
  while ((time + timeout) > millis()) {
    while (espSerial.available()) {
      char c = espSerial.read();
      Serial.print(c);
    }
  }
  Serial.println();
}
