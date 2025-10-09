# Flutter Clean Architecture Blog App

A robust, full-stack blog application built using **Flutter** and **Supabase**, meticulously structured with Clean Architecture and designed with SOLID Principles in mind. The goal of this project was to create a scalable, testable, and maintainable application while delivering a smooth, offline-first user experience.

Walkthrough Video - https://drive.google.com/file/d/1QsD94We63cUrzaq0SiV2Vhmog3U4ZtwO/view?usp=sharing
New Feature Google Sign In with Supabase - https://drive.google.com/file/d/1CNo4aP5sy9LxoquVJOEgLCat8zV_s1Mu/view?usp=sharing

## ✨ Key Architectural Highlights
* **Clean Architecture:** Strict separation of concerns across Data, Domain, and Presentation layers for maximum modularity and testability.
* **SOLID Principles:** Adherence to principles like Dependency Inversion (implemented via GetIt) to ensure flexible and maintainable code.
* **State Management:** Utilizes BLoC (Business Logic Component) for predictable, event-driven state management.
* **Offline-First Experience:** Integration of Hive local database and network monitoring allows users to access content even without an internet connection.

## 💻 Tech Stack
| Component            | Technologies Used       | Description                                                                 |
|-----------------------|-------------------------|-----------------------------------------------------------------------------|
| **Frontend**          | **Flutter**, **Dart**  | Cross-platform mobile application development                               |
| **Backend/Database**  | **Supabase**           | Used for Authentication, Database (PostgreSQL), and Storage (for images)    |
| **State Management**  | **BLoC**               | Manages application state predictably using events and states               |
| **Local Storage**     | **Hive**               | Fast and efficient local key-value store for offline data caching           |
| **Dependency Injection** | **GetIt**           | Service Locator pattern for dependency management                           |

## 🛠️ Core Features

* **Secure Authentication:** User signup, login, and session persistence powered by Supabase Auth.
* **Content Management:** Users can create, edit, and upload new blog posts with associated images.
* **Intelligent Display:** Each post shows an auto-calculated reading time for improved user convenience.
* **Network Resilience:** Continuous network monitoring ensures seamless switching between online and offline sources.
* **Image Handling:** Upload, store, and retrieve blog cover images using Supabase Storage.
* **Offline-First Experience:** Integration of Hive local database and network monitoring allows users to access content even without an internet connection.

## 📁 Setup and Installation

### 📌 Prerequisites
Before you begin, make sure you have the following installed and set up:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- A [Supabase](https://supabase.com) account

---

### ⚙️ 1. Supabase Setup
1. **Create a New Project** in your Supabase dashboard.
2. **Database Tables**: Create the necessary tables (e.g., `blogs`, `users`) as required by the app’s domain model.
3. **Storage Buckets**: Set up a storage bucket for saving blog post images.

---

### 🔑 2. Configure Environment
1. **Clone this repository**
   ```bash
   git clone https://github.com/karanshrma/blog_app.git
   cd blog_app
