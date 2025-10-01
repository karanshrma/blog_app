Flutter Clean Architecture Blog App
A robust, full-stack blog application built using Flutter and Supabase, meticulously structured with Clean Architecture and designed with SOLID Principles in mind. The goal of this project was to create a scalable, testable, and maintainable application while delivering a smooth, offline-first user experience.
✨ Key Architectural Highlights
Clean Architecture: Strict separation of concerns across Data, Domain, and Presentation layers for maximum modularity and testability.
SOLID Principles: Adherence to principles like Dependency Inversion (implemented via GetIt) to ensure flexible and maintainable code.
State Management: Utilizes BLoC (Business Logic Component) for predictable, event-driven state management.
Offline-First Experience: Integration of Hive local database and network monitoring allows users to access content even without an internet connection.
💻 Tech Stack
Component
Technologies Used
Description
Frontend
Flutter, Dart
Cross-platform mobile application development.
Backend/Database
Supabase
Used for Authentication, Database (PostgreSQL), and Storage (for images).
State Management
BLoC
Manages application state predictably using events and states.
Local Storage
Hive
Fast and efficient local key-value store for offline data caching.
Dependency Injection
GetIt
Service Locator pattern for dependency management.

🛠️ Core Features
Secure Authentication: User signup, login, and session persistence managed via Supabase Auth.
Content Management: Users can create and upload new blog posts with associated images.
Intelligent Display: Posts are displayed with an automatically calculated reading time for user convenience.
Network Resilience: Continuous network monitoring to seamlessly switch between online and offline data sources.
Image Handling: Upload and retrieval of blog cover images using Supabase Storage.
📁 Setup and Installation
Prerequisites
Flutter SDK installed
A Supabase account
1. Supabase Setup
   Create a New Project in your Supabase dashboard.
   Database Tables: Create the necessary tables (e.g., blogs, users) as required by the application's domain model.
   Storage Buckets: Set up a storage bucket for saving blog post images.
2. Configure Environment
   Clone this repository:
   git clone [https://github.com/karanshrma/blog_app.git](https://github.com/karanshrma/blog_app.git)
   cd blog_app


In the project, locate the file where global constants/configuration is stored (e.g., core/utils/constants.dart).
Replace the placeholder values with your Supabase credentials:
SUPABASE_URL
SUPABASE_ANON_KEY
3. Run the App
   Install dependencies:
   flutter pub get


Run the application on a connected device or emulator:
flutter run


