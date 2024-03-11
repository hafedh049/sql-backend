import 'package:animated_loading_border/animated_loading_border.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sql_admin/models/user_model.dart';
import 'package:sql_admin/utils/shared.dart';

import '../utils/callbacks.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key, required this.user});
  final UserModel user;
  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  bool _passwordState = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _queriesDate = TextEditingController();

  List<Map<String, dynamic>> _queriesControllers = <Map<String, dynamic>>[];

  @override
  void initState() {
    _usernameController.text = widget.user.username;
    _passwordController.text = widget.user.password;
    _queriesDate.text = widget.user.queryWithDate;
    super.initState();
  }

  Future<void> _updateUser() async {
    if (_passwordController.text.isEmpty) {
      showToast("Please enter a correct password", redColor);
    } else if (_usernameController.text.isEmpty) {
      showToast("Please enter a correct username", redColor);
    } else {
      await Dio().post(
        '$url/addOrUpdateUserQuerys',
        data: <String, dynamic>{
          'username': widget.user.username,
          'querys': <String, dynamic>{
            for (final Map<String, dynamic> item in _queriesControllers) _queriesControllers.indexOf(item).toString(): item['controller'].text,
          },
        },
      );
      await Future.delayed(100.ms);
      await Dio().post(
        '$url/queryWithTime',
        data: <String, dynamic>{
          'username': widget.user.username,
          'newValue': _queriesDate.text,
        },
      );
      showToast("User Edited", greenColor);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
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

  Future<int> _load() async {
    final response = await Dio().get("$url/totalQuerys");
    if (response.statusCode == 200) {
      return response.data['totalQuerys'];
    }
    return 0;
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
                Row(
                  children: <Widget>[
                    Text("EDIT USER ACCOUNT", style: GoogleFonts.itim(fontSize: 22, fontWeight: FontWeight.w500, color: blackColor)),
                    const Spacer(),
                    InkWell(
                      splashColor: transparentColor,
                      hoverColor: transparentColor,
                      highlightColor: transparentColor,
                      onTap: () async {
                        await Dio().post('$url/removeUser', data: <String, String>{'username': widget.user.username});
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                        padding: const EdgeInsets.all(16),
                        child: const Text('DELETE USER'),
                      ),
                    ),
                  ],
                ),
                Container(width: MediaQuery.sizeOf(context).width, height: .3, color: blackColor, margin: const EdgeInsets.symmetric(vertical: 20)),
                Container(
                  decoration: BoxDecoration(color: blackColor, borderRadius: BorderRadius.circular(3)),
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return TextField(
                        onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                        controller: _usernameController,
                        style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                          border: InputBorder.none,
                          hintText: 'Username',
                          hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                          prefixIcon: _usernameController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                        ),
                        cursorColor: purpleColor,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(color: blackColor, borderRadius: BorderRadius.circular(3)),
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return TextField(
                        obscureText: !_passwordState,
                        onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                        controller: _passwordController,
                        style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                          prefixIcon: _passwordController.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
                          suffixIcon: IconButton(onPressed: () => _(() => _passwordState = !_passwordState), icon: Icon(_passwordState ? FontAwesome.eye_solid : FontAwesome.eye_slash_solid, size: 15, color: purpleColor)),
                        ),
                        cursorColor: purpleColor,
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
                      for (final MapEntry<String, dynamic> itm in widget.user.queries.entries) {
                        _queriesControllers[int.parse(itm.key)]["controller"].text = itm.value;
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          for (final Map<String, dynamic> item in _queriesControllers) ...<Widget>[
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
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
                Container(
                  decoration: BoxDecoration(color: blackColor, borderRadius: BorderRadius.circular(3)),
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return TextField(
                        onChanged: (String value) => value.trim().length <= 1 ? _(() {}) : null,
                        controller: _queriesDate,
                        style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: purpleColor, width: 2, style: BorderStyle.solid)),
                          border: InputBorder.none,
                          hintText: 'Date Query',
                          hintStyle: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor),
                          prefixIcon: _queriesDate.text.trim().isEmpty ? null : const Icon(FontAwesome.circle_check_solid, size: 15, color: greenColor),
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
                      onTap: () async => await _updateUser(),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor),
                        padding: const EdgeInsets.all(16),
                        child: const Text('SAVE DATA'),
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
