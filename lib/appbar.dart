import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;

  const BaseAppBar({Key? key, required this.appBar})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          //TODO: Menu function
        },
        icon: const Icon(Icons.menu, color: Colors.black)
      ),
      actions: [
        IconButton(
          onPressed: () {
            //TODO: Search function
          },
          icon: const Icon(Icons.search, color: Colors.black)),
        //TODO: Change to round user image button
        IconButton(
            onPressed: () {
              //TODO: Account function
            },
            icon: const Icon(Icons.account_circle, color: Colors.black)),
      ]
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
