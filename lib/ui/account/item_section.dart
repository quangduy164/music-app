import 'package:flutter/material.dart';

class ItemSection extends StatefulWidget {
  final Function? function;
  final IconData icon;
  final String text;

  const ItemSection(
      {super.key,
      required this.function,
      required this.icon,
      required this.text});

  @override
  State<StatefulWidget> createState() {
    return _ItemSectionState();
  }
}

class _ItemSectionState extends State<ItemSection> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.only(left: 24, right: 8, top: 10, bottom: 5),
      leading: Icon(
        widget.icon,
        color: Theme.of(context).colorScheme.primary,
        size: 20,
      ),
      title: Text(
        widget.text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      onTap: (){
        if(widget.function != null){
          widget.function!();
        }
      },
    );
  }
}
