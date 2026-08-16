import 'package:flutter/material.dart';

import '../controllers/verification_controller.dart';
import '../models/verification_status.dart';
import '../services/compliance_service.dart';

class VerifyButton extends StatelessWidget {
  final VerificationController controller;
  final ComplianceService service;

  const VerifyButton({
    super.key,
    required this.controller,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VerificationStatus>(
      valueListenable: controller.status,
      builder: (context, status, _) {
        final processing =
            status == VerificationStatus.processing;

        final quarantined =
            status == VerificationStatus.quarantined;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed:
                processing || quarantined
                    ? null
                    : service.verify,
            child: processing
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Verify & Submit',
                  ),
          ),
        );
      },
    );
  }
}