## Project Aim
Build an Android app that detects and classifies multiple objects in a video using AI.

## Technologies Used
1. Flutter: To develop the Android app.
2. Flask: To handle API calls.
3. YOLO Model: For object detection and classification in videos.

## How to Use This Project
You can either modify the project following the steps below or directly install the APK and start from Step 4.

1. Replace the android folder, lib folder, and pubspec.yaml file in your Flutter project with those provided in this repository.
2. Make any desired changes to the project.
3. Build the APK and install it on an Android device.
4. Ensure that both your Android device and PC are connected to the same local network (e.g., the same WiFi) as socket programming is used.
5. Install Python on your PC.
6. Install Flask: pip install flask.
7. Download the "Backend" folder and run app.py located in the Backend folder: python app.py.
8. Open the app on your Android device and enter your PC's IP address (Go to command prompt and use ipconfig to find your IP address).
9. Upload a video and click on process button
10. Wait for the result. Finally click on download button.

## Notes
The app may take some time to process videos as the AI model runs, so please be patient.
