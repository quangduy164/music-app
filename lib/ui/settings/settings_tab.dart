import 'package:flutter/material.dart';
import 'package:music_app/ui/theme/theme.dart';
import 'package:music_app/ui/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsTab extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SettingsTabState();
  }
}

class _SettingsTabState extends State<SettingsTab>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 8, top: 10, bottom: 5),
              child: Row(
                children: [
                  const Text('Chế độ ban đêm', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 150,),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child){
                      return Switch(
                          value: themeProvider.themeData == darkMode,
                          onChanged: (value){
                            themeProvider.toggleTheme();
                          }
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}