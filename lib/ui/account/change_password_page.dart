import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget{
  const ChangePasswordPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordPageState();
  }
}

class _ChangePasswordPageState extends State<ChangePasswordPage>{
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _showLoading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Music App'),
      ),
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    TextField(
                      controller: _oldPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.key_off, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(vertical: 13),//Chiều cao thanh
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 2.0,
                          ),
                        ),
                        hintText: 'Nhập mật khẩu cũ...',
                      ),
                    ),
                    const SizedBox(height: 10,),
                    TextField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.key, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(vertical: 13),//Chiều cao thanh
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 2.0,
                          ),
                        ),
                        hintText: 'Nhập mật khẩu mới...',
                      ),
                    ),
                    const SizedBox(height: 10,),
                    _showLoading ? CircularProgressIndicator() :
                    ElevatedButton(
                        onPressed: _changePassword,
                        child: Text('Đổi mật khẩu', style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        )
    );
  }

  Future<void> _changePassword() async {
    setState(() {
      _showLoading = true;
    });

    try {
      // Lấy người dùng hiện tại
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Xác thực mật khẩu cũ
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _oldPasswordController.text.trim(),
        );
        // Xác thực lại
        await user.reauthenticateWithCredential(credential);
        // Change the password
        await user.updatePassword(_newPasswordController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đổi mật khẩu thành công')),
        );
        Navigator.pop(context);
      }
    }
    catch (error) {
      String errorMessage = 'Mật khẩu không hợp lệ';
      if (error is FirebaseAuthException) {
        if (error.code == 'wrong-password') {
          errorMessage = 'Mật khẩu cũ không chính xác';
        } else if (error.code == 'weak-password') {
          errorMessage = 'Mật khẩu mới quá yếu';
        } else if (error.code == 'requires-recent-login') {
          errorMessage = 'Cần đăng nhập lại để thay đổi mật khẩu';
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _showLoading = false;
      });
    }
  }
}