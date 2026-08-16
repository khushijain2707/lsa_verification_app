import 'package:flutter/material.dart';

class LsaHeader extends StatelessWidget {
  const LsaHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text(
          'LSA Onboarding Gate',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'HabotConnect Data Compliance',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}