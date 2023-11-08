import 'package:flutter/material.dart';

class DividerScreenWidth extends StatelessWidget {
  const DividerScreenWidth({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: OverflowBox(
          maxWidth: MediaQuery.of(context).size.width,
          child: const Divider()),
    );
  }
}
