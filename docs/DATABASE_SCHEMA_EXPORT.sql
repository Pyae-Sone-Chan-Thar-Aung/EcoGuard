-- EcoGuard Database Schema Export
-- PostgreSQL Database Schema for Supabase Backend
-- Generated for Final Project Submission

-- ============================================
-- USERS AND AUTHENTICATION
-- ============================================

-- User profiles table
CREATE TABLE IF NOT EXISTS profiles (
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

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- RLS Policies for profiles
CREATE POLICY "Users can view own profile" 
  ON profiles FOR SELECT 
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" 
  ON profiles FOR UPDATE 
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" 
  ON profiles FOR INSERT 
  WITH CHECK (auth.uid() = id);

-- ============================================
-- ENVIRONMENTAL TRACKING
-- ============================================

-- Trees table - tracks planted trees
CREATE TABLE IF NOT EXISTS trees (
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
  status VARCHAR DEFAULT 'planted' CHECK (status IN ('planted', 'growing', 'mature', 'removed')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE trees ENABLE ROW LEVEL SECURITY;

-- RLS Policies for trees
CREATE POLICY "Users can view own trees" 
  ON trees FOR SELECT 
  USING (auth.uid() = user_id OR auth.uid() = planted_by);

CREATE POLICY "Users can insert own trees" 
  ON trees FOR INSERT 
  WITH CHECK (auth.uid() = user_id OR auth.uid() = planted_by);

CREATE POLICY "Users can update own trees" 
  ON trees FOR UPDATE 
  USING (auth.uid() = user_id OR auth.uid() = planted_by);

-- Index for performance
CREATE INDEX idx_trees_user_id ON trees(user_id);
CREATE INDEX idx_trees_planted_by ON trees(planted_by);
CREATE INDEX idx_trees_planted_at ON trees(planted_at DESC);

-- ============================================
-- E-WASTE MANAGEMENT
-- ============================================

-- E-waste items catalog
CREATE TABLE IF NOT EXISTS ewaste_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR NOT NULL,
  description TEXT,
  category VARCHAR NOT NULL CHECK (category IN ('phones', 'computers', 'appliances', 'batteries', 'accessories')),
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

-- Public read access for ewaste catalog
ALTER TABLE ewaste_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view ewaste items" 
  ON ewaste_items FOR SELECT 
  USING (true);

-- Index for search
CREATE INDEX idx_ewaste_category ON ewaste_items(category);
CREATE INDEX idx_ewaste_name ON ewaste_items(name);

-- User's recycled e-waste records
CREATE TABLE IF NOT EXISTS user_ewaste_recycled (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  ewaste_item_id UUID REFERENCES ewaste_items(id) ON DELETE SET NULL,
  item_name VARCHAR NOT NULL,
  quantity INTEGER DEFAULT 1,
  recycled_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  recycling_center VARCHAR,
  points_earned INTEGER DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE user_ewaste_recycled ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own recycled items" 
  ON user_ewaste_recycled FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own recycled items" 
  ON user_ewaste_recycled FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

CREATE INDEX idx_user_ewaste_user_id ON user_ewaste_recycled(user_id);

-- ============================================
-- CARBON FOOTPRINT TRACKING
-- ============================================

-- Carbon footprint calculations
CREATE TABLE IF NOT EXISTS carbon_footprints (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  total_annual_emissions DECIMAL(10, 2) NOT NULL,
  
  -- Breakdown by category
  transportation_emissions DECIMAL(10, 2) DEFAULT 0,
  energy_emissions DECIMAL(10, 2) DEFAULT 0,
  food_emissions DECIMAL(10, 2) DEFAULT 0,
  waste_emissions DECIMAL(10, 2) DEFAULT 0,
  other_emissions DECIMAL(10, 2) DEFAULT 0,
  
  -- Input data (JSONB for flexibility)
  emissions_by_category JSONB NOT NULL,
  user_inputs JSONB,
  
  -- Recommendations
  recommended_actions TEXT[],
  trees_needed_to_offset INTEGER,
  
  calculated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE carbon_footprints ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own carbon footprints" 
  ON carbon_footprints FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own carbon footprints" 
  ON carbon_footprints FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

CREATE INDEX idx_carbon_user_id ON carbon_footprints(user_id);
CREATE INDEX idx_carbon_calculated_at ON carbon_footprints(calculated_at DESC);

-- ============================================
-- GAMIFICATION & ACTIVITIES
-- ============================================

-- Activity log for points and history
CREATE TABLE IF NOT EXISTS activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  activity_type VARCHAR NOT NULL CHECK (activity_type IN 
    ('tree_planting', 'ewaste_recycling', 'carbon_calculation', 
     'game_played', 'quiz_completed', 'daily_login', 'achievement_unlocked')),
  title VARCHAR NOT NULL,
  description TEXT,
  points_earned INTEGER NOT NULL DEFAULT 0,
  
  -- Flexible metadata storage
  metadata JSONB,
  
  -- Related records
  related_tree_id UUID REFERENCES trees(id) ON DELETE SET NULL,
  related_ewaste_id UUID REFERENCES user_ewaste_recycled(id) ON DELETE SET NULL,
  
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE activities ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own activities" 
  ON activities FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own activities" 
  ON activities FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

-- Indexes for performance
CREATE INDEX idx_activities_user_id_created_at ON activities(user_id, created_at DESC);
CREATE INDEX idx_activities_type ON activities(activity_type);

-- ============================================
-- ACHIEVEMENTS & BADGES
-- ============================================

-- Achievements definition
CREATE TABLE IF NOT EXISTS achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR NOT NULL UNIQUE,
  description TEXT NOT NULL,
  badge_icon_url TEXT,
  category VARCHAR CHECK (category IN ('trees', 'ewaste', 'carbon', 'streak', 'points')),
  points_reward INTEGER DEFAULT 0,
  requirement_type VARCHAR NOT NULL,
  requirement_value INTEGER NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User achievements
CREATE TABLE IF NOT EXISTS user_achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  achievement_id UUID REFERENCES achievements(id) ON DELETE CASCADE,
  unlocked_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, achievement_id)
);

ALTER TABLE user_achievements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own achievements" 
  ON user_achievements FOR SELECT 
  USING (auth.uid() = user_id);

CREATE INDEX idx_user_achievements_user_id ON user_achievements(user_id);

-- ============================================
-- LEADERBOARD & STATISTICS
-- ============================================

-- Leaderboard view (materialized for performance)
CREATE MATERIALIZED VIEW IF NOT EXISTS leaderboard AS
SELECT 
  p.id,
  p.display_name,
  p.avatar_url,
  p.eco_points,
  p.current_streak,
  p.trees_planted,
  p.items_recycled,
  RANK() OVER (ORDER BY p.eco_points DESC) as rank
FROM profiles p
ORDER BY p.eco_points DESC
LIMIT 100;

-- Refresh function for leaderboard
CREATE OR REPLACE FUNCTION refresh_leaderboard()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW leaderboard;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger to refresh leaderboard when profiles update
CREATE TRIGGER trigger_refresh_leaderboard
AFTER INSERT OR UPDATE OR DELETE ON profiles
FOR EACH STATEMENT
EXECUTE FUNCTION refresh_leaderboard();

-- ============================================
-- FUNCTIONS & TRIGGERS
-- ============================================

-- Function to update user stats when activity is logged
CREATE OR REPLACE FUNCTION update_user_stats_on_activity()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE profiles
  SET 
    eco_points = eco_points + NEW.points_earned,
    updated_at = NOW()
  WHERE id = NEW.user_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for activity logging
CREATE TRIGGER trigger_update_stats_on_activity
AFTER INSERT ON activities
FOR EACH ROW
EXECUTE FUNCTION update_user_stats_on_activity();

-- Function to update tree count
CREATE OR REPLACE FUNCTION update_tree_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE profiles
  SET 
    trees_planted = trees_planted + 1,
    updated_at = NOW()
  WHERE id = NEW.planted_by OR id = NEW.user_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for tree planting
CREATE TRIGGER trigger_update_tree_count
AFTER INSERT ON trees
FOR EACH ROW
EXECUTE FUNCTION update_tree_count();

-- Function to update recycling count
CREATE OR REPLACE FUNCTION update_recycling_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE profiles
  SET 
    items_recycled = items_recycled + NEW.quantity,
    updated_at = NOW()
  WHERE id = NEW.user_id;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for e-waste recycling
CREATE TRIGGER trigger_update_recycling_count
AFTER INSERT ON user_ewaste_recycled
FOR EACH ROW
EXECUTE FUNCTION update_recycling_count();

-- ============================================
-- SAMPLE DATA (Optional - for testing)
-- ============================================

-- Sample e-waste items
INSERT INTO ewaste_items (name, category, description, disposal_instructions, eco_points_value) VALUES
  ('iPhone', 'phones', 'Smartphone device', ARRAY['Remove battery', 'Take to authorized recycler'], 50),
  ('Laptop', 'computers', 'Portable computer', ARRAY['Backup data', 'Take to e-waste center'], 100),
  ('LED TV', 'appliances', 'Television display', ARRAY['Contact manufacturer', 'Schedule pickup'], 150),
  ('AA Batteries', 'batteries', 'Alkaline batteries', ARRAY['Do not throw in trash', 'Take to battery collection'], 10),
  ('Phone Charger', 'accessories', 'USB charging cable', ARRAY['Take to e-waste bin'], 5)
ON CONFLICT DO NOTHING;

-- Sample achievements
INSERT INTO achievements (name, description, category, points_reward, requirement_type, requirement_value) VALUES
  ('First Tree', 'Plant your first tree', 'trees', 100, 'trees_planted', 1),
  ('Forest Maker', 'Plant 10 trees', 'trees', 500, 'trees_planted', 10),
  ('Eco Warrior', 'Reach 1000 points', 'points', 200, 'total_points', 1000),
  ('Recycling Champion', 'Recycle 20 items', 'ewaste', 300, 'items_recycled', 20),
  ('7 Day Streak', 'Maintain a 7-day streak', 'streak', 100, 'current_streak', 7)
ON CONFLICT DO NOTHING;

-- ============================================
-- INDEXES FOR OPTIMIZATION
-- ============================================

-- Additional indexes for common queries
CREATE INDEX IF NOT EXISTS idx_profiles_eco_points ON profiles(eco_points DESC);
CREATE INDEX IF NOT EXISTS idx_profiles_streak ON profiles(current_streak DESC);

-- ============================================
-- VIEWS FOR ANALYTICS
-- ============================================

-- User statistics summary
CREATE OR REPLACE VIEW user_stats_summary AS
SELECT 
  p.id,
  p.display_name,
  p.eco_points,
  p.current_streak,
  COUNT(DISTINCT t.id) as total_trees,
  COUNT(DISTINCT uer.id) as total_recycled,
  COUNT(DISTINCT a.id) as total_activities,
  SUM(a.points_earned) as total_points_earned
FROM profiles p
LEFT JOIN trees t ON p.id = t.planted_by
LEFT JOIN user_ewaste_recycled uer ON p.id = uer.user_id
LEFT JOIN activities a ON p.id = a.user_id
GROUP BY p.id, p.display_name, p.eco_points, p.current_streak;

-- ============================================
-- SECURITY NOTES
-- ============================================

/*
Row Level Security (RLS) is enabled on all tables to ensure:
1. Users can only access their own data
2. Public data (e-waste catalog) is readable by all
3. Write operations are restricted to data owners
4. Admin operations require service_role key

API Keys:
- anon key: Used by mobile app for authenticated requests
- service_role key: Used for admin operations (keep secret!)

Authentication:
- Handled by Supabase Auth with JWT tokens
- Email/password authentication enabled
- OAuth providers can be added (Google, GitHub, etc.)
*/

-- ============================================
-- BACKUP AND MAINTENANCE
-- ============================================

-- Regular maintenance commands (run periodically)
-- VACUUM ANALYZE profiles;
-- VACUUM ANALYZE trees;
-- VACUUM ANALYZE activities;
-- REFRESH MATERIALIZED VIEW leaderboard;

-- ============================================
-- END OF SCHEMA
-- ============================================
