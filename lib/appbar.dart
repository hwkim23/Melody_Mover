import 'package:flutter/material.dart';
import 'package:melody_mover/pages/notifications.dart';
import 'package:melody_mover/pages/profile.dart';
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
        SizedBox(
          height: 50,
          width: 50,
          child: Stack(
            children: [
              Center(
                child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Notifications()));
                    },
                    icon: const Icon(Icons.notifications, color: Colors.grey)),
              ),
              Visibility(
                //visible: ,
                child: Positioned(
                  top: 13,
                  right: 13,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: const Color(0xffF06543),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.transparent)
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        context.watch<Store1>().profileURL.isEmpty ? IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
          },
          icon: const Icon(Icons.account_circle, size: 50,)
        ) : GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
          },
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25, // Image radius
            backgroundImage: NetworkImage(context.watch<Store1>().profileURL),
          ),
        ),
      ]
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
