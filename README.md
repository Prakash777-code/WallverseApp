# WallVerse — Flutter App

A Flutter mobile application for discovering, saving, and interacting with wallpapers.

WallVerse connects to a NestJS REST API and provides wallpaper discovery, favourites, community wallpapers, likes, user profiles, and AI-generated wallpapers.

## 📱 Features

* 🔍 Search and browse wallpapers
* 📄 Paginated wallpaper loading
* ❤️ Like community wallpapers
* 🔖 Add and remove favourites
* 👥 Browse community wallpapers
* ⬆️ Upload wallpapers
* 🗑️ Delete your uploaded wallpapers
* 👤 View user profile and wallpaper statistics
* 🤖 Generate AI wallpapers from prompts
* 🔐 Secure authentication
* 🔄 Access-token refresh handling
* 🌐 REST API integration
* ⚠️ Structured loading, success, and error states

## 🏗️ Architecture

The application follows an MVVM-style architecture with repositories and service layers.


UI
 │
 ▼
ViewModel
 │
 ▼
Repository
 │
 ▼
API Service
 │
 ▼
NestJS REST API


### Responsibilities

**View**

Handles UI and user interactions.

**ViewModel**

Manages application state, loading states, errors, and user actions.

**Repository**

Acts as the data layer between ViewModels and API services.

**API Service**

Handles HTTP communication with the backend.

**Secure Storage**

Stores authentication tokens securely on the device.

## 🛠️ Tech Stack

* Flutter
* Dart
* MVVM
* Repository Pattern
* REST APIs
* Secure Storage
* HTTP
* Flutter Toast

## 🔐 Authentication Flow

The application uses access and refresh tokens.


Login
  ↓
Backend returns tokens
  ↓
Secure Storage
  ↓
API Request
  ↓
Access Token Expired?
  ↓
Refresh Token
  ↓
New Access Token
  ↓
Retry Request


If the refresh token is no longer valid, the user is required to authenticate again.

## 🖼️ Screenshots

Screenshots will be added here.

### Home

![Home](screenshots/home.png)

### Wallpaper Details

![Wallpaper Details](screenshots/wallpaper-details.png)

### Favourites

![Favourites](screenshots/favourites.png)

### Community

![Community](screenshots/community.png)

### Profile

![Profile](screenshots/profile.png)

### AI Generation

![AI Generation](screenshots/ai-generation.png)

## 🎥 Demo

A short screen recording demonstrating the main application flow will be added here.

Coming soon

## 🔗 Backend

This application communicates with the WallVerse NestJS backend.

**Backend Repository:**
https://github.com/Prakash777-code/WallVerse-Backend

**Live API:**
https://wallverse-backend-q00l.onrender.com

## 🌐 Other WallVerse Applications

**Web Application:**
https://github.com/Prakash777-code/Wallpaper

**Web:**
https://wallverse-eight.vercel.app/

## 🚀 Getting Started

### Prerequisites

* Flutter SDK
* Android Studio or VS Code
* Android device/emulator

### Installation

Clone the repository:


git clone https://github.com/Prakash777-code/WallverseApp.git


Navigate into the project:


cd WallverseApp


Install dependencies:


flutter pub get


Run the application:


flutter run


## 📁 Project Structure


lib/
├── models/
├── services/
├── repositories/
├── viewmodels/
├── screens/
├── widgets/
└── helpers/

## 📚 What I Worked On

This project gave me hands-on experience with:

* Flutter application architecture
* MVVM
* Repository and service layers
* REST API integration
* Authentication
* Secure token storage
* Pagination
* User-specific data
* Image uploads
* API error handling
* Mobile application debugging
* Backend integration

## 📄 License

This project is created for learning and portfolio purposes.
