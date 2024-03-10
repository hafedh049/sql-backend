import 'package:flutter/material.dart';
import 'package:sql_admin/utils/shared.dart';

import 'side_menu.dart';
import 'users_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: <Widget>[
            const Expanded(child: UsersList()),
            const SizedBox(width: 20),
            SideMenu(callback: setState),
          ],
        ),
      ),
    );
  }
}
