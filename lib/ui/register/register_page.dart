import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/data/repository/user_repository.dart';
import 'package:music_app/data/blocs/register_bloc.dart';
import 'package:music_app/data/states/register_state.dart';
import 'package:music_app/data/events/register_event.dart';
import 'package:music_app/data/blocs/authentication_bloc.dart';
import 'package:music_app/data/events/authentication_event.dart';
import 'package:music_app/ui/register/register_button.dart';

class RegisterPage extends StatefulWidget {
  final UserRepository _userRepository;

  RegisterPage({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late RegisterBloc _registerBloc;
  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    //Khi thay đổi email hàm  này đc gọi
    _emailController.addListener((){
      _registerBloc.add(RegisterEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener((){
      _registerBloc.add(RegisterPasswordChanged(password: _passwordController.text));
    });
  }

//Kiểm tra email và mật khẩu không trống
  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  bool isRegisterButtonEnabled(RegisterState registerState){
    return registerState.isValidEmailAndPassword && isPopulated && !registerState.isSubmitting;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, registerState){
          if(registerState.isFailure){
            print('Register failed');
          }
          else if(registerState.isSubmitting){
            print('Register in progress');
          }
          else if(registerState.isSuccess){
            //thêm event authenticationEventLogin
            BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationEventLoggedIn());
          }
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.email),
                          labelText: 'Email'
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.always,
                      autocorrect: false,
                      validator: (_){
                        return registerState.isValidEmail ? null : 'Invalid email format';
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          labelText: 'Password'
                      ),
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.always,
                      autocorrect: false,
                      validator: (_){
                        return registerState.isValidPassword ? null : 'Invalid password format';
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: RegisterButton(
                        onPressed: isRegisterButtonEnabled(registerState) ?
                        _onRegisterEmailAndPassword : null,
                        enabled: isRegisterButtonEnabled(registerState),
                      ),
                    )
                  ],
                )
            ),
          );
        },
      ),
    );
  }

  void _onRegisterEmailAndPassword(){
    _registerBloc.add(RegisterEventWithEmailAndPasswordPressed(
        email: _emailController.text,
        password: _passwordController.text));
  }
}