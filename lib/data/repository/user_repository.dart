import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  // Constructor
  UserRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firestore = firestore ?? FirebaseFirestore.instance;
  //Đăng nhập bằng google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      // The user canceled the sign-in
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

    // Lưu thông tin người dùng vào Firestore
    await _saveUserToFirestore(userCredential.user);

    return userCredential;
  }

  // Đăng nhập với email và mật khẩu
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    // Lưu thông tin người dùng vào Firestore
    await _saveUserToFirestore(userCredential.user);

    return userCredential;
  }

  // Tạo tài khoản mới với email và mật khẩu
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    // Lưu thông tin người dùng vào Firestore với vai trò mặc định là 'user'
    await _saveUserToFirestore(userCredential.user, role: 'user');

    return userCredential;
  }

  // Đăng xuất khỏi tài khoản
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // Kiểm tra xem người dùng đã đăng nhập hay chưa
  Future<bool> isSignIn() async {
    return _firebaseAuth.currentUser != null;
  }

  Future<User?> getUser() async {
    return _firebaseAuth.currentUser;
  }

  // Lưu thông tin người dùng vào Firestore
  Future<void> _saveUserToFirestore(User? user, {String role = 'user'}) async {
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        // Nếu người dùng chưa tồn tại trong Firestore, lưu vai trò mặc định là 'user'
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'role': role,
          'favoriteSongs': [],
          'photoURL': null
        });
      }
    }
  }

  // Lấy vai trò người dùng
  Future<String?> getUserRole() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      return doc['role'] as String?;
    }
    return null;
  }

  // Kiểm tra xem người dùng hiện tại có phải là admin không
  Future<bool> isAdmin() async {
    String? role = await getUserRole();
    return role == 'admin';
  }



  // Lấy email của người dùng hiện tại
  Future<String?> getUserEmail() async {
    User? user = _firebaseAuth.currentUser;
    return user?.email;
  }
  // Lấy photoURL của người dùng hiện tại
  Future<String?> getUserPhotoURL() async {
    User? user = _firebaseAuth.currentUser;
    return user?.photoURL;
  }

}