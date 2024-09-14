import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/ui/account/account_tab.dart';
import 'package:music_app/ui/home/admin_home/admin_home_tab.dart';


class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminHomePageState();
  }
}

class _AdminHomePageState extends State<AdminHomePage>{
  final List<Widget> _tabs = [
    const AdminHomeTab(),
    const AccountTab(),
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
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
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