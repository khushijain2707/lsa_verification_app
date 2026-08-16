import 'package:flutter/material.dart';

class LsaIdField extends StatelessWidget {
  const LsaIdField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: 'LSA-7049',
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'LSA ID',
        border: OutlineInputBorder(),
      ),
    );
  }
}