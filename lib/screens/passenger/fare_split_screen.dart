// screens/passenger/fare_split_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../services/fare_service.dart';

class FareSplitScreen extends StatelessWidget {
  const FareSplitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    final distKm   = (args['distance'] as num?)?.toDouble() ?? 12.0;
    final passengers = (args['passengers'] as int?) ?? 3;
    final fare = FareService.calculate(distKm, passengers);

    return Scaffold(
      appBar: AppBar(title: const Text('Fare Split 💰')),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [

        // Big fare display
        Card(child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
          const Text('Your Share', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
          Text('₹${fare.farePerPerson}', style: const TextStyle(
              fontSize: 64, fontWeight: FontWeight.w900, color: AppColors.black)),
          const Text('per person', style: TextStyle(color: AppColors.textMuted)),
          const Divider(height: 28),

          for (final row in [
            ['Base Fare',   '₹${FareService.baseFare}'],
            ['Distance',    '${fare.distanceKm.toStringAsFixed(1)} km × ₹${FareService.perKmRate}'],
            ['Total Fare',  '₹${fare.totalFare}'],
            ['Passengers',  '${fare.numPassengers} people'],
            ['Fare/Person', '₹${fare.farePerPerson}'],
            if (fare.isPeakHour) ['Peak Surge', '+20%'],
          ])
            Padding(padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(row[0], style: const TextStyle(color: AppColors.textMuted, fontSize: 14)),
                Text(row[1], style: const TextStyle(fontWeight: FontWeight.w700)),
              ]),
            ),
        ]))),

        const SizedBox(height: 14),

        // Savings banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.lightGreen,
            borderRadius: BorderRadius.circular(14),
            border: const Border(left: BorderSide(color: AppColors.green, width: 5)),
          ),
          child: Column(children: [
            Text('🌿 You Save ₹${fare.savings}!',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.green)),
            const SizedBox(height: 4),
            Text('That\'s ${fare.savingsPercent}% less than a private auto ride!',
                style: const TextStyle(color: AppColors.green, fontSize: 13)),
            const SizedBox(height: 8),
            const Text('+10 Green Points earned for sharing 🌱',
                style: TextStyle(color: AppColors.green, fontWeight: FontWeight.w600, fontSize: 12)),
          ]),
        ),

        const SizedBox(height: 14),

        // Seat visual
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Passengers in this Pool', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(children: List.generate(fare.numPassengers, (i) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(children: [
              CircleAvatar(backgroundColor: AppColors.yellow,
                  child: Text(['A', 'N', 'P', 'K'][i % 4],
                      style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.black))),
              const SizedBox(height: 4),
              Text(['You', 'Nadhiya', 'Priya', 'Karthik'][i % 4],
                  style: const TextStyle(fontSize: 11)),
            ]),
          ))),
        ]))),
      ]))),
    );
  }
}
