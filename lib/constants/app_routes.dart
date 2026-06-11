// constants/app_routes.dart
// SavariGo Named Route Constants

class AppRoutes {
  AppRoutes._();

  static const String splash          = '/';
  static const String login           = '/login';
  static const String register        = '/register';

  // Passenger
  static const String passengerHome   = '/passenger/home';
  static const String bookRide        = '/passenger/book-ride';
  static const String aiPoolMatch     = '/passenger/ai-match';
  static const String womenOnly       = '/passenger/women-only';
  static const String fareSplit       = '/passenger/fare-split';
  static const String rideTracking    = '/passenger/tracking';
  static const String rideHistory     = '/passenger/history';
  static const String profile         = '/passenger/profile';
  static const String safety          = '/passenger/safety';
  static const String feedback        = '/passenger/feedback';

  // Driver
  static const String driverDashboard = '/driver/dashboard';
  static const String activeRide      = '/driver/active-ride';
  static const String driverEarnings  = '/driver/earnings';
  static const String driverProfile   = '/driver/profile';

  // Admin
  static const String adminLogin      = '/admin/login';
  static const String adminDashboard  = '/admin/dashboard';
  static const String manageUsers     = '/admin/users';
  static const String manageDrivers   = '/admin/drivers';
  static const String manageRides     = '/admin/rides';
  static const String sosAlerts       = '/admin/sos';
  static const String reports         = '/admin/reports';
}
