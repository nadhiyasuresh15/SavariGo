// widgets/match_score_card.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class MatchScoreCard extends StatelessWidget {
  final int score;
  final int farePerPerson;
  final int savings;
  final String matchedName;

  const MatchScoreCard({super.key,
    required this.score, required this.farePerPerson,
    required this.savings, required this.matchedName});

  Color get _scoreColor {
    if (score >= 90) return AppColors.green;
    if (score >= 70) return AppColors.orange;
    return AppColors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _statCol('🤖 AI Score', '$score/100', _scoreColor, large: true),
            Container(width: 1, height: 50, color: AppColors.grey),
            _statCol('Your Fare', '₹$farePerPerson', AppColors.black),
            Container(width: 1, height: 50, color: AppColors.grey),
            _statCol('You Save', '₹$savings', AppColors.green),
          ]),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(children: [
              const Icon(Icons.person, color: AppColors.green, size: 18),
              const SizedBox(width: 8),
              Text('Matched with: $matchedName',
                  style: const TextStyle(color: AppColors.green, fontWeight: FontWeight.w700)),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _statCol(String label, String value, Color color, {bool large = false}) {
    return Column(children: [
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
      const SizedBox(height: 4),
      Text(value, style: TextStyle(
          fontSize: large ? 24 : 20, fontWeight: FontWeight.w900, color: color)),
    ]);
  }
}
