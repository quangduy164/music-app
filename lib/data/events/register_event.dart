import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable{
  const RegisterEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RegisterEmailChanged extends RegisterEvent{
  final String email;
  const RegisterEmailChanged({required this.email});
  @override
  // TODO: implement props
  List<Object?> get props => [email];
  @override
  String toString() {
    // TODO: implement toString
    return 'Register Email Changed: $email';
  }
}
class RegisterPasswordChanged extends RegisterEvent{
  final String password;
  const RegisterPasswordChanged({required this.password});
  @override
  // TODO: implement props
  List<Object?> get props => [password];
  @override
  String toString() {
    // TODO: implement toString
    return 'Register Password Changed: $password';
  }
}
//Khi nhấn vào đăng nhập bằng goole
class RegisterEventWithGoogleChanged extends RegisterEvent{}
class RegisterEventWithEmailAndPasswordPressed extends RegisterEvent{
  final String email;
  final String password;
  const RegisterEventWithEmailAndPasswordPressed({
    required this.email,
    required this.password
  });
  @override
  // TODO: implement props
  List<Object?> get props => [email, password];
  @override
  String toString() => 'RegisterEventWithEmailAndPasswordPressed, email: $email, password: $password';
}