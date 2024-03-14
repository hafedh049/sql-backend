import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      alignment: Alignment.center,
      decoration: BoxDecoration(color: blackColor.withOpacity(.3), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset("assets/images/logo.png", scale: 6),
          const SizedBox(height: 20),
          InkWell(
            splashColor: transparentColor,
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            onTap: () => showDialog(context: context, builder: (BuildContext context) => AlertDialog(content: AddUser(callback: widget.callback))),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blueColor),
              padding: const EdgeInsets.all(16),
              child: Text('ADD USER', style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            splashColor: transparentColor,
            hoverColor: transparentColor,
            highlightColor: transparentColor,
            onTap: () => showDialog(context: context, builder: (BuildContext context) => AlertDialog(content: GlobalSettings(callback: widget.callback))),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blueColor),
              padding: const EdgeInsets.all(16),
              child: Text("GLOBAL SETTINGS", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
            ),
          ),
        ],
      ),
    );
  }
}
