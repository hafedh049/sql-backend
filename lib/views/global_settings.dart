import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sql_admin/utils/shared.dart';

import '../../../utils/callbacks.dart';

class GlobalSettings extends StatefulWidget {
  const GlobalSettings({super.key, required this.callback});
  final void Function() callback;
  @override
  State<GlobalSettings> createState() => _EditUserState();
}

class _EditUserState extends State<GlobalSettings> {
  final TextEditingController _globalQueries = TextEditingController();

  Future<void> _settings() async {
    if (_globalQueries.text.isEmpty) {
      showToast("Please fill all the settings fields", redColor);
    } else {
      try {
        await Dio().post("$url/totalQuerys", data: <String, dynamic>{"totalQuerys": int.parse(_globalQueries.text)});
        showToast("SETTINGS UPDATED", greenColor);
      } catch (e) {
        debugPrint(e.toString());
      }
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      widget.callback();
    }
  }

  @override
  void initState() {
    Dio().get("$url/totalQuerys").then((Response value) => _globalQueries.text = value.data["totalQuerys"].toString());
    super.initState();
  }

  @override
  void dispose() {
    _globalQueries.dispose();
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
                Text("Global Settings", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: blackColor)),
                Container(width: MediaQuery.sizeOf(context).width, height: .3, color: blackColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(color: blackColor, borderRadius: BorderRadius.circular(3)),
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return TextField(
                        onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                        controller: _globalQueries,
                        style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                        inputFormatters: [LengthLimitingTextInputFormatter(2), FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                          border: InputBorder.none,
                          labelText: "Queries Number",
                          labelStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                          hintText: "Queries Number",
                          hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                          prefixIcon: _globalQueries.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                        ),
                        cursorColor: purpleColor,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    InkWell(
                      splashColor: transparentColor,
                      hoverColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () async => await _settings(),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                        padding: const EdgeInsets.all(16),
                        child: const Text('SAVE SETTINGS'),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      splashColor: transparentColor,
                      hoverColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: redColor),
                        padding: const EdgeInsets.all(16),
                        child: const Text('CANCEL'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
