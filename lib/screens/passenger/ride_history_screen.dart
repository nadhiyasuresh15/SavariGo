// screens/passenger/ride_history_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/ride_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/ride_card.dart';
import '../../utils/helpers.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});
  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  List<Map<String, dynamic>> _rides = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = AuthService.currentUser;
    final data = await RideService.getRideHistory(user?['id'] ?? 'demo');
    setState(() { _rides = data; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ride History 📋')),
      backgroundColor: AppColors.background,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.yellow))
          : _rides.isEmpty
              ? const Center(child: Text('No rides yet. Book your first shared auto! 🚖',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 15)))
              : ListView(padding: const EdgeInsets.all(14), children: [
                  // Summary row
                  Row(children: [
                    _chip('Total', '${_rides.length}', AppColors.black),
                    const SizedBox(width: 8),
                    _chip('✅ Done', '${_rides.where((r) => r['status'] == 'completed').length}', AppColors.green),
                    const SizedBox(width: 8),
                    _chip('👩 Women', '${_rides.where((r) => r['women_only'] == true).length}', AppColors.pink),
                  ]),
                  const SizedBox(height: 12),
                  ..._rides.map((r) => RideCard(
                    pickup:        r['pickup_location'] ?? '',
                    drop:          r['drop_location'] ?? '',
                    farePerPerson: (r['fare_per_person'] as num?)?.toInt() ?? 0,
                    status:        r['status'] ?? 'completed',
                    womenOnly:     r['women_only'] ?? false,
                    date:          Helpers.formatDate(r['created_at']),
                  )),
                ]),
    );
  }

  Widget _chip(String label, String value, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(label, style: TextStyle(fontSize: 12, color: color)),
      const SizedBox(width: 6),
      Text(value, style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 16)),
    ]),
  );
}
