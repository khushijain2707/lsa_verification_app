import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lsa_verification_app/utils/crypto_utils.dart';
import 'package:lsa_verification_app/utils/uuid_utils.dart';

import '../controllers/verification_controller.dart';
import '../models/verification_request.dart';
import '../models/verification_status.dart';

class LineageException implements Exception {
  final String message;

  const LineageException(this.message);

  @override
  String toString() => message;
}

class ComplianceService {
  static const String endpoint =
      'https://api.habotconnect.com/v1/compliance/verify';

  static const String lsaId = 'LSA-7049';

  static const String predecessorId = 'PRED-9982-XYZ';

  final http.Client client;
  final VerificationController controller;

  // Demo mode is controlled from main.dart.
  final bool demoMode;

  ComplianceService({
    required this.client,
    required this.controller,
    this.demoMode = false,
  });

  Future<void> verify() async {
    final consentCode =
        controller.consentController.text.trim();

    // FAIL-CLOSED: validate before any network request.
    if (!_isValidLineage(predecessorId)) {
      _quarantine();
      return;
    }

    if (consentCode.isEmpty) {
      _quarantine();
      return;
    }

    controller.frictionLogger.onSubmit();

    controller.status.value =
        VerificationStatus.processing;

    try {
      // ---------------- DEMO MODE ----------------
      //
      // PCC-2026-9901 -> Success
      // TEST-500       -> HTTP 500 -> Quarantined
      //
      // -------------------------------------------

      if (demoMode) {
        await Future.delayed(
          const Duration(milliseconds: 800),
        );

        late http.Response response;

        if (consentCode == 'PCC-2026-9901') {
          response = http.Response(
            jsonEncode({
              'status': 'success',
            }),
            200,
          );
        } else {
          response = http.Response(
            '',
            500,
          );
        }

        await _handleResponse(response);
        return;
      }

      // ---------------- REAL API MODE ----------------

      final request = VerificationRequest(
        predecessorId: predecessorId,
        lsaId: lsaId,
        parentConsentCode: consentCode,
        timestampUtc:
            DateTime.now().toUtc().toIso8601String(),
      );

      final jsonBody =
          jsonEncode(request.toJson());

      final traceId =
          UuidUtils.generateTraceId();

      final logicHash =
          CryptoUtils.generateLogicHash(jsonBody);

      final response = await client.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'x-trace-id': traceId,
          'x-logic-hash': logicHash,
        },
        body: jsonBody,
      ).timeout(
        const Duration(seconds: 10),
      );

      await _handleResponse(response);
    } on TimeoutException {
      _quarantine();
    } on FormatException {
      _quarantine();
    } catch (_) {
      _quarantine();
    }
  }

  Future<void> _handleResponse(
    http.Response response,
  ) async {
    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      _quarantine();
      return;
    }

    final responseBody =
        jsonDecode(response.body);

    if (responseBody is! Map<String, dynamic>) {
      _quarantine();
      return;
    }

    final responseStatus =
        responseBody['status'];

    if (responseStatus == 'success' ||
        responseStatus == 'verified') {
      controller.status.value =
          VerificationStatus.success;
      return;
    }

    _quarantine();
  }

  bool _isValidLineage(String value) {
    return value.trim().isNotEmpty &&
        value == predecessorId;
  }

  void _quarantine() {
    controller.clearSensitiveData();

    controller.status.value =
        VerificationStatus.quarantined;
  }
}