import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sql_admin/utils/shared.dart';
import 'package:sql_admin/views/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  url = jsonDecode(await rootBundle.loadString('assets/config/config.json'))['url'];
  print(await Dio().get('http://localhost/phpmyadmin/index.php?route=/table/sql&db=test&table=usr'));
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Home(),
      theme: ThemeData.dark(),
    );
  }
}
