[README.md](https://github.com/user-attachments/files/28872131/README.md)
# 🎓 Student Manager

A Flutter mobile app for managing university students, built with **Flutter BLoC** and **SQLite**.

---

## ✨ Features

- **Dashboard** — Live count of enrolled students at a glance
- **Add Students** — Full registration form with department/grade/division selection
- **Search & Browse** — Instant search by name or ID with avatar initials
- **Student Profile** — Detailed view with photo upload (camera or gallery)
- **Edit & Delete** — Full CRUD operations
- **Class Management** — Hierarchical browser: Department → Grade → Division → Courses
- **Course Ratings** — Editable scores per course per year

---

## 🗂️ Project Structure

```
lib/
├── main.dart
└── final/
    ├── theme.dart              # Colors, typography, ThemeData
    ├── admin.dart              # Home screen
    ├── modelStudent.dart       # Student data model
    ├── studentLogic.dart       # BLoC Cubit — all DB operations
    ├── studentState.dart       # BLoC states
    ├── addCourses.dart         # Rating slot initializer
    ├── material/
    │   ├── widgets.dart        # Shared UI components
    │   └── coursesTools.dart   # Course map helpers
    └── screens/
        ├── search_screen.dart
        ├── add_student_screen.dart
        ├── update_student_screen.dart
        ├── student_profile_screen.dart
        ├── student_form.dart
        ├── department_screen.dart
        ├── grade_screen.dart
        ├── division_screen.dart
        └── courses_screen.dart
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ≥ 3.0.0
- Dart ≥ 3.0.0

### Install & Run

```bash
git clone https://github.com/<your-username>/student-manager.git
cd student-manager
flutter pub get
flutter run
```

---

## 📦 Dependencies

| Package | Purpose |
|---|---|
| `flutter_bloc` + `bloc` | State management |
| `sqflite` + `path` | Local SQLite database |
| `image_picker` | Camera & gallery access |

---

## 🐛 Bugs Fixed

1. **`CoursesTools.addCourse`** — was a read expression instead of assignment (`= 0` was missing)
2. **`StudentLogic.updateStudent`** — was appending a new model instead of replacing the existing one
3. **`Search` screen** — was creating a separate `BlocProvider` (separate DB instance) instead of sharing the parent's logic
4. **`updateStudent` navigation** — was doing `3× pop + push(Admin)` which broke the back stack
5. **`addImageFile`** — was modifying a local parameter instead of the class field
6. **SQL injection** — all raw string interpolation replaced with parameterized queries (`?` placeholders)

---

## 🎨 Design

Color palette: deep teal (`#006B6B`) primary, amber accent (`#E8A838`), light surface (`#F7F9F9`).  
Typography: Material 3 defaults with weight hierarchy (800 hero → 700 headings → 600 labels → 500 body).

---

## 📄 License

MIT
