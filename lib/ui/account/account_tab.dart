import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_app/data/blocs/authentication_bloc.dart';
import 'package:music_app/data/events/authentication_event.dart';
import 'package:music_app/data/repository/user_repository.dart';
import 'package:music_app/ui/account/change_password_page.dart';
import 'package:music_app/ui/account/item_section.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AccountTabState();
  }
}

class _AccountTabState extends State<AccountTab> {
  String? _userEmail;
  String? _userPhotoURL;
  bool _showLoading = true;

  @override
  void initState() {
    _loadUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Ảnh và tên email
          title: _showLoading
              ? const CircularProgressIndicator()
              : Row(
                  children: [
                    _userPhotoURL != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(_userPhotoURL!),
                          )
                        : const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/user_avata.png'),
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '$_userEmail',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Column(
        children: [
          ItemSection(
              function: (){
                Navigator.of(context).push(CupertinoPageRoute(builder: (context){
                  return ChangePasswordPage();
                }));
              },
              icon: Icons.key,
              text: 'Đổi mật khẩu'),
          const Padding(
            padding: EdgeInsets.only(left: 9, right: 9),
            child: Divider(height: 1, color: Colors.grey),
          ),
          ItemSection(
              function: (){
                BlocProvider.of<AuthenticationBloc>(context).
                add(AuthenticationEventLoggedOut());
              },
              icon: Icons.logout,
              text: 'Đăng xuất')
        ],
      )
    );
  }

  Future<void> _loadUserProfile() async {
    final email = await UserRepository().getUserEmail();
    final photoURL = await UserRepository().getUserPhotoURL();
    setState(() {
      _userEmail = email;
      _userPhotoURL = photoURL;
      _showLoading = false;
    });
  }
}
