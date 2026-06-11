# ALU Opportunities Hub

A Flutter mobile app that connects ALU students and organizers around campus events, hackathons, internships, workshops, and more.

---

## Features

**For Students**
- Browse and search events by category (Hackathon, Workshop, Talk, Internship, Program, Event)
- RSVP (Going / Interested) and bookmark events
- View upcoming RSVPs and trending events on the home dashboard
- Real-time spot availability tracking
- In-app chat and community announcements

**For Organizers**
- Post new events with title, description, category, location, date, and cover image
- Edit and delete your own listings
- View RSVP summary (Going, Interested, Spots remaining)
- Organizer-specific dashboard view

**General**
- Student / Organizer role selection at login and sign-up
- Light and dark theme with a single toggle
- Persistent state (RSVPs, bookmarks, posted events) via `shared_preferences`
- Smooth animations, responsive layout, and custom bottom nav with FAB

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x / Dart |
| Fonts | Google Fonts (Open Sans) |
| State | InheritedWidget (UserSession, RsvpState, EventFeedState) |
| Persistence | shared_preferences |
| Image picker | image_picker |
| Platforms | Android, iOS, Web, macOS, Linux, Windows |

---

## Project Structure

```
lib/
├── core/
│   ├── state/          # App-wide state (UserSession, RsvpState, EventFeedState, PersistenceService)
│   └── theme/          # AppColors, AppTheme
└── features/
    ├── auth/           # Splash, Onboarding, Login, Signup screens
    ├── home/           # Home dashboard
    ├── feed/           # Event feed, Event detail, Post event
    ├── chat/           # Chat list, Chat screen, Announcements
    ├── notifications/  # Notifications screen
    ├── profile/        # Profile screen
    └── shell/          # MainShell (bottom nav + FAB wrapper)
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.x
- Dart SDK `^3.11.5`

### Run the app

```bash
flutter pub get
flutter run
```

### Build for release

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## Environment

No API keys or environment variables are required. The app uses mock data defined in `lib/features/feed/data/mock_events.dart` and `lib/features/chat/data/mock_messages.dart`.

---

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/your-feature`
3. Commit your changes: `git commit -m "feat: add your feature"`
4. Push and open a Pull Request

---

## License

This project is private and intended for use within the ALU community.
