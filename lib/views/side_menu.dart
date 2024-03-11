import 'package:flutter/material.dart';
import 'package:sql_admin/views/add_user.dart';

import '../utils/shared.dart';
import 'global_settings.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key, required this.callback});
  final void Function() callback;
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: whiteColor.withOpacity(.3), borderRadius: BorderRadius.circular(15)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              splashColor: transparentColor,
              hoverColor: transparentColor,
              highlightColor: transparentColor,
              onTap: () => showDialog(context: context, builder: (BuildContext context) => AlertDialog(content: AddUser(callback: widget.callback))),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                padding: const EdgeInsets.all(16),
                child: const Text('ADD USER'),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              splashColor: transparentColor,
              hoverColor: transparentColor,
              highlightColor: transparentColor,
              onTap: () => showDialog(context: context, builder: (BuildContext context) => AlertDialog(content: GlobalSettings(callback: widget.callback))),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                padding: const EdgeInsets.all(16),
                child: const Text("GLOBAL SETTINGS"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
