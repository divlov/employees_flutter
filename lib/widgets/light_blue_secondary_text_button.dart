import 'package:flutter/material.dart';

class LightBlueSecondaryTextButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;

  const LightBlueSecondaryTextButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFFEDF8FF)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)))),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
