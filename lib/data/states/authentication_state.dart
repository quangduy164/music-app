import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationStateInitial extends AuthenticationState {}

class AuthenticationStateSuccess extends AuthenticationState {
  final User firebaseUser;
  final String role; // Thêm thuộc tính role

  const AuthenticationStateSuccess({required this.firebaseUser, required this.role});

  @override
  List<Object?> get props => [firebaseUser, role];

  @override
  String toString() => 'AuthenticationStateSuccess { firebaseUser: ${firebaseUser.email}, role: $role }';
}

class AuthenticationStateFailure extends AuthenticationState {}
