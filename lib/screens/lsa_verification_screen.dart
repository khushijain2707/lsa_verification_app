import 'package:flutter/material.dart';

import '../controllers/verification_controller.dart';
import '../services/compliance_service.dart';
import '../widgets/consent_code_field.dart';
import '../widgets/lsa_header.dart';
import '../widgets/lsa_id_field.dart';
import '../widgets/status_indicator.dart';
import '../widgets/verify_button.dart';

class LsaVerificationScreen extends StatelessWidget {
  final VerificationController controller;
  final ComplianceService service;

  const LsaVerificationScreen({
    super.key,
    required this.controller,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              const LsaHeader(),

              const SizedBox(height: 40),

              const LsaIdField(),

              const SizedBox(height: 20),

              ConsentCodeField(
                controller: controller,
              ),

              const SizedBox(height: 20),

              // Predecessor ID is intentionally kept
              // system-controlled and is not user-editable.
              const SizedBox(height: 4),

              VerifyButton(
                controller: controller,
                service: service,
              ),

              const SizedBox(height: 24),

              StatusIndicator(
                controller: controller,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}