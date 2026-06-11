// widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscure;
  final TextInputType keyboard;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffix;

  const CustomTextField({
    super.key, required this.label, this.hint,
    this.controller, this.obscure = false,
    this.keyboard = TextInputType.text,
    this.validator, this.prefixIcon, this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(
          fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.black)),
        const SizedBox(height: 6),
        TextFormField(
          controller:    controller,
          obscureText:   obscure,
          keyboardType:  keyboard,
          validator:     validator,
          decoration: InputDecoration(
            hintText:    hint,
            prefixIcon:  prefixIcon != null ? Icon(prefixIcon, color: AppColors.textMuted) : null,
            suffixIcon:  suffix,
          ),
        ),
      ],
    );
  }
}
