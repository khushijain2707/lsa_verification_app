import 'package:flutter/material.dart';

import '../controllers/verification_controller.dart';

class ConsentCodeField extends StatelessWidget {
  final VerificationController controller;

  const ConsentCodeField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.consentController,
      focusNode: controller.consentFocus,
      onTap: () {
        controller.frictionLogger.onFocusGained();
      },
      onChanged: (_) {
        controller.frictionLogger.onUserTyped();
      },
      onTapOutside: (_) {
        controller.frictionLogger.onFocusLost();
      },
      decoration: const InputDecoration(
        labelText: 'Parent Consent Code',
        hintText: 'Enter consent code',
        border: OutlineInputBorder(),
      ),
    );
  }
}
