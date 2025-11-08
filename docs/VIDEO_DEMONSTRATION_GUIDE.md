# Video Demonstration Guide - Backend Focus

## Overview
This guide explains what to show in your 5-10 minute video demonstration, specifically focusing on "how your backend works" as required by your professor.

---

## Video Structure (Suggested Timeline)

### Part 1: App Demonstration (3-4 minutes)
Show the mobile app's main features in action

### Part 2: Backend Demonstration (4-5 minutes) ⭐ **CRITICAL**
Show how the backend actually works

### Part 3: Integration & Summary (1-2 minutes)
Show how frontend and backend work together

---

## Part 1: Mobile App Features (3-4 minutes)

### What to Show:
1. **App Launch & Onboarding**
   - Open the APK on your Android device/emulator
   - Show splash screen → welcome screen → dashboard
   
2. **Core Features** (show 3-4 main features)
   - **Tree Planting Hub**: Log a tree planting activity
   - **E-waste Management**: Browse e-waste items, use scanner
   - **Carbon Calculator**: Calculate carbon footprint
   - **Gamification**: Show points, leaderboard, profile

3. **Data Entry**
   - Add some data (plant a tree, recycle item, etc.)
   - Show that points are awarded
   - Navigate between screens

---

## Part 2: Backend Demonstration (4-5 minutes) ⭐

This is the MOST IMPORTANT part your professor wants to see!

### A. Show Supabase Dashboard (2 minutes)

#### 1. Login to Supabase
- Go to https://supabase.com
- Login to your project dashboard
- Show your project name: "EcoGuard Backend"

#### 2. Show Database Tables
Navigate to **Table Editor** and display these tables:

**Essential Tables to Show:**

**`profiles` table**
- Purpose: Stores user profile information
- Show columns: `id`, `email`, `display_name`, `avatar_url`, `eco_points`, `current_streak`
- Show some sample data rows
- Explain: "This stores all user account information and gamification stats"

**`trees` table**
- Purpose: Stores tree planting records
- Show columns: `id`, `user_id`, `species_name`, `planted_at`, `latitude`, `longitude`
- Show sample tree records
- Explain: "Every tree planted in the app is saved here with location data"

**`ewaste_items` table**
- Purpose: E-waste catalog
- Show columns: `id`, `name`, `category`, `disposal_instructions`, `eco_points_value`
- Show the e-waste items
- Explain: "This is our e-waste catalog that users can browse and scan"

**`carbon_footprints` table**
- Purpose: Stores carbon calculation results
- Show columns: `id`, `user_id`, `total_annual_emissions`, `calculated_at`
- Explain: "Stores user's carbon footprint calculations for tracking over time"

**`activities` table** (if exists)
- Purpose: Activity log for points and history
- Show recent activities
- Explain: "Logs every eco-action users take for points and history"

#### 3. Show Authentication
Navigate to **Authentication** section:
- Show user list
- Explain: "Supabase handles user registration, login, and JWT tokens automatically"
- Show any test accounts you've created

#### 4. Show Database Schema (Optional but impressive!)
Navigate to **Database** → **Schema Visualizer** or **SQL Editor**:
- Show the relationships between tables
- Mention foreign keys: `user_id` connects to `profiles.id`

### B. Demonstrate Live Data Flow (1-2 minutes)

**This is CRUCIAL - show the backend actually working!**

1. **Open Supabase Dashboard and APK side-by-side**
   - Split screen: Supabase on left, running app on right
   
2. **Perform an action in the app:**
   - Example: Plant a tree in the app
   - Enter tree details and submit
   
3. **Refresh Supabase table:**
   - Go to `trees` table in Supabase
   - Click refresh button
   - **Show the new tree appearing in the database!**
   - Point out: "See, the data we just entered in the app is now in the backend database"

4. **Show another example:**
   - Calculate carbon footprint in app
   - Refresh `carbon_footprints` table
   - Show the new record

### C. Explain Backend Architecture (1 minute)

Show your `SYSTEM_ARCHITECTURE.md` file briefly or explain verbally:

**Key Points to Mention:**

1. **Database Type**
   - "We use Supabase, which is built on PostgreSQL, a powerful relational database"

2. **Connection**
   - "The Flutter app connects to Supabase using REST APIs and real-time subscriptions"
   - Show the code file: `lib/services/data/supabase_data_service.dart`

3. **Data Flow**
   ```
   User Action → Flutter App → Supabase API → PostgreSQL Database → Response → UI Update
   ```

4. **Security**
   - "Uses JWT token authentication"
   - "Row Level Security (RLS) ensures users only see their own data"
   - "API keys are stored in environment variables, not hardcoded"

5. **Local + Remote Storage**
   - "App uses Hive for local storage (offline capability)"
   - "Supabase for remote storage (data persistence and sync)"

---

## Part 3: Integration & Summary (1-2 minutes)

