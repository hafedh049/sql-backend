import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sql_admin/utils/shared.dart';

import '../../models/user_model.dart';
import '../../views/edit_user.dart';

class RestorableUserSelections extends RestorableProperty<Set<int>> {
  Set<int> _userSelections = <int>{};

  @override
  Set<int> createDefaultValue() => _userSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _userSelections = <int>{...selectedItemIndices.map<int>((dynamic id) => id as int)};
    return _userSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _userSelections = value;
  }

  @override
  Object toPrimitives() => _userSelections.toList();
}

class UsersDataSource extends DataTableSource {
  UsersDataSource.empty(this.context) {
    users = <UserModel>[];
  }

  UsersDataSource(this.context, this.users, this.callback);
  void Function() callback = () {};
  final BuildContext context;
  late List<UserModel> users;
  final bool hasRowTaps = false;
  final bool hasRowHeightOverrides = true;
  final bool hasZebraStripes = true;

  @override
  DataRow2 getRow(int index, [Color? color]) {
    assert(index >= 0);
    if (index >= users.length) throw 'index > _products.length';
    final UserModel user = users[index];
    return DataRow2.byIndex(
      index: index,
      color: color != null ? MaterialStateProperty.all(color) : (hasZebraStripes && index.isEven ? MaterialStateProperty.all(Theme.of(context).highlightColor) : null),
      cells: <DataCell>[
        DataCell(
          Text(user.uid, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blackColor)),
          onTap: () => showDialog(context: context, builder: (BuildContext context) => AlertDialog(content: EditUser(user: user))).then((void value) => callback()),
        ),
        DataCell(
          Text(user.username, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blackColor)),
          onTap: () => showDialog(context: context, builder: (BuildContext context) => AlertDialog(content: EditUser(user: user))).then((void value) => callback()),
        ),
        DataCell(
          Text(user.password, style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: blackColor)),
          onTap: () => showDialog(context: context, builder: (BuildContext context) => AlertDialog(content: EditUser(user: user))).then((void value) => callback()),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: user.authorized ? greenColor : redColor, borderRadius: BorderRadius.circular(5)),
            child: Text(user.authorized ? "AUTHORIZED" : "UNAUTHORIZED", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: whiteColor)),
          ),
          onTap: () async {
            await Dio().post("$url/authorization", data: <String, String>{"username": user.username}).then(
              (Response value) {
                user.authorized = value.data["data"]['authorized'];
                callback();
              },
            );
          },
        ),
      ],
    );
  }

  @override
  int get rowCount => users.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
