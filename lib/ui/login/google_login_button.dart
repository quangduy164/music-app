import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_app/data/blocs/login_bloc.dart';
import 'package:music_app/data/events/login_event.dart';

class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ElevatedButton.icon(
          icon: Icon(FontAwesomeIcons.google, color: Colors.white, size: 17,),
          label: Text(
            'Signin With Google',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: (){
            BlocProvider.of<LoginBloc>(context).add(LogInEventWithGooglePressed());
          }
      ),
    );
  }
}
