import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback? _onPressed;

  LoginButton({required VoidCallback? onPressed})
      : _onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        child: Text(
          'Login to your account',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: _onPressed,
      ),
    );
  }
}
