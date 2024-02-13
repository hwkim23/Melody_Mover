import 'package:flutter/material.dart';
import 'package:melody_mover/pages/notifications.dart';
import 'package:melody_mover/store.dart';
import 'package:provider/provider.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;

  const BaseAppBar({Key? key, required this.appBar})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Notifications()));
          },
          icon: context.watch<Store1>().hasUnread
            //TODO: Change icon
            ? const Icon(Icons.notification_add)
            : const Icon(Icons.notifications, color: Colors.grey)),
        //TODO: Change to round user image button
        IconButton(
            onPressed: () {
              //TODO: Account function
            },
            icon: const Icon(Icons.account_circle)),
      ]
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
