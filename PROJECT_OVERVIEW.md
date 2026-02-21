# FutureFinder - AI-Powered Career Guidance App

## Project Overview

FutureFinder is a cross-platform mobile application that provides personalized career recommendations, job search, goal tracking, and learning resources for students and professionals.

### Tech Stack

**Frontend:**
- Flutter (Dart) - Cross-platform mobile framework
- Provider - State management
- HTTP package - API communication
- Flutter Secure Storage - Token storage

**Backend:**
- Django 4.2 - Python web framework
- Django REST Framework - RESTful APIs
- SQLite - Database
- CORS headers - Mobile app support

### Key Features

1. **Authentication**
   - Email/Password login and registration
   - Offline mode support
   - Login activity tracking
   - Secure token storage

2. **AI Career Matching**
   - Profile setup (academic level, stream, skills, interests)
   - Intelligent career recommendations
   - Match scoring algorithm (40-100%)
   - Skill gap analysis
   - Market outlook and salary information
   - AI chatbot for career advice

3. **Job Search**
   - Live job listings
   - Search and filter by location
   - Apply to jobs
   - Track job applications
   - Integration with job APIs

4. **Goal Management**
   - Set career goals
   - Track progress
   - Goal completion monitoring

5. **Learning Resources**
   - Course recommendations
   - Learning paths
   - Skill development resources

6. **Career Resources**
   - Career path exploration
   - Industry insights
   - Trending careers

## Project Structure

```
ffvs/
├── lib/                          # Flutter app
│   ├── models/                   # Data models
│   │   ├── career.dart
│   │   ├── goal.dart
│   │   ├── job.dart
│   │   └── user.dart
│   ├── providers/                # State management
│   │   ├── auth_provider.dart
│   │   ├── career_provider.dart
│   │   └── goal_provider.dart
│   ├── screens/                  # UI screens
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── dashboard_screen.dart
│   │   ├── ai_matching_screen.dart
│   │   ├── recommendations_screen.dart
│   │   ├── live_jobs_screen.dart
│   │   ├── goals_screen.dart
│   │   ├── job_applications_screen.dart
│   │   ├── learning_screen.dart
│   │   ├── profile_screen.dart
│   │   └── login_activity_screen.dart
│   ├── services/                 # API services
│   │   └── api_service.dart
│   └── main.dart                 # App entry point
│
└── backend/                      # Django backend
    ├── apps/                     # Django apps
    │   ├── authentication/       # User auth
    │   ├── careers/              # Career data
    │   ├── jobs/                 # Job listings
    │   ├── learning/             # Courses
    │   ├── ai_matching/          # AI recommendations
    │   └── auth_views.py         # Auth endpoints
    ├── futurefinder/             # Django project
    │   ├── settings.py
    │   └── urls.py
    ├── db.sqlite3                # Database
    ├── manage.py
    └── requirements.txt          # Python dependencies
```

## How to Run

### Prerequisites

- Flutter SDK (3.8.1+)
- Python 3.8+
- Android Studio / VS Code
- Android device or emulator

### Backend Setup

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Create virtual environment:**
   ```bash
   python -m venv venv
   venv\Scripts\activate  # Windows
   source venv/bin/activate  # Mac/Linux
   ```

3. **Install dependencies:**
   ```bash
   pip install django djangorestframework django-cors-headers
   ```

4. **Run migrations:**
   ```bash
   python manage.py migrate
   ```

5. **Create test user:**
   ```bash
   python create_test_user.py
   ```

6. **Get your computer's IP address:**
   ```bash
   ipconfig  # Windows
   ifconfig  # Mac/Linux
   ```
   Note the IPv4 address (e.g., 192.168.x.x)

7. **Start Django server:**
   ```bash
   python manage.py runserver 0.0.0.0:8000
   ```

### Frontend Setup

1. **Update API base URL:**
   - Open `lib/services/api_service.dart`
   - Replace `192.168.94.161` with your computer's IP address
   - Open `lib/screens/ai_matching_screen.dart`
   - Replace `192.168.94.161` with your computer's IP address

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Connect your Android phone:**
   - Enable USB debugging on your phone
   - Connect via USB or ensure phone and computer are on same WiFi
   - Verify connection: `flutter devices`

4. **Run the app:**
   ```bash
   flutter run
   ```

### Test Credentials

**Login with:**
- Email: `user@test.com`
- Password: `testpass123`

OR

- Username: `testuser`
- Password: `testpass123`

**Or register a new account** (works in offline mode)

## API Endpoints

### Authentication
- `POST /api/auth/login/` - User login
- `POST /api/auth/register/` - User registration
- `GET /api/profile/` - User profile

### Careers
- `GET /api/careers/` - Career recommendations

### Jobs
- `GET /api/jobs/` - Job listings

### Learning
- `GET /api/learning/` - Course listings

### AI Matching
- `POST /api/ai/chat-bot/` - AI chatbot

## Features Walkthrough

### 1. Login/Register
- Open app → Login or Register
- Works offline with any credentials

### 2. AI Career Matching
- Navigate to AI Matching screen
- Select academic level and stream
- Add 2+ skills and 1+ interest
- Click "Get AI Recommendations"
- View personalized career matches with:
  - Match score (40-100%)
  - AI reasoning
  - Skill gaps
  - Salary range
  - Growth rate

### 3. Job Search
- Navigate to Live Jobs
- Search by keywords
- Filter by location
- Apply to jobs
- Track applications

### 4. Goal Management
- Navigate to Goals screen
- Add career goals
- Track progress
- Delete completed goals

### 5. View Login Activity
- Navigate to Login Activity
- See login email, method, and timestamp

## Offline Mode

The app works fully offline:
- Login/Register with any credentials
- AI recommendations based on local database
- All features accessible without server

## Troubleshooting

### Network Error on Phone
1. Ensure Django server is running on `0.0.0.0:8000`
2. Check phone and computer are on same WiFi
3. Update IP address in `api_service.dart` and `ai_matching_screen.dart`
4. Disable Windows Firewall temporarily

### Bottom Overflow Error
- Fixed with `resizeToAvoidBottomInset: false` in Scaffold
- SafeArea wrapper on input fields

### App Name
- Changed from "ffvs" to "FutureFinder" in `AndroidManifest.xml`

## Future Enhancements

- Real-time job API integration
- Advanced AI chatbot with NLP
- Resume builder
- Interview preparation
- Networking features
- Mentorship matching
- Push notifications
- Cloud sync

## License

MIT License - Free for educational and commercial use

## Contact

For issues or questions, refer to the project documentation.
