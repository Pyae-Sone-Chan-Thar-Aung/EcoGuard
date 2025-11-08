# EcoGuard Backend - Simple Explanation

## What is the Backend?

The **backend** is the server-side system that stores and manages your app's data. Think of it as the "brain" behind your mobile app.

---

## Your Backend Technology: Supabase

**Supabase** = Backend-as-a-Service (BaaS)
- Built on **PostgreSQL** (professional database system)
- Provides: Database, Authentication, APIs, Real-time features
- Similar to: Firebase, but open-source and uses SQL

**Where it's hosted:** https://supabase.com (cloud-based)

---

## How It Works

```
[Mobile App] ←→ [Internet/WiFi] ←→ [Supabase Backend] ←→ [PostgreSQL Database]
   (Flutter)                          (API + Auth)           (Data Storage)
```

### Step-by-Step Flow:

1. **User plants a tree in the app**
2. **App sends data** through Supabase API
3. **Backend authenticates** the user (checks login)
4. **Database saves** the tree information
5. **Confirmation sent back** to the app
6. **App updates UI** showing the new tree

---

## Database Structure (Tables)

Your backend has these main tables:

### 1. **`profiles`** table
**Purpose:** Stores user account information

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Unique user ID |
| email | Text | User's email |
| display_name | Text | User's name |
| eco_points | Number | Total points earned |
| current_streak | Number | Daily login streak |
| trees_planted | Number | Total trees planted |

**Example data:**
```
id: a1b2c3d4...
email: john@example.com
display_name: John Doe
eco_points: 500
current_streak: 7
trees_planted: 5
```

---

### 2. **`trees`** table
**Purpose:** Records every tree planted by users

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Unique tree ID |
| user_id | UUID | Who planted it |
| species_name | Text | Type of tree |
| latitude | Number | GPS location (lat) |
| longitude | Number | GPS location (long) |
| planted_at | Timestamp | When planted |

**Example data:**
```
id: x9y8z7w6...
user_id: a1b2c3d4...
species_name: Narra
latitude: 14.5995
longitude: 120.9842
planted_at: 2025-11-08 14:30:00
```

---

### 3. **`ewaste_items`** table
**Purpose:** Catalog of recyclable e-waste items

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Item ID |
| name | Text | Item name |
| category | Text | phones/computers/batteries |
| disposal_instructions | Array | How to recycle |
| eco_points_value | Number | Points awarded |

**Example data:**
```
id: p9o8i7u6...
name: iPhone
category: phones
disposal_instructions: ["Remove battery", "Take to recycler"]
eco_points_value: 50
```

---

### 4. **`carbon_footprints`** table
**Purpose:** Stores carbon calculation results

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Calculation ID |
| user_id | UUID | User who calculated |
| total_annual_emissions | Number | Total CO2 (kg/year) |
| calculated_at | Timestamp | When calculated |

---

### 5. **`activities`** table
**Purpose:** Logs all user actions for points and history

| Column | Type | Description |
|--------|------|-------------|
| id | UUID | Activity ID |
| user_id | UUID | Who did it |
| activity_type | Text | tree_planting/recycling/etc |
| title | Text | Activity name |
| points_earned | Number | Points awarded |
| created_at | Timestamp | When it happened |

---

## Key Backend Features

### 🔐 Authentication
- **What:** User login/signup system
- **How:** JWT (JSON Web Tokens)
- **Security:** Passwords are encrypted, tokens expire
- **Code location:** `lib/core/config/app_config.dart`

### 💾 Data Storage
- **Local Storage (Hive):** Saves data on phone for offline use
- **Remote Storage (Supabase):** Permanent storage in cloud
- **Sync:** App uploads local data when internet is available

### 🔒 Row Level Security (RLS)
- **What:** Security rules in database
- **Purpose:** Users can only see/edit their own data
- **Example:** You can only see trees YOU planted, not others' trees

### 📡 API Communication
- **REST API:** App talks to backend using HTTP requests
- **Real-time:** Can get live updates when data changes
- **Code location:** `lib/services/data/supabase_data_service.dart`

---

## Code Example: How App Connects to Backend

### 1. Initialize Connection (in `main.dart`):
```dart
await Supabase.initialize(
  url: 'https://your-project.supabase.co',
  anonKey: 'your-api-key-here',
);
```

### 2. Fetch Data (in `supabase_data_service.dart`):
```dart
Future<List<TreeModel>> getUserTrees() async {
  final response = await _client
      .from('trees')                    // Table name
      .select()                         // Select all columns
      .eq('planted_by', currentUserId); // Where user_id = current user
  
  return convertToTreeModels(response); // Convert to app objects
}
```

### 3. Save Data:
```dart
Future<void> plantTree(TreeModel tree) async {
  await _client
      .from('trees')
      .insert({
        'species_name': tree.speciesName,
        'latitude': tree.latitude,
        'longitude': tree.longitude,
        'planted_by': currentUserId,
      });
}
```

---

## What to Show Your Professor

### ✅ Must Show:

1. **Supabase Dashboard**
   - Login at supabase.com
   - Show your project dashboard

