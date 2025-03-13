import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool isPassword;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    required this.label,
    required this.controller,
    required this.icon,
    this.isPassword = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
