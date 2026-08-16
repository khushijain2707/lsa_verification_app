import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:lsa_verification_app/controllers/verification_controller.dart';
import 'package:lsa_verification_app/models/verification_status.dart';
import 'package:lsa_verification_app/screens/lsa_verification_screen.dart';
import 'package:lsa_verification_app/services/compliance_service.dart';

class FakeHttpClient extends http.BaseClient {
  final http.Response Function() responseFactory;

  FakeHttpClient(this.responseFactory);

  @override
  Future<http.StreamedResponse> send(
    http.BaseRequest request,
  ) async {
    final response = responseFactory();

    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
      request: request,
    );
  }
}

void main() {
  group('LSA Verification Tests', () {
    late VerificationController controller;

    setUp(() {
      controller = VerificationController();
    });

    tearDown(() {
      controller.dispose();
    });

    // --------------------------------------------------
    // TEST 1 - VALID SUBMISSION
    // --------------------------------------------------

    testWidgets(
      'Test 1 - Valid submission succeeds',
      (tester) async {
        final client = FakeHttpClient(
          () => http.Response(
            '{"status":"success"}',
            200,
          ),
        );

        final service = ComplianceService(
          client: client,
          controller: controller,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: LsaVerificationScreen(
              controller: controller,
              service: service,
            ),
          ),
        );

        final consentField = find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.controller == controller.consentController,
        );

        expect(consentField, findsOneWidget);

        await tester.enterText(
          consentField,
          'PCC-2026-9901',
        );

        await tester.tap(
          find.text('Verify & Submit'),
        );

        await tester.pumpAndSettle();

        expect(
          controller.status.value,
          VerificationStatus.success,
        );
      },
    );

    // --------------------------------------------------
    // TEST 2 - MISSING LINEAGE
    // --------------------------------------------------

    testWidgets(
      'Test 2 - Missing lineage is quarantined',
      (tester) async {
        bool apiCalled = false;

        final client = FakeHttpClient(
          () {
            apiCalled = true;

            return http.Response(
              '{"status":"success"}',
              200,
            );
          },
        );

        final service = ComplianceService(
          client: client,
          controller: controller,
          predecessorId: '',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: LsaVerificationScreen(
              controller: controller,
              service: service,
            ),
          ),
        );

        final consentField = find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.controller == controller.consentController,
        );

        await tester.enterText(
          consentField,
          'PCC-2026-9901',
        );

        await tester.tap(
          find.text('Verify & Submit'),
        );

        await tester.pump();

        expect(
          controller.status.value,
          VerificationStatus.quarantined,
        );

        expect(
          controller.consentController.text,
          isEmpty,
        );

        // Fail-closed:
        // API must NOT be called when lineage is invalid.
        expect(apiCalled, isFalse);
      },
    );

    // --------------------------------------------------
    // TEST 3 - API 500
    // --------------------------------------------------

    testWidgets(
      'Test 3 - API 500 response is quarantined',
      (tester) async {
        final client = FakeHttpClient(
          () => http.Response(
            'Internal Server Error',
            500,
          ),
        );

        final service = ComplianceService(
          client: client,
          controller: controller,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: LsaVerificationScreen(
              controller: controller,
              service: service,
            ),
          ),
        );

        final consentField = find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.controller == controller.consentController,
        );

        expect(
          consentField,
          findsOneWidget,
        );

        await tester.enterText(
          consentField,
          'PCC-2026-9901',
        );

        expect(
          controller.consentController.text,
          'PCC-2026-9901',
        );

        await tester.tap(
          find.text('Verify & Submit'),
        );

        await tester.pumpAndSettle();

        expect(
          controller.status.value,
          VerificationStatus.quarantined,
        );

        expect(
          controller.consentController.text,
          isEmpty,
        );
      },
    );
  });
}
