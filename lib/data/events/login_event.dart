import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable{
  const LoginEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginEmailChanged extends LoginEvent{
  final String email;
  const LoginEmailChanged({required this.email});
  @override
  // TODO: implement props
  List<Object?> get props => [email];
  @override
  String toString() {
    // TODO: implement toString
    return 'LogIn Email Changed: $email';
  }
}
class LoginPasswordChanged extends LoginEvent{
  final String password;
  const LoginPasswordChanged({required this.password});
  @override
  // TODO: implement props
  List<Object?> get props => [password];
  @override
  String toString() {
    // TODO: implement toString
    return 'LogIn Password Changed: $password';
  }
}
//Khi nhấn vào đăng nhập bằng goole
class LogInEventWithGooglePressed extends LoginEvent{}
class LogInEventWithEmailAndPasswordPressed extends LoginEvent{
  final String email;
  final String password;
  const LogInEventWithEmailAndPasswordPressed({
    required this.email,
    required this.password
  });
  @override
  // TODO: implement props
  List<Object?> get props => [email, password];
  @override
  String toString() => 'LogInEventWithEmailAndPasswordPressed, email: $email, password: $password';
}