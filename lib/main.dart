import 'package:flutter/material.dart';
import 'package:sql_admin/views/holder.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: Holder());
  }
}
