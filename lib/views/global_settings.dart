import 'package:flutter/material.dart';

class GlobalSettings extends StatefulWidget {
  const GlobalSettings({super.key});

  @override
  State<GlobalSettings> createState() => _GlobalSettingsState();
}

class _GlobalSettingsState extends State<GlobalSettings> {
  final Map<String, dynamic> _settings = <String, dynamic>{"Queries number": 10};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[for(final MapEntry<String,dynamic> item in _settings.entries),],
        ),
      ),
    );
  }
}
