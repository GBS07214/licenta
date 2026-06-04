# BabyTracker 👶

Aplicație Flutter pentru tracking activități bebeluș cu AI chat integrat, dezvoltată pentru licență.

## 📱 Funcționalități

- ✅ **Autentificare** - Login și register cu Firebase Authentication
- 👶 **Profil bebeluș** - Nume, dată naștere, vârstă automată
- ⏰ **Tracking activități**:
  - 😴 Somn (cronometru start/stop)
  - 🍼 Alăptat (stânga/dreapta + durată)
  - 💩 Scutec (ud/murdar/ambele)
- 📊 **Statistici** - Grafice interactive (ultimele 7 zile)
- 💬 **Chat AI** - Asistent virtual specializat pe sfaturi bebeluși (Gemini)
- 💝 **Sfat zilnic** - Mesaje motivaționale pentru părinți
- 🎨 **Teme** - Pastel albastru (băieți) și roz (fetițe)

## 🛠️ Tehnologii

- **Flutter** 3.0+
- **Firebase** (Auth + Firestore)
- **Google Gemini AI** (chat inteligent)
- **fl_chart** (grafice)
- **Provider** (state management)

## 📦 Instalare și Setup

### 1. Instalează Flutter

```bash
# Verifică instalarea
flutter doctor
```

👉 [Instalare Flutter](https://docs.flutter.dev/get-started/install)

### 2. Clone repository-ul

```bash
git clone https://github.com/GBS07214/licenta.git
cd licenta
```

### 3. Instalează dependențele

```bash
flutter pub get
```

### 4. Configurare Firebase

#### 4.1. Creează proiect Firebase

1. Mergi la [Firebase Console](https://console.firebase.google.com/)
2. Creează un proiect nou
3. Activează **Authentication** (Email/Password)
4. Creează o bază de date **Firestore**

#### 4.2. Descarcă google-services.json

1. În Firebase Console → Project Settings → Your apps
2. Adaugă aplicație Android
3. Package name: `com.licenta.babytracker`
4. Descarcă `google-services.json`
5. **Plasează fișierul în:** `android/app/google-services.json`

#### 4.3. Configurare Android

În `android/build.gradle` (project-level), adaugă:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

În `android/app/build.gradle`, adaugă la final:

```gradle
apply plugin: 'com.google.gms.google-services'
```

### 5. Configurare Gemini AI (Chat)

1. Obține API key gratuit: [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Deschide `lib/services/gemini_service.dart`
3. Înlocuiește:

```dart
static const String _apiKey = 'YOUR_GEMINI_API_KEY_HERE';
```

cu:

```dart
static const String _apiKey = 'API_KEY_TAU_AICI';
```

### 6. Activează Firebase în main.dart

Decomentează linia din `lib/main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(); // ← Decomentează această linie
  
  runApp(const MyApp());
}
```

### 7. Rulează aplicația

```bash
flutter run
```

## 📂 Structura proiectului

```
lib/
├── main.dart                      # Entry point
├── models/
│   ├── baby_profile.dart          # Model profil bebeluș
│   ├── activity.dart              # Model activități
│   └── chat_message.dart          # Model mesaje chat
├── services/
│   ├── firebase_service.dart      # Logică Firebase
│   ├── gemini_service.dart        # Integrare AI chat
│   └── theme_service.dart         # Management teme
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart      # Ecran login
│   │   └── register_screen.dart   # Ecran register
│   ├── home/
│   │   └── dashboard_screen.dart  # Dashboard principal
│   ├── tracking/
│   │   ├── sleep_screen.dart      # Tracking somn
│   │   ├── feeding_screen.dart    # Tracking alăptat
│   │   └── diaper_screen.dart     # Tracking scutec
│   ├── stats/
│   │   └── statistics_screen.dart # Statistici + grafice
│   ├── chat/
│   │   └── ai_chat_screen.dart    # Chat AI
│   └── settings/
│       └── settings_screen.dart   # Setări
└── widgets/
    ├── activity_button.dart       # Buton activitate
    └── daily_tip_card.dart        # Card sfat zilnic
```

## 🎨 Teme

- **Albastru** (default): Pastel #A7C7E7
- **Roz** (opțional): Pastel #FFB6C1

Schimbă tema din **Setări** → Switch "Tema roz (fetițe)"

## 🔥 Firebase Firestore - Structura bazei de date

```
users/
  {userId}/
    profile/
      baby: { babyName, babyBirthDate, theme }
    activities/
      {activityId}: { type, timestamp, details }
```

**Tipuri activități:**
- `sleep` - `{ startTime, endTime, duration }`
- `feeding` - `{ side, duration, timestamp }`
- `diaper` - `{ type, timestamp }`

## 💡 Sfaturi

### Pentru dezvoltare

```bash
# Hot reload
r

# Hot restart
R

# Cleanup
flutter clean
flutter pub get
```

### Pentru build production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release
```

## ⚠️ Troubleshooting

### Eroare Firebase

- Verifică dacă `google-services.json` este în `android/app/`
- Asigură-te că ai activat Authentication și Firestore în Firebase Console

### Eroare Gemini API

- Verifică dacă API key-ul este valid
- Asigură-te că ai acces la internet

### Eroare build

```bash
flutter clean
flutter pub get
flutter run
```

## 📝 Pentru licență

### Documentație recomandată

- Arhitectură aplicației (Provider + Firebase)
- Diagrame UML (clase, secvență)
- Screenshots funcționalități
- Rezultate testare (unit tests, widget tests)

### Funcționalități demonstrabile

1. ✅ Autentificare utilizator
2. ✅ CRUD activități (Create, Read)
3. ✅ Vizualizare grafice statistici
4. ✅ Integrare AI (Gemini)
5. ✅ Persistență date (Firestore)
6. ✅ State management (Provider)
7. ✅ Responsive UI

## 🚀 Next Steps (opțional pentru licență)

- [ ] Notificări push (reminder alăptare)
- [ ] Export rapoarte PDF
- [ ] Multipli bebeluși
- [ ] Dark mode
- [ ] Localizare multiple limbi
- [ ] Backup/Restore date

## 📄 Licență

Acest proiect este dezvoltat pentru scopuri educaționale (licență).

## 👨‍💻 Autor

Dezvoltat de **GBS07214** - 2026

---

**Pentru asistență tehnică sau întrebări despre cod, consultă documentația Flutter și Firebase:**
- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Gemini AI Documentation](https://ai.google.dev/docs)
