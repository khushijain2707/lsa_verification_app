import 'package:flutter/material.dart';
import 'package:lsa_verification_app/utils/friction_logger.dart';
import '../models/verification_status.dart';

class VerificationController {
  final ValueNotifier<VerificationStatus> status =
      ValueNotifier(VerificationStatus.idle);

  final TextEditingController consentController =
      TextEditingController();

  final FocusNode consentFocus = FocusNode();

  final FrictionLogger frictionLogger = FrictionLogger();

  bool get isProcessing =>
      status.value == VerificationStatus.processing;

  bool get isQuarantined =>
      status.value == VerificationStatus.quarantined;

  void clearSensitiveData() {
    consentController.clear();
  }

  void reset() {
    status.value = VerificationStatus.idle;
    clearSensitiveData();
  }

  void dispose() {
    status.dispose();
    consentController.dispose();
    consentFocus.dispose();
    frictionLogger.dispose();
  }
}