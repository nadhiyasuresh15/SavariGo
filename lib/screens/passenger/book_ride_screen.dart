// screens/passenger/book_ride_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_text.dart';
import '../../services/fare_service.dart';
import '../../widgets/custom_button.dart';

class BookRideScreen extends StatefulWidget {
  const BookRideScreen({super.key});
  @override
  State<BookRideScreen> createState() => _BookRideScreenState();
}

class _BookRideScreenState extends State<BookRideScreen> {
  String? _pickup;
  String? _drop;
  int _seats = 1;
  bool _womenOnly = false;
  bool _selectingPickup = true;

  void _selectLocation(String loc) {
    setState(() {
      if (_selectingPickup) { _pickup = loc; _selectingPickup = false; }
      else { _drop = loc; }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args?['pickup'] != null && _pickup == null) _pickup = args!['pickup'];

    final fareData = (_pickup != null && _drop != null)
        ? FareService.calculate(8, _seats) : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Book Shared Auto 🚖')),
      body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Selected locations
          Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
            _locRow('🟢', 'Pickup:', _pickup ?? 'Tap location below'),
            Container(height: 16, width: 1.5, margin: const EdgeInsets.only(left: 10), color: AppColors.grey),
            _locRow('🔴', 'Drop:',   _drop ?? 'Tap location below'),
          ]))),
          const SizedBox(height: 8),
          Text(
            _selectingPickup ? '▶ Tap a location for PICKUP' : '▶ Tap a location for DROP',
            style: const TextStyle(color: AppColors.pink, fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(height: 12),

          // Location grid
          Wrap(spacing: 8, runSpacing: 8, children: AppText.chennaiLocations.map((loc) {
            final isPick = _pickup == loc;
            final isDrop = _drop == loc;
            return GestureDetector(
              onTap: () => _selectLocation(loc),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isPick ? AppColors.lightGreen : isDrop ? const Color(0xFFFFEBEE) : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isPick ? AppColors.green : isDrop ? AppColors.red : AppColors.grey),
                ),
                child: Text(loc, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                    color: isPick ? AppColors.green : isDrop ? AppColors.red : AppColors.black)),
              ),
            );
          }).toList()),
          const SizedBox(height: 16),

          // Seats
          const Text('Seats Required', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Row(children: [1, 2, 3].map((n) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => _seats = n),
              child: Container(
                width: 56, height: 48,
                decoration: BoxDecoration(
                  color: _seats == n ? AppColors.yellow : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _seats == n ? AppColors.yellow : AppColors.grey, width: 2),
                ),
                child: Center(child: Text('$n', style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w900))),
              ),
            ),
          )).toList()),
          const SizedBox(height: 14),

          // Women-only toggle
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('👩 Women-Only Mode', style: TextStyle(fontWeight: FontWeight.w700)),
            Switch(value: _womenOnly, onChanged: (v) => setState(() => _womenOnly = v),
                activeThumbColor: AppColors.pink),
          ]),
          const SizedBox(height: 14),

          // Fare estimate
          if (fareData != null) Card(
            color: AppColors.lightGreen,
            child: Padding(padding: const EdgeInsets.all(14), child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _fareChip('Total', '₹${fareData.totalFare}'),
              _fareChip('Your Share', '₹${fareData.farePerPerson}', big: true),
              _fareChip('Save', '₹${fareData.savings}', color: AppColors.green),
            ])),
          ),
          const SizedBox(height: 20),

          CustomButton(
            label: 'Find AI Pool Match 🤖',
            onPressed: (_pickup != null && _drop != null) ? () => Navigator.pushNamed(
              context, AppRoutes.aiPoolMatch,
              arguments: {'pickup': _pickup, 'drop': _drop, 'womenOnly': _womenOnly, 'seats': _seats},
            ) : null,
          ),
        ]),
      )),
    );
  }

  Widget _locRow(String emoji, String label, String value) => Row(children: [
    Text(emoji), const SizedBox(width: 10),
    Text('$label ', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
    Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w700))),
  ]);

  Widget _fareChip(String label, String value, {bool big = false, Color? color}) => Column(children: [
    Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
    Text(value, style: TextStyle(
        fontSize: big ? 20 : 16, fontWeight: FontWeight.w900,
        color: color ?? AppColors.black)),
  ]);
}
