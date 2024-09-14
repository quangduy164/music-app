import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback? _onPressed;
  final bool enabled;

  RegisterButton({required VoidCallback? onPressed, this.enabled = true})
      : _onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
          child: Text(
            'Register',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled ? Colors.green : Colors.grey,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: (){
            if (_onPressed != null) {
              _onPressed();
            }
            Navigator.of(context).pop();
          }
      ),
    );
  }
}
