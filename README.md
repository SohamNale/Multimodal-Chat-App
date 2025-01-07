# Multimodal Chat App

A Flutter-based chat application that allows you to interact with multiple AI models including Llama 3.2, Gemini, and Mistral 3b. The app maintains conversation history across model switches and provides a seamless chat experience.

## Features

- **Multiple AI Models**: Switch between three powerful language models:
  - Llama 3.2 (1B Instruct)
  - Gemini 1.5 Flash
  - Mistral 3B
- **Context Awareness**: Maintains conversation history even when switching between models
- **Real-time Model Switching**: Easy model selection through dropdown menu
- **Modern UI**: Clean and intuitive chat interface with message bubbles
- **Loading Indicators**: Visual feedback during API calls

## Architecture

### Frontend (Flutter)
- Built with Flutter for cross-platform compatibility
- Uses HTTP package for API communication
- Implements Provider for state management
- Features a responsive and user-friendly interface

### Backend (Python)
- Flask-based REST API
- Integration with multiple AI models:
  - HuggingFace Transformers for Llama and Mistral
  - Google GenerativeAI for Gemini
- CORS support for cross-origin requests
- Ngrok for public URL exposure

## Prerequisites

- Flutter SDK (3.5.4 or higher)
- Python 3.x
- HuggingFace account and API token
- Google Cloud account and Gemini API key
- Ngrok account and authtoken

## Setup

### Backend Setup

1. Install required Python packages:
```bash
pip install -U flask-cors pyngrok transformers torch 
```
2. Update API credentials in Multimodal_Chat_API.ipynb:
 - Replace "Use your huggingface token" with your HuggingFace token
 - Replace "Use your Gemini API Key" with your Gemini API key
 - Replace "Use your ngrok token" with your Ngrok authtoken
3. Run the Flask server:
 - Execute all cells in Multimodal_Chat_API.ipynb
 - Copy the Ngrok public URL displayed in the output

### Frontend Setup
1. Update the API URL in main.dart:
```bash
final String apiUrl = 'YOUR_NGROK_URL/generate';
```
2. Install Flutter dependencies:
```bash
flutter pub get
```
3. Run the application:
```bash
flutter run
```

## Testing
Use Multimodal_API_test.ipynb to test the Flask API endpoints:

1. Update the ngrok_url variable with your Ngrok public URL
2. Run the notebook to test all model endpoints
3. Verify responses from each model

## Project Structure
```bash
├── lib/
│   └── main.dart           # Main Flutter application code
├── Multimodal_Chat_API.ipynb    # Backend Flask API implementation
├── Multimodal_API_test.ipynb    # API testing notebook
└── pubspec.yaml           # Flutter dependencies
```
## Dependencies
### Flutter
* http: ^1.2.2
* provider: ^6.1.2
* flutter_lints: ^4.0.0
### Python
* flask-cors
* pyngrok
* transformers
* torch

## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Flask](https://flask.palletsprojects.com/)
- [ngrok](https://ngrok.com/)
- [Hugging Face](https://huggingface.co/)
- [Google Generative AI](https://ai.google/tools/)
