# Multimodal Chat App

This is a multimodal chat application that supports multiple AI models including Llama 3.2, Gemini, and Mistral 3b. The app maintains context history, allowing you to switch models mid-conversation while retaining the conversation history. The backend uses a Flask API to access the models, and ngrok is used to expose the Flask API publicly.

## Features

- Supports multiple AI models: Llama 3.2, Gemini, and Mistral 3b.
- Maintains context history across model switches.
- Dropdown list to select the desired model.
- Backend Flask API for model access.
- ngrok for exposing the Flask API publicly.
- Test notebook to verify the Flask API functionality.

## Project Structure
```sh
multimodal_chat_app/
├── .dart_tool/
├── .idea/
├── android/
├── build/
├── ios/
├── lib/
│   ├── main.dart
├── linux/
├── macos/
├── test/
├── web/
├── windows/
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── chat_app.iml
├── devtools_options.yaml
├── pubspec.lock
├── pubspec.yaml
├── README.md
├── Multimodal_API_test.ipynb
├── Multimodal_Chat_API.ipynb
```
## Getting Started

### Prerequisites

- Flutter SDK
- Python 3.x
- ngrok
- Flask
- Transformers library
- Hugging Face account and token

### Installation

1. **Clone the repository:**

    ```sh
    git clone https://github.com/yourusername/multimodal_chat_app.git
    cd multimodal_chat_app
    ```

2. **Set up the Flutter app:**

    ```sh
    flutter pub get
    ```

3. **Set up the Flask API:**

    ```sh
    pip install -U flask-cors pyngrok
    ```

4. **Install ngrok:**

    Follow the instructions on the [ngrok website](https://ngrok.com/download) to install ngrok.

### Running the Application

1. **Start the Flask API:**

    Open [Multimodal_Chat_API.ipynb](http://_vscodecontentref_/2) and run all cells to start the Flask API and get the ngrok public URL.

2. **Update the Flutter app with the ngrok URL:**

    In [main.dart](http://_vscodecontentref_/3), update the `apiUrl` variable with the ngrok public URL.

    ```dart
    final String apiUrl = 'https://your_ngrok_url_here/generate';
    ```

3. **Run the Flutter app:**

    ```sh
    flutter run
    ```

4. **Test the Flask API:**

    Open [Multimodal_API_test.ipynb](http://_vscodecontentref_/4) and run all cells to test the Flask API with different models.

## Usage

- Open the app and start a conversation.
- Use the dropdown list to switch between Llama 3.2, Gemini, and Mistral 3b models.
- The app will maintain the context history even when switching models.

## Acknowledgements

- [Flutter](https://flutter.dev/)
- [Flask](https://flask.palletsprojects.com/)
- [ngrok](https://ngrok.com/)
- [Hugging Face](https://huggingface.co/)
- [Google Generative AI](https://ai.google/tools/)
