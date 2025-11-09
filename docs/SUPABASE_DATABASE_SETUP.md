# Supabase Database Setup Guide

## Overview
Your EcoGuard app is configured to connect to Supabase at:
```
https://tlawzidglriindqvhayo.supabase.co
```

This guide will help you set up the database tables if they don't exist yet.

---

## Step 1: Check if Tables Exist

1. **Login to Supabase Dashboard**
   - Go to https://supabase.com
   - Login with your account
   - Select your EcoGuard project

2. **Check Table Editor**
   - Click on **"Table Editor"** in the left sidebar
   - Look for these tables:
     - `profiles`
     - `trees`
     - `ewaste_items`
     - `carbon_footprints`
     - `activities`
     - `achievements`
     - `user_achievements`

**If these tables exist:** ✅ You're all set! Your database is ready.

**If tables DON'T exist:** ⚠️ Follow Step 2 below.

---

## Step 2: Create Database Tables (If Needed)

### Option A: Using SQL Editor (Recommended)

1. **Open SQL Editor**
   - In Supabase dashboard, click **"SQL Editor"** in the left sidebar
   - Click **"New Query"**

2. **Copy the Schema**
   - Open file: `docs/DATABASE_SCHEMA_EXPORT.sql`
   - Copy ALL the SQL code (442 lines)

3. **Run the Schema**
   - Paste the SQL code into the SQL Editor
   - Click **"Run"** button
   - Wait for completion (should take 5-10 seconds)

4. **Verify**
   - Go back to **"Table Editor"**
   - You should now see all the tables listed
   - Click on each table to verify structure

### Option B: Create Tables Manually

If you prefer to create tables one by one:

#### 1. Create `profiles` table
```sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR UNIQUE NOT NULL,
  display_name VARCHAR NOT NULL,
  avatar_url TEXT,
  eco_points INTEGER DEFAULT 0,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  trees_planted INTEGER DEFAULT 0,
  items_recycled INTEGER DEFAULT 0,
  games_played INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
```

#### 2. Create `trees` table
```sql
CREATE TABLE trees (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  planted_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  species_id VARCHAR NOT NULL,
  species_name VARCHAR NOT NULL,
  common_name VARCHAR NOT NULL,
  scientific_name VARCHAR,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  planted_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  image_url TEXT,
  description TEXT,
  estimated_carbon_offset DECIMAL(10, 2),
  status VARCHAR DEFAULT 'planted',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE trees ENABLE ROW LEVEL SECURITY;
```

#### 3. Create `ewaste_items` table
```sql
CREATE TABLE ewaste_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR NOT NULL,
  description TEXT,
  category VARCHAR NOT NULL,
  image_url TEXT,
  disposal_instructions TEXT[],
  recycling_tips TEXT[],
  hazardous_materials TEXT[],
  is_hazardous BOOLEAN DEFAULT FALSE,
  eco_points_value INTEGER DEFAULT 10,
  carbon_footprint_kg DECIMAL(10, 2),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE ewaste_items ENABLE ROW LEVEL SECURITY;
```

**Note:** For complete setup, use Option A with the full SQL file.

---

## Step 3: Add Sample Data (Optional but Recommended)

After creating tables, add some sample data to test:

### Sample E-waste Items
```sql
INSERT INTO ewaste_items (name, category, description, disposal_instructions, eco_points_value) 
VALUES
  ('iPhone', 'phones', 'Smartphone device', ARRAY['Remove battery', 'Take to authorized recycler'], 50),
  ('Laptop', 'computers', 'Portable computer', ARRAY['Backup data', 'Take to e-waste center'], 100),
  ('LED TV', 'appliances', 'Television display', ARRAY['Contact manufacturer', 'Schedule pickup'], 150),
  ('AA Batteries', 'batteries', 'Alkaline batteries', ARRAY['Do not throw in trash', 'Take to battery collection'], 10);
```

---

