# Resonance Mobile

A Flutter mobile application for the **Resonance Project** — a music-based social matching platform. Users can discover music, swipe on tracks, match with others who share similar music taste, and chat in real time.

## Features

- **Authentication** — Register, login, logout with JWT-based session management
- **Music Discovery** — Browse and play tracks via integrated audio player
- **Swipe & Match** — Swipe on tracks to express your music taste and match with like-minded users
- **Chat** — Real-time WebSocket-based chat with matched users
- **Playlists** — Create and manage personal playlists
- **User Profiles** — View and edit your profile

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile | Flutter (Dart) |
| Backend | Go (Gin) — Microservice Architecture |
| API Gateway | Go reverse proxy on port `8000` |
| Message Broker | RabbitMQ |
| Containerization | Docker & Docker Compose |

---

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.10.1)
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with Flutter extension
- Android Emulator or a physical Android device
- [Docker](https://docs.docker.com/get-docker/) & [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/)

---

## Getting Started

### 1. Clone Both Repositories

```bash
# Clone the mobile app
git clone https://github.com/KwnxpN/Resonance_Mobile.git
cd Resonance_Mobile
git checkout dev

# Clone the backend API (in a separate directory)
cd ..
git clone https://github.com/ExxiDauS/Resonance-Not-MegaService.git
cd Resonance-Not-MegaService
git checkout dev
```

### 2. Set Up the Backend API

The backend uses a microservice architecture with 6 domain services, an API gateway, and RabbitMQ — all orchestrated via Docker Compose.

#### 2.1 Configure Environment Variables

Each domain service requires its own `.env` file. Copy the example files and fill in your values:

```bash
# Inside the Resonance-Not-MegaService directory

# Auth Domain
cp auth-domain/.env.example auth-domain/.env

# User Domain
cp user-domain/.env.example user-domain/.env

# Music Domain
cp music-domain/.env.example music-domain/.env

# Chat Domain
cp chat-domain/.env.example chat-domain/.env

# Interaction Domain
cp interaction-domain/.env.example interaction-domain/.env

# Match Domain
cp match-domain/.env.example match-domain/.env
```

Edit each `.env` file with your actual credentials:

**auth-domain/.env**
```env
AUTH_DOMAIN_URL=<your-database-url>
AUTH_DOMAIN_USERNAME=<your-db-username>
AUTH_DOMAIN_PASSWORD=<your-db-password>
AUTH_DOMAIN_JWT_SECRET=<your-jwt-secret>
PORT=8080
RABBITMQ_HOST=rabbitmq
RABBITMQ_PORT=5672
RABBITMQ_USER=guest
RABBITMQ_PASSWORD=guest
```

**user-domain/.env**
```env
USER_DOMAIN_URL=<your-database-url>
USER_DOMAIN_USERNAME=<your-db-username>
USER_DOMAIN_PASSWORD=<your-db-password>
USER_DOMAIN_JWT_SECRET=<your-jwt-secret>
PORT=8081
RABBITMQ_HOST=rabbitmq
RABBITMQ_PORT=5672
RABBITMQ_USER=guest
RABBITMQ_PASSWORD=guest
```

**music-domain/.env**
```env
SPOTIFY_CLIENT_ID=<your-spotify-client-id>
SPOTIFY_CLIENT_SECRET=<your-spotify-client-secret>
SOUNDCLOUD_CLIENT_ID=<your-soundcloud-client-id>
SOUNDCLOUD_CLIENT_SECRET=<your-soundcloud-client-secret>
DATABASE_URL=<your-database-url>
PORT=8083
```

**chat-domain/.env**
```env
REDIS_ADDRESS=<your-redis-address>
REDIS_USERNAME=<your-redis-username>
REDIS_PASSWORD=<your-redis-password>
PORT=8082
```

**interaction-domain/.env**
```env
INTERACTION_DOMAIN_URL=<your-database-url>
INTERACTION_DOMAIN_USERNAME=<your-db-username>
INTERACTION_DOMAIN_PASSWORD=<your-db-password>
PORT=8084
RABBITMQ_HOST=rabbitmq
RABBITMQ_PORT=5672
RABBITMQ_USER=guest
RABBITMQ_PASSWORD=guest
```

**match-domain/.env**
```env
# Fill in based on match-domain/.env.example
PORT=8085
RABBITMQ_HOST=rabbitmq
RABBITMQ_PORT=5672
RABBITMQ_USER=guest
RABBITMQ_PASSWORD=guest
```

> **Note:** When running inside Docker Compose, set `RABBITMQ_HOST=rabbitmq` (the Docker service name) instead of `localhost`.

#### 2.2 Start the Backend with Docker Compose

```bash
# Inside the Resonance-Not-MegaService directory
docker compose up --build
```

This will start all services:

| Service | Container | Internal Port |
|---|---|---|
| RabbitMQ | `resonance-rabbitmq` | 5672 / 15672 (management UI) |
| Auth Domain | `resonance-auth` | 8080 |
| User Domain | `resonance-user` | 8081 |
| Chat Domain | `resonance-chat` | 8082 |
| Music Domain | `resonance-music` | 8083 |
| Interaction Domain | `resonance-interaction` | 8084 |
| Match Domain | `resonance-match` | 8085 |
| **API Gateway** | `resonance-gateway` | **8000** (exposed to host) |

The API Gateway is exposed on **port 8000** and routes requests to the appropriate domain service:

| Route | Domain Service |
|---|---|
| `/api/auth/*` | Auth Domain |
| `/api/users/*` | User Domain |
| `/api/music/*` | Music Domain |
| `/api/interactions/*` | Interaction Domain |
| `/api/matches/*` | Match Domain |
| `/ws/*` | Chat Domain (WebSocket) |

#### 2.3 Verify the Backend is Running

```bash
curl http://localhost:8000/health
```

Expected response:
```json
{"service":"api-gateway","status":"ok"}
```

You can also access the RabbitMQ Management UI at `http://localhost:15672` (default credentials: `guest` / `guest`).

---

### 3. Set Up the Flutter Mobile App

#### 3.1 Install Dependencies

```bash
# Inside the Resonance_Mobile directory
flutter pub get
```

#### 3.2 Configure the API Base URL

The app connects to the backend API Gateway at `http://10.0.2.2:8000` by default. The address `10.0.2.2` is the Android emulator's alias for the host machine's `localhost`.

The API configuration is located in the Dio client files under `lib/core/network/`:

| File | Base URL |
|---|---|
| `auth_dio.dart` | `http://10.0.2.2:8000/api/auth` |
| `music_dio.dart` | `http://10.0.2.2:8000/api/music` |
| `user_dio.dart` | `http://10.0.2.2:8000/api/users` |
| `interaction_dio.dart` | `http://10.0.2.2:8000/api/interactions` |
| `match_dio.dart` | `http://10.0.2.2:8000/api/matches` |

**If running on a physical device**, replace `10.0.2.2` with your computer's local IP address (e.g., `192.168.x.x`) in each of the files above.

#### 3.3 Run the App

```bash
# Start an Android emulator first, then:
flutter run
```

---

## Running Everything Together (Quick Start)

```bash
# Terminal 1 — Start the backend
cd Resonance-Not-MegaService
docker compose up --build

# Terminal 2 — Run the mobile app (after backend is healthy)
cd Resonance_Mobile
flutter pub get
flutter run
```

---

## Stopping the Backend

```bash
# Stop all containers
docker compose down

# Stop and remove volumes (clean reset)
docker compose down -v
```

---

## Project Structure (Mobile)

```
lib/
├── main.dart                  # App entry point
├── core/
│   ├── di/                    # Dependency injection (ServiceLocator)
│   ├── network/               # Dio HTTP clients per domain
│   └── player/                # Audio player controller
├── features/
│   ├── auth/                  # Authentication (login, register, session)
│   ├── interaction/           # User interactions (playlists, swipes)
│   ├── match/                 # Match logic
│   ├── musics/                # Music tracks API
│   ├── playlists/             # Playlist management
│   ├── swipes/                # Swipe actions
│   └── users/                 # User profiles
├── models/                    # Data models
├── screens/                   # UI screens
├── themes/                    # App theme, colors, text styles
├── utils/                     # Utility functions
└── widgets/                   # Reusable UI widgets
```

---

## Troubleshooting

| Issue | Solution |
|---|---|
| `Connection refused` on emulator | Ensure backend is running and use `10.0.2.2` (not `localhost`) as the API host |
| `Connection refused` on physical device | Replace `10.0.2.2` with your machine's local IP in `lib/core/network/*.dart` |
| Docker build fails | Ensure all `.env` files are created for every domain |
| RabbitMQ not ready | Services depend on RabbitMQ health check — wait for it to become healthy |
| `Unauthorized` / 401 errors | Check that `AUTH_DOMAIN_JWT_SECRET` and `USER_DOMAIN_JWT_SECRET` match |

---

## License

This project is licensed under the [MIT License](LICENSE).
