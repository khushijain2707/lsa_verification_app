import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'controllers/verification_controller.dart';
import 'screens/lsa_verification_screen.dart';
import 'services/compliance_service.dart';

void main() {
  final controller = VerificationController();

  final service = ComplianceService(
    client: http.Client(),
    controller: controller,
    demoMode: true,
  );

  runApp(
    LsaVerificationApp(
      controller: controller,
      service: service,
    ),
  );
}

class LsaVerificationApp extends StatelessWidget {
  final VerificationController controller;
  final ComplianceService service;

  const LsaVerificationApp({
    super.key,
    required this.controller,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LSA Verification',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A2E6D),
        ),
      ),
      home: LsaVerificationScreen(
        controller: controller,
        service: service,
      ),
    );
  }
}