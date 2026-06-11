// main.dart
// SavariGo - AI-Based Shared Auto-Rickshaw Pooling System
// Entry Point

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  // Replace these values with your own Supabase project credentials
  // See: lib/services/supabase_service.dart for instructions
  await Supabase.initialize(
    url: SupabaseService.supabaseUrl,
    anonKey: SupabaseService.supabaseAnonKey,
  );

  runApp(const SavariGoApp());
}
