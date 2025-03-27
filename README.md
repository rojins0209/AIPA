# AIPA - AI Phone Advisor

**AIPA** (AI Phone Advisor) is a Flutter-based mobile application that leverages artificial intelligence to help users find the perfect smartphone. With a sleek conversational interface, AIPA provides personalized phone recommendations, detailed specifications, and external links—all in a user-friendly, single-screen experience.

---

## Features

- **AI-Powered Chat**: Interact with an AI assistant to get tailored smartphone recommendations.
- **In-Chat Recommendations**: View suggestions in a collapsible section without leaving the chat.
- **Professional Splash Screen**: A smooth fade-in/fade-out animation showcasing the AIPA brand.
- **Detailed Phone Info**: Tap recommendations to explore specs, prices, and links to reviews or purchase pages.
- **Debounced Input**: 500ms debounce on message sending to optimize API calls.
- **Robust Error Handling**: Clear feedback for network or server issues.
- **Modular Design**: Organized code with services, utils, and reusable widgets.

---

## Screenshots

*(Add screenshots here if available)*  
- Splash Screen:   
- Chat Interface: ![alt text](<Chat Interface.jpg>)
- Recommendations: ![alt text](<Recommendations.jpg>)

---

## Prerequisites

- **Flutter SDK**: Version 3.0.0 or higher
- **Dart**: Version 2.17.0 or higher
- **Backend Server**: Running at `http://update with the ip address of your device/api/query` (configurable)
- **Dependencies**:
  - `http: ^0.13.5`
  - `flutter_spinkit: ^5.1.0`

---

## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/rojins0209/AIPA.git
   cd AIPA
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set Up Assets** (optional):
   - Add a logo to `assets/logo.png`.
   - Update `pubspec.yaml`:
     ```yaml
     flutter:
       assets:
         - assets/logo.png
     ```

4. **Configure Android Permissions**:
   - Add internet permission in `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <uses-permission android:name="android.permission.INTERNET" />
     ```

5. **Run the App**:
   - Connect a device or start an emulator.
   - Launch the app:
     ```bash
     flutter run
     ```

---

## Project Structure

```
AIPA/
├── android/              # Android-specific files
├── ios/                  # iOS-specific files
├── lib/                  # Main source code
│   ├── models/           # Data models
│   │   └── phone_model.dart
│   ├── screens/          # UI screens
│   │   ├── chat_screen.dart
│   │   └── splash_screen.dart
│   ├── services/         # API and business logic
│   │   └── api_service.dart
│   ├── utils/            # Utility classes and constants
│   │   └── constants.dart
│   ├── widgets/          # Reusable UI components
│   │   ├── loading_indicator.dart
│   │   ├── phone_bento_card.dart
│   │   └── phone_detail_sheet.dart
│   └── main.dart         # App entry point
├── assets/               # Static assets (e.g., logo.png)
└── pubspec.yaml          # Project dependencies and configuration
```

---

## Usage

1. **Launch the App**:
   - Starts with a splash screen displaying "AIPA" (and a logo if added) with a fade animation.

2. **Chat with AIPA**:
   - Enter a query (e.g., "best phone under $300") in the chat input and send it.
   - The AI responds with recommendations based on your input.

3. **View Recommendations**:
   - Recommendations appear in a collapsible section below the chat.
   - Toggle visibility with the AppBar eye icon or close button.

4. **Explore Details**:
   - Tap a phone card to view detailed specs, pricing, and external links in a bottom sheet.

---

## Backend Integration

- **API Endpoint**: Configured in `services/api_service.dart` (default: `http://192.168.42.120:4000/api/query`).
- **Request Format**:
  ```json
  {
    "query": "user's question"
  }
  ```
- **Expected Response**:
  ```json
  {
    "response": "AI-generated text response",
    "phones": [
      {
        "name": "Phone Name",
        "image": "URL",
        "price": "Price",
        "specifications": {"key": "value"},
        "youtube_link": "URL",
        "product_url": "URL"
      }
    ]
  }
  ```
- **Configuration**:
  - Update the API URL in `constants.dart` or `api_service.dart` if different.

---

## Customization

- **Splash Screen**:
  - Modify background color in `splash_screen.dart`:
    ```dart
    backgroundColor: const Color(0xFF2196F3)
    ```
  - Adjust animation timing:
    ```dart
    duration: const Duration(milliseconds: 1000)
    ```

- **Theme**:
  - Update `main.dart`:
    ```dart
    theme: ThemeData(
      primarySwatch: Colors.blue,
    )
    ```

- **Logo**:
  - Add `assets/logo.png` and uncomment `Image.asset` in `splash_screen.dart`.

---

## Known Issues

- **Network Dependency**: Requires a running backend server on the specified IP.
- **Image Errors**: Displays "Image" text if network images fail to load.

---

## Contributing

1. Fork the repository: `https://github.com/rojins0209/AIPA.git`.
2. Create a feature branch: `git checkout -b feature/your-feature`.
3. Commit changes: `git commit -m "Add your feature"`.
4. Push to the branch: `git push origin feature/your-feature`.
5. Open a pull request.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details (to be added).

---

## Acknowledgments

- Built with [Flutter](https://flutter.dev/).
- Inspired by AI assistants like ChatGPT and Grok.
- Thanks to the Flutter community for packages like `flutter_spinkit` and `http`.

---

