import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sql_admin/utils/shared.dart';

import '../../../utils/callbacks.dart';

class GlobalSettings extends StatefulWidget {
  const GlobalSettings({super.key});
  @override
  State<GlobalSettings> createState() => _EditUserState();
}

class _EditUserState extends State<GlobalSettings> {
  final GlobalKey<State> _passKey = GlobalKey<State>();
  bool _buttonState = false;

  final List<Map<String, dynamic>> _settingsControllers = List<Map<String, dynamic>>.generate(
    7,
    (int index) => <String, dynamic>{
      "hint": "Setting ${index + 1}",
      "controller": TextEditingController(),
    },
  );

  Future<void> _addUser() async {
    _buttonState = false;

    if (_settingsControllers.every((Map<String, dynamic> element) => element["controller"].text.isEmpty)) {
      showToast("Please fill all the settings fields", redColor);
    } else {
      _buttonState = true;
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    for (final Map<String, dynamic> item in _settingsControllers) {
      item["controller"].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: AnimatedLoadingBorder(
          borderWidth: 4,
          borderColor: purpleColor,
          child: Container(
            color: purpleColor.withOpacity(.3),
            width: MediaQuery.sizeOf(context).width * .7,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Welcome", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: blackColor)),
                Container(width: MediaQuery.sizeOf(context).width, height: .3, color: blackColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                const SizedBox(height: 20),
                for (final Map<String, dynamic> item in _settingsControllers) ...<Widget>[
                  Container(
                    decoration: BoxDecoration(color: blackColor, borderRadius: BorderRadius.circular(3)),
                    child: StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) _) {
                        return TextField(
                          onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                          controller: item["controller"],
                          style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(20),
                            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                            border: InputBorder.none,
                            label: item["hint"],
                            labelStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                            hintText: item["hint"],
                            hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                            prefixIcon: item["controller"].text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                          ),
                          cursorColor: purpleColor,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                StatefulBuilder(
                  key: _passKey,
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IgnorePointer(
                          ignoring: _buttonState,
                          child: AnimatedButton(
                            width: 150,
                            height: 40,
                            text: _buttonState ? "WAIT..." : 'CONTINUE',
                            selectedTextColor: purpleColor.withOpacity(.3),
                            animatedOn: AnimatedOn.onHover,
                            animationDuration: 500.ms,
                            isReverse: true,
                            selectedBackgroundColor: blackColor,
                            backgroundColor: purpleColor,
                            transitionType: TransitionType.TOP_TO_BOTTOM,
                            textStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                            onPress: () async => await _addUser(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        AnimatedOpacity(opacity: _buttonState ? 1 : 0, duration: 300.ms, child: const Icon(FontAwesome.bookmark_solid, color: purpleColor, size: 35)),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