2. **Database Tables**
   - Click "Table Editor"
   - Show `profiles`, `trees`, `ewaste_items` tables
   - Show actual data rows

3. **Live Data Flow**
   - Open app + Supabase side-by-side
   - Plant a tree in app
   - Refresh database table
   - Show the new tree appearing!

4. **Authentication**
   - Show "Authentication" section
   - Show registered users

5. **Database Schema**
   - Optional: Show schema diagram
   - Mention table relationships (foreign keys)

---

## Backend vs Frontend

| Aspect | Frontend (Flutter App) | Backend (Supabase) |
|--------|----------------------|-------------------|
| **What** | User interface | Data storage & logic |
| **Where** | User's phone | Cloud server |
| **Language** | Dart (Flutter) | SQL (PostgreSQL) |
| **Sees** | Only user's data | All users' data (with security) |
| **Dies when** | App closes | Never (always running) |
| **Data** | Temporary (local cache) | Permanent |

---

## Why You Need Both

**Frontend Only:** ❌
- Data disappears when app closes
- Can't share data between users
- No backup if phone is lost
- Can't do leaderboards or analytics

**With Backend:** ✅
- Data is permanent
- Access from any device
- Multiple users can interact
- Centralized management
- Real-time updates
- Analytics and reporting

---

## Technical Terms Simplified

- **API (Application Programming Interface):** Way for app to talk to backend
- **PostgreSQL:** Professional database system
- **UUID:** Universal unique ID (long random string)
- **JWT:** Secure login token
- **REST:** Standard way to build APIs
- **CRUD:** Create, Read, Update, Delete (basic operations)
- **RLS:** Row Level Security (who can see what)
- **Foreign Key:** Link between tables (user_id connects to profiles.id)

---

## Architecture Diagram

```
┌─────────────────────────────────────────┐
│          ECOGUARD MOBILE APP            │
│               (Flutter)                 │
│                                         │
│  ┌──────────────────────────────────┐  │
│  │   UI Layer (Screens/Widgets)     │  │
│  └──────────────────────────────────┘  │
│                 ↓                       │
│  ┌──────────────────────────────────┐  │
│  │  State Management (Riverpod)     │  │
│  └──────────────────────────────────┘  │
│                 ↓                       │
│  ┌──────────────────────────────────┐  │
│  │  Services (API Calls)            │  │
│  └──────────────────────────────────┘  │
│                 ↓                       │
│  ┌──────────────────────────────────┐  │
│  │  Local Storage (Hive)            │  │
│  └──────────────────────────────────┘  │
└─────────────────┬───────────────────────┘
                  │
                  │ Internet (HTTP/REST API)
                  ↓
┌─────────────────────────────────────────┐
│         SUPABASE BACKEND                │
│       (Cloud-hosted Server)             │
│                                         │
│  ┌──────────────────────────────────┐  │
│  │  Authentication Service          │  │
│  │  (User login/signup)             │  │
│  └──────────────────────────────────┘  │
│                                         │
│  ┌──────────────────────────────────┐  │
│  │  API Layer (REST Endpoints)      │  │
│  └──────────────────────────────────┘  │
│                                         │
│  ┌──────────────────────────────────┐  │
│  │  PostgreSQL Database             │  │
│  │                                  │  │
│  │  • profiles                      │  │
│  │  • trees                         │  │
│  │  • ewaste_items                  │  │
│  │  • carbon_footprints             │  │
│  │  • activities                    │  │
│  └──────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

---

## Summary for Professor

**"EcoGuard uses a modern full-stack architecture:**

- **Frontend:** Flutter mobile app with offline capability
- **Backend:** Supabase (PostgreSQL database + REST API)
- **Authentication:** JWT-based secure login
- **Data Flow:** App → API → Database → Response → UI Update
- **Security:** Row-level security ensures data privacy
- **Storage:** Hybrid local (Hive) + cloud (Supabase) for best UX

**The backend enables:**
- Persistent data storage
- Multi-user support
- Real-time synchronization
- Centralized management
- Scalable architecture
- Professional-grade security

---

## Questions You Might Get Asked

**Q: Why use Supabase instead of building your own backend?**
A: Supabase provides production-ready infrastructure (database, authentication, APIs) so we can focus on building app features rather than server management.

**Q: Where is the data actually stored?**
A: In a PostgreSQL database hosted on Supabase's cloud servers (AWS).

**Q: What happens if there's no internet?**
A: The app uses local storage (Hive) to cache data and work offline. Changes sync when connection returns.

**Q: How do you ensure data security?**
A: Multiple layers: JWT authentication, row-level security policies, encrypted connections (HTTPS), API key management.

**Q: Can you show the actual database?**
A: Yes! [Demo Supabase dashboard with live data]

---

## Files Reference

- **Backend Service:** `lib/services/data/supabase_data_service.dart`
- **Configuration:** `lib/core/config/app_config.dart`
- **Main Init:** `lib/main.dart` (Supabase.initialize)
- **Database Schema:** `docs/DATABASE_SCHEMA_EXPORT.sql`
- **Architecture Docs:** `docs/SYSTEM_ARCHITECTURE.md`

---

**This is everything you need to explain your backend! Good luck! 🚀**
