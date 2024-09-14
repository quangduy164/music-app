import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/ui/account/account_tab.dart';
import 'package:music_app/ui/discovery/discovery_tab.dart';
import 'package:music_app/ui/home/user_home/home_tab.dart';
import 'package:music_app/ui/settings/settings_tab.dart';

class UserHomePage extends StatefulWidget{
  const UserHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserHomePageState();
  }
}

class _UserHomePageState extends State<UserHomePage>{
  final List<Widget> _tabs = [
    const HomeTab(),
    const DiscoveryTab(),
    const AccountTab(),
    SettingsTab()
  ];
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;//Kiểm tra chiều cao bàn phím
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Music App'),
      ),
      child: CupertinoTabScaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        tabBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.album), label: 'Discovery'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
          height: bottomInset > 0 ? 0 : kBottomNavigationBarHeight,//Nếu bàn phím xuất hiện thì ẩn tabbottom
        ),
        tabBuilder: (BuildContext context, int index){
          return _tabs[index];
        },
      ),
    );
  }

}