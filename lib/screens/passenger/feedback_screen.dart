// screens/passenger/feedback_screen.dart
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../widgets/custom_button.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 0;
  final _ctrl = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _submit() {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating'), backgroundColor: AppColors.orange));
      return;
    }
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🙏', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text('Nandri! Thank You!', style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.black)),
          const SizedBox(height: 8),
          const Text('Your feedback helps us improve SavariGo.',
              style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.passengerHome, (_) => false),
            child: const Text('Back to Home'),
          ),
        ])),
      );
    }

    final ratingLabel = ['', 'Poor 😞', 'Fair 😐', 'Good 🙂', 'Great 😊', 'Excellent! 🤩'];

    return Scaffold(
      appBar: AppBar(title: const Text('Rate Your Ride ⭐')),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
          const Text('How was your ride?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) {
            final star = i + 1;
            return GestureDetector(
              onTap: () => setState(() => _rating = star),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(star <= _rating ? '★' : '☆',
                    style: TextStyle(fontSize: 40,
                        color: star <= _rating ? AppColors.yellow : AppColors.grey)),
              ),
            );
          })),
          if (_rating > 0) ...[
            const SizedBox(height: 8),
            Text(ratingLabel[_rating], style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ]))),
        const SizedBox(height: 12),

        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Any complaints or suggestions?',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          TextField(
            controller: _ctrl,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Tell us what we can improve...',
            ),
          ),
        ]))),
        const SizedBox(height: 20),
        CustomButton(label: 'Submit Feedback 🙏', onPressed: _submit),
      ]))),
    );
  }
}
