# Scrapyard Scraps - Digital Currency System

This repository contains the front-end code for "Scraps," the official digital currency system developed for the Sydney Scrapyard Hackathon (November 2024 – March 2025). The system was designed to provide a seamless and engaging way for participants to manage and use their event-specific currency.

As the lead backend systems engineer, I am currently improving this system for the upcoming Submerged Hackathon in December, focusing on enhanced security and user experience.

## Overview

The "Scraps" system was a core component of the hackathon, allowing users to view their balance and interact with the event's economy. The application was built with a Flutter front-end and a Supabase back-end, chosen strategically to leverage sponsorship credits and adhere to budget constraints after an initial prototype on Firebase.

## Features

*   **Digital Currency Management**: Users can view their "scrap" balance in a clear, scrollable interface.
*   **User Authentication**: Streamlined user sign-in and management implemented using Google Sign-In.
*   **NFC Integration**: Includes functionality for NFC tag scanning to interact with the currency system.
*   **Bulk Operations**: An option for bulk assignment of scraps via NFC scanning is available in the mobile app.
*   **User Profiles**: The UI displays user profiles with their name, scrap amount, and a gender-specific profile image.

## Technical Stack

*   **Frontend**: Flutter
*   **Backend**: Supabase
*   **Authentication**: Google Sign-In via Supabase

## Platform-Specific Notes

*   **Web Deployment**: The NFC scanning functionality is not operational on the web deployment. This is a limitation of the `nfc_manager` package and web browser capabilities.
*   **Mobile Deployment**: The application is available as an Android APK. Due to the absence of Apple developer provisional profiles, there is no iOS version available for development or distribution.

## Dependencies

The project relies on several key packages to function:

*   `flutter`: The core framework for building the application.
*   `google_sign_in`: For handling user authentication with Google.
*   `nfc_manager`: To enable NFC reading capabilities on supported devices.
*   `supabase_flutter`: The official client for integrating with the Supabase backend.
*   `app_links`: For handling deep linking.

## Assets

The application uses a variety of local assets, including:
*   User profile images (male and female variants)
*   UI components like search bars and widgets
*   Logos and background images

## Getting Started

To get a local copy up and running, follow these steps.

### Prerequisites

*   Flutter SDK installed.
*   An Android device or emulator for testing full functionality (including NFC).

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/Nightclaus/scrapyard-scraps-frontend.git
    ```
2.  **Navigate to the project directory:**
    ```sh
    cd scrapyard-scraps-frontend/
    ```
3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```
4.  **Create a .env file (use Nano for Linux or Notepad for Window):**
    ```sh
    touch ./.env
    open ./.env
    ```
    You will need to define:
    - SUPABASE_URL
    - SUPABASE_ANON
6.  **Run the application:**
    ```sh
    flutter run
    ```

## Future Improvements

This system is being actively developed and enhanced for the upcoming Submerged Hackathon. Key areas of focus include:
*   Improving system security.
*   Enhancing the overall user experience.
*   Refining the backend architecture for greater scalability and reliability.
