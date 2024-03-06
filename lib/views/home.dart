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
    return const Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Row(
          children: <Widget>[
            Expanded(child: UsersList()),
            SizedBox(width: 20),
            SideMenu(),
          ],
        ),
      ),
    );
  }
}
