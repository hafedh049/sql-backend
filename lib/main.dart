import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sql_admin/utils/shared.dart';
import 'package:sql_admin/views/users_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  url = jsonDecode(await rootBundle.loadString('assets/config/config.json'))['url'];
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const UsersList(),
      theme: ThemeData.dark(),
    );
  }
}
