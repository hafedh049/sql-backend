import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sql_admin/utils/shared.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => UsersListState();
}

class UsersListState extends State<UsersList> {
  final List<Map<String, dynamic>> _users = List<Map<String, dynamic>>.generate(
    100,
    (int index) => <String, dynamic>{
      "Username": "Username$index",
      "Password": "Password$index",
    },
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blackColor.withOpacity(.1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor.withOpacity(.3)),
                    child: Text(_users[index]["Username"], style: GoogleFonts.itim(fontSize: 16, color: blackColor, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: purpleColor.withOpacity(.3)),
                    child: Text(_users[index]["Password"], style: GoogleFonts.itim(fontSize: 16, color: blackColor, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 500.ms, delay: (50 * index).ms),
        separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
        itemCount: _users.length,
      ),
    );
  }
}
