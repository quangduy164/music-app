import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/data/repository/user_repository.dart';
import 'package:music_app/data/blocs/authentication_bloc.dart';
import 'package:music_app/data/events/authentication_event.dart';
import 'package:music_app/data/states/authentication_state.dart';
import 'package:music_app/data/blocs/simple_bloc_observer.dart';
import 'package:music_app/data/blocs/login_bloc.dart';
import 'package:music_app/ui/home/admin_home/admin_home_page.dart';
import 'package:music_app/ui/home/user_home/user_home_page.dart';
import 'package:music_app/ui/login/login_page.dart';
import 'package:music_app/ui/splash/splash_page.dart';
import 'package:music_app/ui/theme/theme_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Khởi tạo Firebase
  Bloc.observer = SimpleBlocObserver();
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child){
          return MaterialApp(
            title: 'Music App',
            theme: themeProvider.themeData,
            home: BlocProvider(
              create: (context){
                final authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
                authenticationBloc.add(AuthenticationEventStarted());
                return authenticationBloc;
              },// tương đương => AuthenticationBloc(userRepository: _userRepository)..add(AuthenticationEventStarted());
              child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, authenticationState){
                  if(authenticationState is AuthenticationStateSuccess){
                    if (authenticationState.role == 'admin') {
                      return AdminHomePage(); // Trang chính cho Admin
                    } else {
                      return UserHomePage(); // Trang chính cho User
                    }
                  }
                  else if(authenticationState is AuthenticationStateFailure){
                    return BlocProvider(
                      create: (context) => LoginBloc(userRepository: _userRepository),
                      child: LoginPage(userRepository: _userRepository,
                      ),
                    );
                  }
                  return SplashPage();
                },
              ),
            ),
            debugShowCheckedModeBanner: false,
          );
        }
    );
  }
}
