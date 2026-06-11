// services/supabase_service.dart
// SavariGo - Supabase Configuration
//
// ============================================================
// HOW TO SET UP YOUR SUPABASE CREDENTIALS:
// ============================================================
// 1. Go to https://supabase.com and create a free account
// 2. Create a new project named "SavariGo"
// 3. Go to Settings → API in your Supabase project
// 4. Copy your "Project URL" and paste it below as supabaseUrl
// 5. Copy your "anon / public" key and paste it as supabaseAnonKey
// 6. Save this file and run: flutter pub get
// ============================================================

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  // 🔑 PASTE YOUR SUPABASE CREDENTIALS HERE ↓
  static const String supabaseUrl = 'https://pabyotqihtbptynfpwvk.supabase.co';
  static const String supabaseAnonKey =
      'sb_publishable_UcUoa2-WQYND-nWSzT-Jcw_hkfqa4uz';
  // 🔑 END OF CREDENTIALS ↑

  // Access the Supabase client anywhere in the app
  static SupabaseClient get client => Supabase.instance.client;

  // Access the auth helper
  static GoTrueClient get auth => Supabase.instance.client.auth;
}
