import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/data/repository/user_repository.dart';
import 'package:music_app/data/blocs/register_bloc.dart';
import 'package:music_app/ui/register/register_page.dart';

class RegisterUserButton extends StatelessWidget {
  final UserRepository _userRepository;

  RegisterUserButton({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ElevatedButton(
          child: Text(
            'Register a new Account',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context){
                      return BlocProvider<RegisterBloc>(
                        create: (context) => RegisterBloc(userRepository: _userRepository),
                        child: RegisterPage(userRepository: _userRepository,),
                      );
                    }
                )
            );
          }
      ),
    );
  }
}
