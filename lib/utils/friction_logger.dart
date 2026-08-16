import 'dart:async';
import 'package:flutter/foundation.dart';

class FrictionLogger {
  Timer? _timer;
  bool _logged = false;

  void onFocusGained() {
    _timer?.cancel();
    _logged = false;

    _timer = Timer(
      const Duration(seconds: 5),
      _emitLog,
    );
  }

  void onUserTyped() {
    _cancelTimer();
  }

  void onFocusLost() {
    _cancelTimer();
  }

  void onSubmit() {
    _cancelTimer();
  }

  void _emitLog() {
    if (_logged) return;

    _logged = true;

    debugPrint(
      '[UI_FRICTION_LOG]\n'
      'Timestamp: ${DateTime.now().toUtc().toIso8601String()}\n'
      'Field: parent_consent_code\n'
      'Hesitation Duration: >5s',
    );
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}