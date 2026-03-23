# Adaptive Flow App

# Project Description
My Adaptive Flow App is a Flutter-based productivity app designed to help users improve concentration and productivity through structured study sessions. The app combines "mood" based audio, user-specified timed sessions, and intelligent recommendations to create a personalized and minimal work environment. Users can select their mood and task type, designate a timed for the session, and receive adaptive audio playback along with suggestions based on past usage history.


# Team Members
- Jaden Woody – Developer


# Features
-  Start and manage focus sessions with customizable duration
-  Mood-based audio playback (Calm, Focus, Energy)
-  Countdown timer with pause, resume, and stop controls
-  Rule-based “AI” recommendation system based on past sessions
-  Local data storage using SQLite
-  Session history tracking (mood, task type, duration)
-  Delete past sessions
-  Dark mode toggle using SharedPreferences
-  Multi-screen navigation with clean UI structure


# Technologies Used
- Flutter (SDK)
- Dart
- SQLite (sqflite package)
- path package
- shared_preferences package
- audioplayers package


# Installation Instructions
## Prerequesites
- Install Flutter SDK
- Install Android Studio or VS Code
- Set up an emulator or connect an android device to PC

1. Clone the repository:
   ```bash
   git clone https://github.com/JayTK13/MADProj1.git
2. Navigate to folder:
    cd MADProj1/proj1
3. Install dependencies:
    flutter pub get
4. Run the app:
    flutter run


# Usage Guide
- When the app opens, you are greeted with the main 3 fields in the "Start" screen
- Mood can be set to: Calm, Focus, or Energy; each having their own song
- The thre types of tasks can be: Studying, Coding, or Reading
- The duration can be set to a "minute" duration
- There is a setting gear in the top right to switch between light and dark mode
- Once the session is started the music plays, the timer displays, and there are time and audio playback buttons available
- The "History" screen shows past sessions' mood, task, and duration, as well as the option to clear each entry
- The "AI Suggestion" will suggest a mood and taske based on your last 3 sessions


# Datavase Schema
## Table: "sessions"
id         INTERGER     Primary Key for Auto Increment
mood       TEXT         Select mood
taskType   TEXT         Type of task
duration   INTERGER     Session duration in minutes
createdAt  TEXT         Timestap of created session


# Known Issues
- Audio has potential to not run in background if minimized or sceen changed
- If app is restarted then timer will reset itself


# Future Enhancements
- Consistent background app behavior (audio/timer)
- Intergration into system notification tray UI (Spotify-esque)
- Usage trend vizualization
- Allow user to upload music to app for personalized audio
- cloud streamed audio to reduce app size/performance cost
- Session presets
- Further develop AI


# Liscense
This project is liscensed under the MIT License.

# Flutter Version
- FLutter version: 3.38.9
- Dart version: 3.10.8