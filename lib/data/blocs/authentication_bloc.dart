import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/data/events/authentication_event.dart';
import 'package:music_app/data/states/authentication_state.dart';
import 'package:music_app/data/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthenticationStateInitial()) {
    on<AuthenticationEventStarted>(_onAuthenticationStarted);
    on<AuthenticationEventLoggedIn>(_onAuthenticationLoggedIn);
    on<AuthenticationEventLoggedOut>(_onAuthenticationLoggedOut);
  }

  // Xử lý sự kiện khi ứng dụng khởi động
  Future<void> _onAuthenticationStarted(
      AuthenticationEventStarted event, Emitter<AuthenticationState> emit) async {
    final isSignedIn = await _userRepository.isSignIn();
    if (isSignedIn) {
      final user = await _userRepository.getUser();
      final role = await _fetchUserRole(user!.uid); // Lấy vai trò người dùng từ Firestore
      emit(AuthenticationStateSuccess(firebaseUser: user, role: role));
    } else {
      emit(AuthenticationStateFailure());
    }
  }

  // Xử lý sự kiện khi người dùng đăng nhập thành công
  Future<void> _onAuthenticationLoggedIn(
      AuthenticationEventLoggedIn event, Emitter<AuthenticationState> emit) async {
    final user = await _userRepository.getUser();
    final role = await _fetchUserRole(user!.uid); // Lấy vai trò người dùng từ Firestore
    emit(AuthenticationStateSuccess(firebaseUser: user, role: role));
  }

  // Xử lý sự kiện khi người dùng đăng xuất
  Future<void> _onAuthenticationLoggedOut(
      AuthenticationEventLoggedOut event, Emitter<AuthenticationState> emit) async {
    await _userRepository.signOut();
    emit(AuthenticationStateFailure());
  }

  // Lấy vai trò người dùng từ Firestore
  Future<String> _fetchUserRole(String uid) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.data()?['role'] ?? 'user'; // Vai trò mặc định là 'user'
  }
}
