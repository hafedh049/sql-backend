import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (final MapEntry<String, dynamic> item in _settings.entries)
              Container(
                padding: const EdgeInsets.all(16),
              ).animate().fadeIn(
                    duration: 500.ms,
                    delay: (100 * _settings.keys.toList().indexOf(item.key)).ms,
                  ),
          ],
        ),
      ),
    );
  }
}
