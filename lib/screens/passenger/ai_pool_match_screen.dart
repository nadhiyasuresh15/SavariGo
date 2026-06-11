import 'dart:async';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../widgets/custom_button.dart';

class AIPoolMatchScreen extends StatefulWidget {
  const AIPoolMatchScreen({super.key});

  @override
  State<AIPoolMatchScreen> createState() => _AIPoolMatchScreenState();
}

class _AIPoolMatchScreenState extends State<AIPoolMatchScreen> {
  bool _loading = true;
  int _score = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });

      Timer.periodic(const Duration(milliseconds: 25), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_score < 92) {
          setState(() {
            _score++;
          });
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};

    final pickup = args['pickup'] ?? 'Tambaram';
    final drop = args['drop'] ?? 'Guindy';
    final womenOnly = args['womenOnly'] ?? false;

    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: 90, height: 90),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                color: AppColors.yellow,
                strokeWidth: 4,
              ),
              const SizedBox(height: 20),
              const Text(
                'AI is finding your best pool match...',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Checking pickup, drop, seats, time and safety preference',
                style: TextStyle(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Pool Match 🤖'),
        backgroundColor: AppColors.yellow,
        foregroundColor: AppColors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Score Header
            Container(
              width: double.infinity,
              color: AppColors.yellow,
              padding: const EdgeInsets.symmetric(vertical: 26),
              child: Column(
                children: [
                  Text(
                    '$_score',
                    style: const TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w900,
                      color: AppColors.black,
                    ),
                  ),
                  const Text(
                    'AI Match Score / 100',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '🎯 Excellent Pool Match Found!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Match summary card
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          const Text(
                            'Matched Passenger',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const CircleAvatar(
                            radius: 34,
                            backgroundColor: AppColors.yellow,
                            child: Text(
                              'P',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: AppColors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Priya S',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            womenOnly
                                ? 'Women-only safe pool enabled'
                                : 'Same route passenger matched',
                            style: const TextStyle(
                              color: AppColors.green,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Ride Details
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🚖 Ride Details',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _row('🟢 Pickup', pickup),
                          _row('🔴 Drop', drop),
                          _row('⏱️ ETA', '8 minutes'),
                          _row('🚖 Driver', 'Ravi Auto ⭐ 4.9'),
                          _row('🚗 Vehicle', 'TN-01-AB-1234'),
                          _row('✅ Verification', 'Background Checked'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // AI breakdown
                  Card(
                    color: AppColors.lightGreen,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            '🤖 AI Matching Breakdown',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _scoreRow('Pickup Similarity', '25/25'),
                          _scoreRow('Drop Similarity', '23/25'),
                          _scoreRow('Time Similarity', '18/20'),
                          _scoreRow('Seat Availability', '10/10'),
                          _scoreRow('Safety Preference', '16/20'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Fare Split
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            '💰 Fare Split',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _fareItem('Total Fare', '₹180'),
                              _fareItem('Passengers', '3'),
                              _fareItem('Your Share', '₹45', big: true),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.green.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              '🌿 You save ₹90 compared to a private auto!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.green,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  CustomButton(
                    label: 'Confirm Pool Ride 🚖',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Ride Confirmed! 🎉'),
                          content: const Text(
                            'Your shared auto is confirmed.\nDriver Ravi Auto is on the way.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.rideTracking,
                                );
                              },
                              child: const Text('Track Ride'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
          ),
          Flexible(
            child: Text(
              value.toString(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreRow(String title, String score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            score,
            style: const TextStyle(
              color: AppColors.green,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fareItem(String label, String value, {bool big = false}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: big ? 22 : 18,
            fontWeight: FontWeight.w900,
            color: big ? AppColors.green : AppColors.black,
          ),
        ),
      ],
    );
  }
}