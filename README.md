# speaking

A simple flutter voice chat

## Getting Started

1. Clone the project
2. Update the GEMINI AI API Key at main.dart
get yours here: https://aistudio.google.com/app/apikey
```
void main() {
  // put your GEMINI AI API KEY HERE
  // it should be look like --> AI########
  Gemini.init(apiKey: ""); 

  runApp(const MyApp());
}
```
3. Then just run it

## Features
1. Speech Recognition (Speech to text) using https://pub.dev/packages/speech_to_text
2. Response Generation using Gemini AI https://pub.dev/packages/flutter_gemini
3. AI voice (text to speech) using https://pub.dev/packages/flutter_tts/example
