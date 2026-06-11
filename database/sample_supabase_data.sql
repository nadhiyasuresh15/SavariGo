-- =====================================================
-- SavariGo - Sample Data for Supabase
-- Run this AFTER supabase_schema.sql
-- =====================================================
-- NOTE: In production, users are created via Supabase Auth.
-- These are sample UUIDs for testing the database tables.
-- =====================================================

-- ── Sample Users ───────────────────────────────────────
INSERT INTO users (id, name, email, phone, gender, role) VALUES
  ('a1b2c3d4-0001-0001-0001-000000000001', 'Arjun Kumar',   'passenger@savarigo.com', '9876543210', 'male',   'passenger'),
  ('a1b2c3d4-0002-0002-0002-000000000002', 'Priya Sharma',  'priya@savarigo.com',     '9876543211', 'female', 'passenger'),
  ('a1b2c3d4-0003-0003-0003-000000000003', 'Nadhiya R',     'nadhiya@savarigo.com',   '9876543212', 'female', 'passenger'),
  ('a1b2c3d4-0004-0004-0004-000000000004', 'Karthik S',     'karthik@savarigo.com',   '9876543213', 'male',   'passenger'),
  ('a1b2c3d4-0005-0005-0005-000000000005', 'Ravi Auto',     'driver@savarigo.com',    '9876543214', 'male',   'driver'),
  ('a1b2c3d4-0006-0006-0006-000000000006', 'Murugan S',     'murugan@savarigo.com',   '9876543215', 'male',   'driver'),
  ('a1b2c3d4-0007-0007-0007-000000000007', 'Admin User',    'admin@savarigo.com',     '9876543216', 'male',   'admin'),
  ('a1b2c3d4-0008-0008-0008-000000000008', 'Lakshmi Devi',  'lakshmi@savarigo.com',   '9876543217', 'female', 'passenger'),
  ('a1b2c3d4-0009-0009-0009-000000000009', 'Kavitha M',     'kavitha@savarigo.com',   '9876543218', 'female', 'passenger')
ON CONFLICT (id) DO NOTHING;

-- ── Sample Passengers ──────────────────────────────────
INSERT INTO passengers (id, user_id, preferred_language, women_only_enabled, trusted_contact, green_points) VALUES
  ('b1b2c3d4-0001-0001-0001-000000000001', 'a1b2c3d4-0001-0001-0001-000000000001', 'Tamil',   FALSE, '9800000001', 30),
  ('b1b2c3d4-0002-0002-0002-000000000002', 'a1b2c3d4-0002-0002-0002-000000000002', 'Tamil',   TRUE,  '9800000002', 50),
  ('b1b2c3d4-0003-0003-0003-000000000003', 'a1b2c3d4-0003-0003-0003-000000000003', 'Tamil',   TRUE,  '9800000003', 20),
  ('b1b2c3d4-0004-0004-0004-000000000004', 'a1b2c3d4-0004-0004-0004-000000000004', 'English', FALSE, '9800000004', 10),
  ('b1b2c3d4-0008-0008-0008-000000000008', 'a1b2c3d4-0008-0008-0008-000000000008', 'Tamil',   TRUE,  '9800000008', 40),
  ('b1b2c3d4-0009-0009-0009-000000000009', 'a1b2c3d4-0009-0009-0009-000000000009', 'Tamil',   TRUE,  '9800000009', 25)
ON CONFLICT (id) DO NOTHING;

-- ── Sample Drivers ─────────────────────────────────────
INSERT INTO drivers (id, user_id, vehicle_number, license_number, verification_status, trust_score, availability_status) VALUES
  ('c1b2c3d4-0005-0005-0005-000000000005', 'a1b2c3d4-0005-0005-0005-000000000005', 'TN-01-AB-1234', 'TN0120230001', 'verified', 92, 'online'),
  ('c1b2c3d4-0006-0006-0006-000000000006', 'a1b2c3d4-0006-0006-0006-000000000006', 'TN-02-CD-5678', 'TN0220230002', 'verified', 88, 'online')
ON CONFLICT (id) DO NOTHING;