## Step 4: Test the Connection

1. **Run the App**
   - Install the APK on your device/emulator
   - Open the app

2. **Try to Login/Signup**
   - If you can create an account, the `profiles` table is working

3. **Test Features**
   - Try planting a tree
   - Try browsing e-waste items
   - Check if data is saved

4. **Verify in Supabase**
   - Go back to Supabase Table Editor
   - Check if new data appears in the tables

---

## Troubleshooting

### Error: "relation does not exist"
**Problem:** Tables haven't been created yet
**Solution:** Run the SQL schema file (Step 2)

### Error: "permission denied"
**Problem:** Row Level Security is blocking access
**Solution:** Check RLS policies in the SQL schema

### Error: "Invalid API key"
**Problem:** Wrong Supabase credentials
**Solution:** Verify the URL and API key in `lib/core/config/app_config.dart`

### Can't see data in tables
**Problem:** RLS policies restrict viewing
**Solution:** 
- Check if you're logged in
- RLS policies only show users their own data
- Use Supabase dashboard as admin to see all data

---

## Database Schema Summary

### Tables Created:
1. **profiles** - User accounts and stats
2. **trees** - Tree planting records
3. **ewaste_items** - E-waste catalog
4. **user_ewaste_recycled** - User recycling history
5. **carbon_footprints** - Carbon calculations
6. **activities** - Activity logging
7. **achievements** - Achievement definitions
8. **user_achievements** - User achievements

### Security Features:
- Row Level Security (RLS) on all tables
- JWT authentication
- User data isolation
- Secure API access

### Performance Features:
- Database indexes for fast queries
- Materialized view for leaderboard
- Optimized foreign key relationships

---

## For Your Professor

### To Demonstrate the Database:

1. **Show Supabase Dashboard**
   - Login and show the project
   - Navigate to Table Editor

2. **Show Database Tables**
   - Display each table structure
   - Show sample data

3. **Show the SQL File**
   - Open `docs/DATABASE_SCHEMA_EXPORT.sql`
   - Explain: "This is the complete database schema that creates all tables"

4. **Explain the Connection**
   - Show `lib/core/config/app_config.dart`
   - Point to the Supabase URL and initialization code
   - Explain: "The app connects to this Supabase backend via REST API"

5. **Live Demo**
   - Plant a tree in the app
   - Refresh the `trees` table in Supabase
   - Show the new entry appearing

---

## Quick Commands Reference

### Run Full Schema
```sql
-- Copy and paste entire content from docs/DATABASE_SCHEMA_EXPORT.sql
```

### Check if Tables Exist
```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';
```

### View All Data in a Table
```sql
SELECT * FROM profiles;
SELECT * FROM trees;
SELECT * FROM ewaste_items;
```

### Drop All Tables (Use with Caution!)
```sql
DROP TABLE IF EXISTS user_achievements CASCADE;
DROP TABLE IF EXISTS achievements CASCADE;
DROP TABLE IF EXISTS activities CASCADE;
DROP TABLE IF EXISTS carbon_footprints CASCADE;
DROP TABLE IF EXISTS user_ewaste_recycled CASCADE;
DROP TABLE IF EXISTS ewaste_items CASCADE;
DROP TABLE IF EXISTS trees CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;
```

---

## Connection Details

**Supabase Project URL:**
```
https://tlawzidglriindqvhayo.supabase.co
```

**Database Type:** PostgreSQL 15+

**Authentication:** Supabase Auth with JWT

**API Access:** REST API + Real-time subscriptions

**Code Location:** `lib/services/data/supabase_data_service.dart`

---

## Next Steps

1. ✅ Check if tables exist in Supabase
2. ✅ If not, run the SQL schema file
3. ✅ Add sample data
4. ✅ Test the app
5. ✅ Verify data appears in Supabase dashboard
6. ✅ Ready for demonstration!

---

**Your database is now ready for your final project submission!** 🚀
