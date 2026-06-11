// app.dart
// SavariGo - Root App Widget and Route Configuration

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/app_colors.dart';
import 'constants/app_routes.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/passenger/passenger_home_screen.dart';
import 'screens/passenger/book_ride_screen.dart';
import 'screens/passenger/ai_pool_match_screen.dart';
import 'screens/passenger/women_only_mode_screen.dart';
import 'screens/passenger/fare_split_screen.dart';
import 'screens/passenger/ride_tracking_screen.dart';
import 'screens/passenger/ride_history_screen.dart';
import 'screens/passenger/profile_screen.dart';
import 'screens/passenger/safety_screen.dart';
import 'screens/passenger/feedback_screen.dart';
import 'screens/driver/driver_dashboard_screen.dart';
import 'screens/driver/active_ride_screen.dart';
import 'screens/driver/driver_earnings_screen.dart';
import 'screens/driver/driver_profile_screen.dart';
import 'screens/admin/admin_login_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/manage_users_screen.dart';
import 'screens/admin/manage_drivers_screen.dart';
import 'screens/admin/manage_rides_screen.dart';
import 'screens/admin/sos_alerts_screen.dart';
import 'screens/admin/reports_screen.dart';

class SavariGoApp extends StatelessWidget {
  const SavariGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SavariGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.yellow,
          primary: AppColors.yellow,
          secondary: AppColors.green,
          surface: AppColors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.yellow,
          foregroundColor: AppColors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.black,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.yellow,
            foregroundColor: AppColors.black,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          color: AppColors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.yellow, width: 2),
          ),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.passengerHome: (_) => const PassengerHomeScreen(),
        AppRoutes.bookRide: (_) => const BookRideScreen(),
        AppRoutes.aiPoolMatch: (_) => const AIPoolMatchScreen(),
        AppRoutes.womenOnly: (_) => const WomenOnlyModeScreen(),
        AppRoutes.fareSplit: (_) => const FareSplitScreen(),
        AppRoutes.rideTracking: (_) => const RideTrackingScreen(),
        AppRoutes.rideHistory: (_) => const RideHistoryScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.safety: (_) => const SafetyScreen(),
        AppRoutes.feedback: (_) => const FeedbackScreen(),
        AppRoutes.driverDashboard: (_) => const DriverDashboardScreen(),
        AppRoutes.activeRide: (_) => const ActiveRideScreen(),
        AppRoutes.driverEarnings: (_) => const DriverEarningsScreen(),
        AppRoutes.driverProfile: (_) => const DriverProfileScreen(),
        AppRoutes.adminLogin: (_) => const AdminLoginScreen(),
        AppRoutes.adminDashboard: (_) => const AdminDashboardScreen(),
        AppRoutes.manageUsers: (_) => const ManageUsersScreen(),
        AppRoutes.manageDrivers: (_) => const ManageDriversScreen(),
        AppRoutes.manageRides: (_) => const ManageRidesScreen(),
        AppRoutes.sosAlerts: (_) => const SOSAlertsScreen(),
        AppRoutes.reports: (_) => const ReportsScreen(),
      },
    );
  }
}
