// widgets/custom_button.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool secondary;
  final IconData? icon;
  final Color? color;

  const CustomButton({
    super.key, required this.label, this.onPressed,
    this.loading = false, this.secondary = false,
    this.icon, this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? (secondary ? Colors.transparent : AppColors.yellow);
    final fg = secondary ? AppColors.black : AppColors.black;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          side: secondary ? const BorderSide(color: AppColors.yellow, width: 2) : null,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: secondary ? 0 : 2,
        ),
        child: loading
            ? const SizedBox(height: 20, width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.black))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                ],
              ),
      ),
    );
  }
}
