import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sql_admin/utils/shared.dart';

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
            for (final MapEntry<String, dynamic> item in _settings.entries) ...<Widget>[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: darkColor.withOpacity(.1)),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor.withOpacity(.3)),
                      child: Text(item.key, style: GoogleFonts.itim(fontSize: 16, color: blackColor, fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor.withOpacity(.3)),
                      child: Text(item.value.toString(), style: GoogleFonts.itim(fontSize: 16, color: blackColor, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ).animate().fadeIn(
                    duration: 500.ms,
                    delay: (100 * _settings.keys.toList().indexOf(item.key)).ms,
                  ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}
