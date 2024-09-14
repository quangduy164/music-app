import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/data/blocs/login_bloc.dart';
import 'package:music_app/data/repository/user_repository.dart';
import 'package:music_app/data/blocs/authentication_bloc.dart';
import 'package:music_app/data/events/authentication_event.dart';
import 'package:music_app/data/events/login_event.dart';
import 'package:music_app/data/states/login_state.dart';
import 'package:music_app/ui/login/google_login_button.dart';
import 'package:music_app/ui/login/login_button.dart';
import 'package:music_app/ui/login/register_user_button.dart';

class LoginPage extends StatefulWidget {
  final UserRepository _userRepository;

  LoginPage({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginBloc _loginBloc;
  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    //Khi thay đổi email hàm này đc gọi
    _emailController.addListener((){
      _loginBloc.add(LoginEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener((){
      _loginBloc.add(LoginPasswordChanged(password: _passwordController.text));
    });
  }
  //Kiểm tra email và mật khẩu không trống
  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  bool isLoginButtonEnabled(LoginState loginState){
    return loginState.isValidEmailAndPassword && isPopulated && !loginState.isSubmitting;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.lightBlueAccent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, loginState){
          if(loginState.isFailure){
            print('Login failed');
          }
          else if(loginState.isSubmitting){
            print('Login in');
          }
          else if(loginState.isSuccess){
            //thêm event authenticationEventLogin
            BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationEventLoggedIn());
          }
          return Stack(
            children: [
              Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover, width: double.infinity, height: double.infinity,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.email),
                              labelText: 'Enter your email'
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.always,
                          autocorrect: false,
                          validator: (_){
                            return loginState.isValidEmail ? null : 'Invalid email format';
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              labelText: 'Enter password'
                          ),
                          obscureText: true,
                          autovalidateMode: AutovalidateMode.always,
                          autocorrect: false,
                          validator: (_){
                            return loginState.isValidPassword ? null : 'Invalid password format';
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              LoginButton(
                                onPressed: isLoginButtonEnabled(loginState) ?
                                _onLoginEmailAndPassword : null,
                              ),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              GoogleLoginButton(),
                              Padding(padding: EdgeInsets.only(top: 10)),
                              //Thêm nút để đăng kí tài khoản
                              RegisterUserButton(userRepository: _userRepository)
                            ],
                          ),
                        ),

                      ],
                    )
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onLoginEmailAndPassword(){
    _loginBloc.add(LogInEventWithEmailAndPasswordPressed(
        email: _emailController.text,
        password: _passwordController.text));
  }
}