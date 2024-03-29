import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sql_admin/utils/shared.dart';

import '../../../utils/callbacks.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key, required this.callback});
  final void Function() callback;
  @override
  State<AddUser> createState() => _EditUserState();
}

class _EditUserState extends State<AddUser> {
  bool _passwordState = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _queriesDate = TextEditingController();

  List<Map<String, dynamic>> _queriesControllers = <Map<String, dynamic>>[];

  Future<int> _load() async {
    final response = await Dio().get("$url/totalQuerys");
    if (response.statusCode == 200) {
      return response.data['totalQuerys'];
    }
    return 0;
  }

  Future<void> _addUser() async {
    if (_passwordController.text.isEmpty) {
      showToast(context, "Please enter a correct password", redColor);
    } else if (_usernameController.text.isEmpty) {
      showToast(context, "Please enter a correct username", redColor);
    } else {
      try {
        showToast(context, "Wait...", redColor);
        await Dio().post(
          "$url/createUser",
          data: <String, String>{
            "username": _usernameController.text,
            "password": _passwordController.text,
          },
        );
        await Future.delayed(10.ms);
        await Dio().post(
          '$url/addOrUpdateUserQuerys',
          data: <String, dynamic>{
            'username': _usernameController.text,
            'querys': <String, dynamic>{
              for (final Map<String, dynamic> item in _queriesControllers) _queriesControllers.indexOf(item).toString(): item['controller'].text,
            },
          },
        );
        await Future.delayed(100.ms);
        await Dio().post(
          '$url/queryWithTime',
          data: <String, dynamic>{
            'username': _usernameController.text,
            'newValue': _queriesDate.text,
          },
        );
        // ignore: use_build_context_synchronously
        showToast(context, "USER CREATED", greenColor);
      } catch (e) {
        debugPrint(e.toString());
      }

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      widget.callback();
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    _queriesDate.dispose();
    for (final Map<String, dynamic> item in _queriesControllers) {
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
          borderColor: blueColor,
          child: Container(
            color: blueColor.withOpacity(.3),
            width: MediaQuery.sizeOf(context).width * .7,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("CREATE USER ACCOUNT", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: blackColor)),
                Container(width: MediaQuery.sizeOf(context).width, height: .3, color: blackColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                Container(
                  decoration: BoxDecoration(color: blueColor.withOpacity(.1), borderRadius: BorderRadius.circular(3)),
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return TextField(
                        onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                        controller: _usernameController,
                        style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blackColor),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: blueColor, width: 2, style: BorderStyle.solid)),
                          border: InputBorder.none,
                          hintText: 'Username',
                          hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blackColor),
                          prefixIcon: _usernameController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                        ),
                        cursorColor: blueColor,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(color: blueColor.withOpacity(.1), borderRadius: BorderRadius.circular(3)),
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return TextField(
                        obscureText: !_passwordState,
                        onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                        controller: _passwordController,
                        style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blackColor),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: blueColor, width: 2, style: BorderStyle.solid)),
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blackColor),
                          prefixIcon: _passwordController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                          suffixIcon: IconButton(onPressed: () => _(() => _passwordState = !_passwordState), icon: Icon(_passwordState ? FontAwesome.eye_solid : FontAwesome.eye_slash_solid, size: 15, color: blueColor)),
                        ),
                        cursorColor: blueColor,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                FutureBuilder<int>(
                  future: _load(),
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.hasData) {
                      _queriesControllers = List<Map<String, dynamic>>.generate(
                        snapshot.data!,
                        (int index) => <String, dynamic>{
                          "hint": "Query ${index + 1}",
                          "controller": TextEditingController(),
                        },
                      );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          for (final Map<String, dynamic> item in _queriesControllers) ...<Widget>[
                            Container(
                              decoration: BoxDecoration(color: blueColor.withOpacity(.1), borderRadius: BorderRadius.circular(3)),
                              child: StatefulBuilder(
                                builder: (BuildContext context, void Function(void Function()) _) {
                                  return TextField(
                                    onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                                    controller: item["controller"],
                                    style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blackColor),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(20),
                                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: blueColor, width: 2, style: BorderStyle.solid)),
                                      border: InputBorder.none,
                                      hintText: item["hint"],
                                      hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blackColor),
                                      prefixIcon: item["controller"].text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                                    ),
                                    cursorColor: blueColor,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
                Container(
                  decoration: BoxDecoration(color: blueColor.withOpacity(.1), borderRadius: BorderRadius.circular(3)),
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return TextField(
                        onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                        controller: _queriesDate,
                        style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blackColor),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: blueColor, width: 2, style: BorderStyle.solid)),
                          border: InputBorder.none,
                          hintText: 'Date Query',
                          hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blackColor),
                          prefixIcon: _queriesDate.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                        ),
                        cursorColor: blueColor,
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
                      onTap: () async => await _addUser(),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blueColor),
                        padding: const EdgeInsets.all(16),
                        child: Text('CREATE USER', style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      splashColor: transparentColor,
                      hoverColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: lightBlue),
                        padding: const EdgeInsets.all(16),
                        child: Text('CANCEL', style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
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