### What to Cover:

1. **Show the Connection Code**
   - Open `lib/core/config/app_config.dart` or `lib/main.dart`
   - Point to Supabase initialization code:
   ```dart
   await Supabase.initialize(
     url: supabaseUrl,
     anonKey: supabaseAnonKey,
   );
   ```

2. **Show API Service**
   - Open `lib/services/data/supabase_data_service.dart`
   - Show example function:
   ```dart
   Future<List<TreeModel>> getUserTrees() async {
     final response = await _client
         .from('trees')
         .select()
         .eq('planted_by', _client.auth.currentUser?.id);
     return (response as List).map((e) => TreeModel.fromJson(e)).toList();
   }
   ```
   - Explain: "This function fetches trees from backend and converts to app objects"

3. **Summarize Tech Stack**
   - **Frontend**: Flutter (Dart) - mobile app
   - **Backend**: Supabase (PostgreSQL) - database + authentication
   - **State Management**: Riverpod - manages app state
   - **Local Storage**: Hive - offline support

---

## Recording Tips

### Tools to Use:
- **Screen Recording**: 
  - Windows: Xbox Game Bar (Win + G) or OBS Studio
  - Phone Screen: Connect via USB and use scrcpy or Android Studio
- **Split Screen**: Show Supabase + App simultaneously
- **Zoom in on important parts** (Ctrl + Mouse Wheel on Windows)

### What Professors Look For:

✅ **Evidence the backend actually exists**
- Show actual Supabase dashboard, not just the app

✅ **Understanding of data flow**
- Demonstrate you understand how data moves from app → backend → storage

✅ **Live demonstration**
- Prove the app and backend are connected by making changes

✅ **Professional presentation**
- Clear narration, good audio, organized flow

### Common Mistakes to Avoid:

❌ Only showing the app (not the backend)
❌ Not explaining what the backend does
❌ Not showing actual database tables
❌ No live demonstration of data being saved
❌ Too fast or unclear narration

---

## Script Template

Here's a sample script you can follow:

### Introduction (30 seconds)
> "Hello, this is [Your Name] presenting the EcoGuard mobile application. This is a sustainability-focused mobile app built with Flutter and Supabase. In this video, I'll demonstrate the app's features and show you how our backend system works."

### App Demo (3 minutes)
> "First, let me show you the main features of the app..."
> [Show 3-4 features]

### Backend Demo (4 minutes)
> "Now, the most important part - the backend system. I'm logging into our Supabase dashboard where our PostgreSQL database is hosted..."

> "Here you can see our database schema with several tables. The 'profiles' table stores user information including their eco-points and streak data. The 'trees' table records every tree planted with GPS coordinates..."

> "Now let me demonstrate live data flow. On the left, I have the Supabase dashboard open. On the right, I have our app running. Watch what happens when I plant a tree in the app..."

> "I'll enter the tree details... submit... and now let's refresh the database table... as you can see, the new tree entry has appeared in our backend database with all the details I just entered."

> "This demonstrates that our app is successfully communicating with the backend, saving data persistently, and maintaining data integrity."

### Technical Explanation (1 minute)
> "Our architecture uses Flutter for the mobile frontend, which connects to Supabase via REST APIs. Supabase provides PostgreSQL database, authentication with JWT tokens, and real-time capabilities..."

### Conclusion (30 seconds)
> "In summary, EcoGuard successfully integrates a Flutter mobile app with a robust Supabase backend, demonstrating full-stack development capabilities with proper data persistence, authentication, and real-time synchronization. Thank you for watching."

---

## Checklist Before Recording

- [ ] Supabase dashboard is accessible and logged in
- [ ] APK is installed on device/emulator and working
- [ ] Database has sample data in all main tables
- [ ] Screen recording software is tested and ready
- [ ] Audio is clear (test your microphone)
- [ ] Rehearse the flow at least once
- [ ] Prepare split-screen setup (Supabase + App)
- [ ] Close unnecessary apps/tabs
- [ ] Disable notifications during recording
- [ ] Check video length: 5-10 minutes

---

## Upload Instructions

After recording:

1. **Edit the video** (optional but recommended):
   - Cut out mistakes or long pauses
   - Add text overlays for clarity (e.g., "Backend Database", "Live Data Entry")
   - Ensure 5-10 minute length

2. **Upload to Google Drive**:
   - Go to https://drive.google.com
   - Upload video file
   - Right-click → Share → "Anyone with the link can view"
   - Copy the shareable link
   - Test the link in incognito mode to ensure it works

3. **Name the file clearly**:
   - Example: `EcoGuard_App_Demo_Backend_[YourName]_2025.mp4`

---

## Need Help?

If you need help with:
- Setting up screen recording
- Creating database documentation
- Generating SQL schema export
- Writing the script

Just ask! I'm here to help you create a professional demonstration video.
