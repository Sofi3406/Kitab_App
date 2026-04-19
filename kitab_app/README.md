# Kitab App

Flutter app for reading a PDF lesson while listening to lesson audio.

## Overview

Kitab App is a study companion for the book "Sharh Usuli Sitah".
It provides:

- A lesson list (20 lessons)
- PDF viewer inside the app
- Audio playback for each lesson
- Playback position restore between sessions
- Per-lesson notes saved locally on device

The app UI includes Amharic and Arabic content and uses custom fonts bundled in assets.

## Features

- Lesson selection screen with cover/header section
- In-screen PDF reading using Syncfusion PDF Viewer
- Audio controls (play/pause, seek slider, elapsed/total time)
- Auto-resume from last saved audio position
- Lesson notes panel:
	- Add note
	- Delete note
	- Persistent local storage

## Tech Stack

- Flutter (Dart)
- syncfusion_flutter_pdfviewer
- audioplayers
- shared_preferences
- share_plus

## Project Structure

```text
lib/
	main.dart
	home_screen.dart
	audio_pdf_screen.dart
	audio_state_storage.dart
	note_storage.dart

assets/
	kitab/
	fonts/
```

## Requirements

- Flutter SDK 3.x
- Dart SDK >= 3.0.0 < 4.0.0

## Run Locally

1. Install dependencies:

```bash
flutter pub get
```

2. Run on a connected device or emulator:

```bash
flutter run
```

## Build

Android APK:

```bash
flutter build apk --release
```

iOS (macOS only):

```bash
flutter build ios --release
```

## Assets Note

Large media files are intentionally excluded from version control via .gitignore patterns for audio and PDF files under assets.
If you clone this repository and media is missing, place required lesson audio/PDF files in assets/kitab/.

## Package Name

- App name: ሸርህ ኡሱሊ ሲታህ
- Project package: kitab_app
