# AryHoops 🏀

## Table of Contents

1. [Overview](#overview)
2. [Product Spec](#product-spec)
3. [Wireframes](#wireframes)
4. [Schema](#schema)
5. [Demo](#demo)
6. [Installation & Setup](#installation--setup)
7. [Features](#features)
8. [Technologies Used](#technologies-used)

## Overview

### Description
AryHoops is a comprehensive basketball-focused iOS application designed to keep fans updated with live game scores, player and team statistics, and game schedules. The app features a unique virtual betting system where users can predict game outcomes using virtual currency, creating an engaging and competitive experience for basketball enthusiasts.

### App Evaluation

- **Category:** Sports & Entertainment
- **Platform:** iOS (Mobile-first design)
- **Story:** AryHoops brings the basketball community together by offering real-time updates, comprehensive statistics, and an interactive virtual betting feature that enhances fan engagement
- **Market:** Basketball fans, sports enthusiasts, and users who enjoy live updates and interactive gaming features
- **Habit:** Encourages daily use during basketball season with frequent engagement for live game tracking and virtual betting activities
- **Scope:** Focused on basketball with essential features including live scores, statistics, schedules, and virtual betting system

## Product Spec

### 1. User Stories

**Required Must-have Stories**
- ✅ User can view live basketball scores with real-time updates
- ✅ User can view player and team statistics
- ✅ User can view upcoming game schedules
- ✅ User can place virtual bets on game outcomes using virtual currency
- ✅ User can register and log into their account

**Optional Nice-to-have Stories**
- ✅ User can view favorites section to track favorite teams and players
- ✅ Virtual currency balance updates when bets are placed or won
- ✅ User can earn virtual currency through daily rewards or winning bets
- ✅ User can set reminders for favorite team games or key events
- ✅ User can receive push notifications for live game updates and bet results
- ✅ User can customize profiles with favorite teams or players
- ✅ User can share betting predictions or game stats with friends on social media

### 2. Screen Archetypes

- **Login Screen** ✅
  - User authentication and login functionality
  
- **Registration Screen** ✅
  - New user account creation
  
- **Home Screen** ✅
  - Live basketball scores with real-time updates
  - Player and team statistics
  - Upcoming game schedules
  
- **Betting Screen** ✅
  - Virtual betting on game outcomes
  - Betting history and management
  
- **Favorites Screen** ✅
  - Track favorite teams and players
  - Personalized updates and statistics

### 3. Navigation

**Tab Navigation**
- **Home** → Live scores, stats, schedule
- **Betting** → Betting screen and history
- **Favorites** → User's favorite teams and players

**Flow Navigation**
- Login/Registration → Home Screen
- Home Screen → Betting Screen (via button/tab)
- Home Screen → Favorites Screen (via tab/favorite icon)
- Cross-navigation between all main screens

## Wireframes

<img width="1360" alt="AryHoops Wireframes@2x" src="https://github.com/user-attachments/assets/112bab9a-6163-4d7c-9656-4303d603c45a">

**Interactive Prototype:** [Figma Wireframes](https://www.figma.com/proto/OGnVVV7bzdjgYql61PTg6F/AryHoops-Wireframes?node-id=0-1&t=EmeDLBcYUXOEwKT2-1)

## Schema

### Models

| Model | Property | Type | Description |
|-------|----------|------|-------------|
| **User** | username | String | Unique identifier for the user |
| | password | String | User's password for authentication |
| | email | String | User's email for account recovery |
| | points | Int | Virtual currency balance |
| | favorites | Array | List of favorite teams |

### Networking

**Authentication**
- `[POST] /users/login` - User login
- `[POST] /users/register` - User registration

**Home Screen**
- `[GET] /games/live` - Live basketball scores
- `[GET] /players/stats` - Player and team statistics
- `[GET] /games/schedule` - Upcoming game schedules
- `[GET] /standings` - Current league standings

**Favorites**
- `[GET] /users/{userId}/favorites` - Fetch user favorites
- `[POST] /users/{userId}/favorites` - Add to favorites
- `[DELETE] /users/{userId}/favorites` - Remove from favorites

**Betting**
- `[POST] /bets` - Place new bet
- `[GET] /bets/{userId}` - User betting history
- `[PUT] /bets/{betId}` - Update bet status

## Demo

### GIF Preview
![AryHoops Demo](https://github.com/user-attachments/assets/dbf64b91-3284-4361-892e-739c5f81f924)

*Demo showing the app running on iPhone 16 Pro simulator*

### Video Walkthrough
▶️ **[Watch Full Demo on YouTube](https://www.youtube.com/watch?v=2ks4rYU58LY)**

## Installation & Setup

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+
- Firebase account

### Setup Instructions
1. Clone the repository
2. Open `AryHoops.xcodeproj` in Xcode
3. Configure Firebase:
   - Add your `GoogleService-Info.plist` to the project
   - Enable Authentication and Firestore in Firebase Console
4. Build and run the project

### Dependencies
- SwiftUI (iOS 17.0+)
- Firebase Core
- Firebase Firestore
- Firebase Authentication

## Features

### Core Functionality
- **Live Scores**: Real-time basketball game updates
- **Statistics**: Comprehensive player and team stats
- **Schedules**: Upcoming game information
- **Virtual Betting**: Interactive betting system with virtual currency
- **User Authentication**: Secure login and registration
- **Favorites**: Personalized team and player tracking

### User Experience
- Dark mode interface
- Smooth animations and transitions
- Intuitive tab-based navigation
- Responsive design for various iOS devices

## Technologies Used

- **Frontend**: SwiftUI
- **Backend**: Firebase (Firestore, Authentication)
- **Architecture**: MVVM pattern
- **Language**: Swift 5.9+
- **Platform**: iOS 17.0+

## Contributing

This is a personal project for educational purposes. Feel free to explore the code and provide feedback.

## License

This project is created for educational purposes as part of an iOS development course.

---

**Developed by Aryan Lakhani**
