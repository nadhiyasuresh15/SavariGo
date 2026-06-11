-- =====================================================
-- SavariGo - Supabase Database Schema
-- AI-Based Shared Auto-Rickshaw Pooling System
-- Chennai, Tamil Nadu
-- =====================================================
-- HOW TO USE:
-- 1. Go to your Supabase project
-- 2. Click "SQL Editor" in the left sidebar
-- 3. Paste this entire file and click "Run"
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ── 1. Users Table ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        TEXT NOT NULL,
    email       TEXT UNIQUE NOT NULL,
    phone       TEXT,
    gender      TEXT CHECK (gender IN ('male', 'female', 'other')),
    role        TEXT CHECK (role IN ('passenger', 'driver', 'admin')) DEFAULT 'passenger',
    created_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── 2. Passengers Table ────────────────────────────────
CREATE TABLE IF NOT EXISTS passengers (
    id                   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id              UUID REFERENCES users(id) ON DELETE CASCADE,
    preferred_language   TEXT DEFAULT 'Tamil',
    women_only_enabled   BOOLEAN DEFAULT FALSE,
    trusted_contact      TEXT,
    green_points         INTEGER DEFAULT 0,
    created_at           TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── 3. Drivers Table ───────────────────────────────────
CREATE TABLE IF NOT EXISTS drivers (
    id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id             UUID REFERENCES users(id) ON DELETE CASCADE,
    vehicle_number      TEXT,
    license_number      TEXT,
    verification_status TEXT CHECK (verification_status IN ('pending', 'verified', 'rejected')) DEFAULT 'pending',
    trust_score         INTEGER DEFAULT 0,
    availability_status TEXT CHECK (availability_status IN ('online', 'offline', 'on_ride')) DEFAULT 'offline',
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── 4. Rides Table ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS rides (
    id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    passenger_id     UUID REFERENCES passengers(id),
    driver_id        UUID REFERENCES drivers(id),
    pickup_location  TEXT NOT NULL,
    drop_location    TEXT NOT NULL,
    pickup_lat       DECIMAL(10, 7),
    pickup_lng       DECIMAL(10, 7),
    drop_lat         DECIMAL(10, 7),
    drop_lng         DECIMAL(10, 7),
    ride_type        TEXT CHECK (ride_type IN ('shared', 'private')) DEFAULT 'shared',
    women_only       BOOLEAN DEFAULT FALSE,
    status           TEXT CHECK (status IN ('searching', 'accepted', 'in_progress', 'completed', 'cancelled')) DEFAULT 'searching',
    total_fare       DECIMAL(10, 2),
    fare_per_person  DECIMAL(10, 2),
    seats_required   INTEGER DEFAULT 1,
    ride_time        TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at       TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── 5. Ride Matches Table ──────────────────────────────
CREATE TABLE IF NOT EXISTS ride_matches (
    id                   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ride_id              UUID REFERENCES rides(id),
    matched_passenger_id UUID REFERENCES passengers(id),
    match_score          INTEGER DEFAULT 0,
    route_similarity     INTEGER DEFAULT 0,
    fare_split           DECIMAL(10, 2),
    created_at           TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── 6. Feedback Table ──────────────────────────────────
CREATE TABLE IF NOT EXISTS feedback (
    id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id    UUID REFERENCES users(id),
    ride_id    UUID REFERENCES rides(id),
    rating     INTEGER CHECK (rating BETWEEN 1 AND 5),
    complaint  TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── 7. SOS Alerts Table ────────────────────────────────
CREATE TABLE IF NOT EXISTS sos_alerts (
    id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id           UUID REFERENCES users(id),
    ride_id           UUID REFERENCES rides(id),
    location          TEXT,
    emergency_contact TEXT,
    status            TEXT CHECK (status IN ('active', 'resolved')) DEFAULT 'active',
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── 8. Admin Reports Table ─────────────────────────────
CREATE TABLE IF NOT EXISTS admin_reports (
    id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    report_type         TEXT,
    report_description  TEXT,
    created_at          TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ── Row Level Security (RLS) ───────────────────────────
ALTER TABLE users        ENABLE ROW LEVEL SECURITY;
ALTER TABLE passengers   ENABLE ROW LEVEL SECURITY;
ALTER TABLE drivers      ENABLE ROW LEVEL SECURITY;
ALTER TABLE rides        ENABLE ROW LEVEL SECURITY;
ALTER TABLE ride_matches ENABLE ROW LEVEL SECURITY;
ALTER TABLE feedback     ENABLE ROW LEVEL SECURITY;
ALTER TABLE sos_alerts   ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_reports ENABLE ROW LEVEL SECURITY;

-- Allow all operations for now (tighten in production)
CREATE POLICY "Allow all" ON users        FOR ALL USING (TRUE) WITH CHECK (TRUE);
CREATE POLICY "Allow all" ON passengers   FOR ALL USING (TRUE) WITH CHECK (TRUE);
CREATE POLICY "Allow all" ON drivers      FOR ALL USING (TRUE) WITH CHECK (TRUE);
CREATE POLICY "Allow all" ON rides        FOR ALL USING (TRUE) WITH CHECK (TRUE);
CREATE POLICY "Allow all" ON ride_matches FOR ALL USING (TRUE) WITH CHECK (TRUE);
CREATE POLICY "Allow all" ON feedback     FOR ALL USING (TRUE) WITH CHECK (TRUE);
CREATE POLICY "Allow all" ON sos_alerts   FOR ALL USING (TRUE) WITH CHECK (TRUE);
CREATE POLICY "Allow all" ON admin_reports FOR ALL USING (TRUE) WITH CHECK (TRUE);

-- ── Indexes for performance ────────────────────────────
CREATE INDEX IF NOT EXISTS idx_rides_status      ON rides(status);
CREATE INDEX IF NOT EXISTS idx_rides_passenger   ON rides(passenger_id);
CREATE INDEX IF NOT EXISTS idx_rides_driver      ON rides(driver_id);
CREATE INDEX IF NOT EXISTS idx_rides_women_only  ON rides(women_only);
CREATE INDEX IF NOT EXISTS idx_users_email       ON users(email);
CREATE INDEX IF NOT EXISTS idx_passengers_user   ON passengers(user_id);
CREATE INDEX IF NOT EXISTS idx_drivers_user      ON drivers(user_id);

-- Done! Schema created successfully.
-- Now run: sample_supabase_data.sql to insert sample data.
