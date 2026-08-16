import 'package:flutter/material.dart';

import '../controllers/verification_controller.dart';
import '../models/verification_status.dart';

class StatusIndicator extends StatelessWidget {
  final VerificationController controller;

  const StatusIndicator({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VerificationStatus>(
      valueListenable: controller.status,
      builder: (context, status, _) {
        late IconData icon;
        late Color color;
        late String text;

        switch (status) {
          case VerificationStatus.idle:
            icon = Icons.info_outline;
            color = Colors.grey;
            text = 'Status: Idle';

          case VerificationStatus.processing:
            icon = Icons.hourglass_top;
            color = Colors.orange;
            text = 'Status: Processing';

          case VerificationStatus.success:
            icon = Icons.check_circle;
            color = Colors.green;
            text = 'Verification Successful';

          case VerificationStatus.quarantined:
            icon = Icons.lock;
            color = Colors.red;
            text =
                'Data Quarantined - Compliance Failure';
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius:
                BorderRadius.circular(8),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}