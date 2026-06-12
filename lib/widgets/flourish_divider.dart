import 'package:flutter/material.dart';

class FlourishDivider extends StatelessWidget {
  const FlourishDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: const Text(
        "~ ❦ ~",
        style: TextStyle(
          fontFamily: 'Serif',
          fontSize: 24,
          color: Color(0xFF483F29),
        ),
      ),
    );
  }
}