-- ── Sample Rides ───────────────────────────────────────
INSERT INTO rides (id, passenger_id, driver_id, pickup_location, drop_location, pickup_lat, pickup_lng, drop_lat, drop_lng, ride_type, women_only, status, total_fare, fare_per_person, seats_required) VALUES
  ('d1b2c3d4-0001-0001-0001-000000000001', 'b1b2c3d4-0001-0001-0001-000000000001', 'c1b2c3d4-0005-0005-0005-000000000005', 'Tambaram',   'Guindy',     12.9249, 80.1000, 13.0067, 80.2206, 'shared',  FALSE, 'completed', 180.00, 60.00, 3),
  ('d1b2c3d4-0002-0002-0002-000000000002', 'b1b2c3d4-0002-0002-0002-000000000002', 'c1b2c3d4-0005-0005-0005-000000000005', 'T Nagar',    'Velachery',  13.0418, 80.2341, 12.9815, 80.2180, 'shared',  TRUE,  'completed', 120.00, 60.00, 2),
  ('d1b2c3d4-0003-0003-0003-000000000003', 'b1b2c3d4-0003-0003-0003-000000000003', 'c1b2c3d4-0006-0006-0006-000000000006', 'Koyambedu',  'Anna Nagar', 13.0694, 80.1948, 13.0850, 80.2101, 'shared',  TRUE,  'in_progress', 90.00, 45.00, 2),
  ('d1b2c3d4-0004-0004-0004-000000000004', 'b1b2c3d4-0004-0004-0004-000000000004', NULL,                                   'Chromepet',  'Saidapet',   12.9516, 80.1462, 13.0197, 80.2245, 'shared',  FALSE, 'searching', 150.00, 75.00, 2),
  ('d1b2c3d4-0005-0005-0005-000000000005', 'b1b2c3d4-0008-0008-0008-000000000008', 'c1b2c3d4-0005-0005-0005-000000000005', 'Adyar',      'Egmore',     13.0012, 80.2565, 13.0732, 80.2609, 'shared',  TRUE,  'completed', 100.00, 50.00, 2)
ON CONFLICT (id) DO NOTHING;

-- ── Sample Ride Matches ────────────────────────────────
INSERT INTO ride_matches (ride_id, matched_passenger_id, match_score, route_similarity, fare_split) VALUES
  ('d1b2c3d4-0001-0001-0001-000000000001', 'b1b2c3d4-0002-0002-0002-000000000002', 92, 88, 60.00),
  ('d1b2c3d4-0002-0002-0002-000000000002', 'b1b2c3d4-0003-0003-0003-000000000003', 85, 80, 60.00),
  ('d1b2c3d4-0005-0005-0005-000000000005', 'b1b2c3d4-0009-0009-0009-000000000009', 78, 75, 50.00)
ON CONFLICT DO NOTHING;

-- ── Sample Feedback ────────────────────────────────────
INSERT INTO feedback (user_id, ride_id, rating, complaint) VALUES
  ('a1b2c3d4-0001-0001-0001-000000000001', 'd1b2c3d4-0001-0001-0001-000000000001', 5, NULL),
  ('a1b2c3d4-0002-0002-0002-000000000002', 'd1b2c3d4-0002-0002-0002-000000000002', 4, NULL),
  ('a1b2c3d4-0003-0003-0003-000000000003', 'd1b2c3d4-0003-0003-0003-000000000003', 3, 'Driver took longer route'),
  ('a1b2c3d4-0008-0008-0008-000000000008', 'd1b2c3d4-0005-0005-0005-000000000005', 5, NULL)
ON CONFLICT DO NOTHING;

-- ── Sample SOS Alert ───────────────────────────────────
INSERT INTO sos_alerts (user_id, ride_id, location, emergency_contact, status) VALUES
  ('a1b2c3d4-0003-0003-0003-000000000003', 'd1b2c3d4-0003-0003-0003-000000000003', 'Koyambedu Bus Stand', '9800000099', 'resolved')
ON CONFLICT DO NOTHING;

-- ── Sample Admin Report ────────────────────────────────
INSERT INTO admin_reports (report_type, report_description) VALUES
  ('daily_rides',   'Total 5 rides completed today in Chennai zone'),
  ('safety_alert',  'SOS resolved within 5 minutes - Koyambedu area'),
  ('driver_verify', 'Ravi Auto verified and active on platform')
ON CONFLICT DO NOTHING;

-- Sample data inserted successfully!
-- Login credentials:
-- Passenger: passenger@savarigo.com / 123456
-- Female:    priya@savarigo.com     / 123456
-- Driver:    driver@savarigo.com    / 123456
-- Admin:     admin@savarigo.com     / admin123
