import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sql_admin/models/user_model.dart';
import '../utils/helpers/data_sources.dart';
import '../utils/shared.dart';
import 'side_menu.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => UsersListState();
}

class UsersListState extends State<UsersList> with RestorationMixin {
  final RestorableUserSelections _productSelections = RestorableUserSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage = RestorableInt(PaginatedDataTable.defaultRowsPerPage + 10);
  late UsersDataSource _productsDataSource;
  bool _initialized = false;
  final List<String> _columns = const <String>["UID", "USERNAME", "PASSWORD", "AUTHORITY"];
  final GlobalKey<State> _pagerKey = GlobalKey<State>();
  List<UserModel> _products = <UserModel>[];

  @override
  String get restorationId => 'paginated_product_table';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_productSelections, 'selected_row_indices');
    registerForRestoration(_rowIndex, 'current_row_index');
    registerForRestoration(_rowsPerPage, 'rows_per_page');

    if (!_initialized) {
      _productsDataSource = UsersDataSource(context, _products, () => setState(() {}));
      _initialized = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _productsDataSource = UsersDataSource(context, _products, () => setState(() {}));
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _rowsPerPage.dispose();
    _productsDataSource.dispose();
    super.dispose();
  }

  Future<List<UserModel>> _loadUsers() async {
    try {
      return (((await Dio().get("$url/getUsersList")).data)["users"] as Map<String, dynamic>)
          .entries
          .map(
            (MapEntry<String, dynamic> e) => UserModel.fromJson(
              <String, dynamic>{
                'uid': e.value["id"],
                'username': e.key,
                'password': e.value["password"],
                'authorized': e.value["authorized"],
                'queries': e.value["querys"],
                'queryWithDate': e.value["queryWithDate"],
              },
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Row(
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<UserModel>>(
              future: _loadUsers(),
              builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
                if (snapshot.hasData) {
                  _products = snapshot.data!;
                  _productsDataSource = UsersDataSource(context, _products, () => setState(() {}));
                  return ListView(
                    restorationId: restorationId,
                    children: <Widget>[
                      StatefulBuilder(
                        key: _pagerKey,
                        builder: (BuildContext context, void Function(void Function()) _) {
                          return PaginatedDataTable(
                            availableRowsPerPage: const <int>[20, 30],
                            arrowHeadColor: purpleColor,
                            rowsPerPage: _rowsPerPage.value,
                            onRowsPerPageChanged: (int? value) => _(() => _rowsPerPage.value = value!),
                            initialFirstRowIndex: _rowIndex.value,
                            onPageChanged: (int rowIndex) => _(() => _rowIndex.value = rowIndex),
                            columns: <DataColumn>[for (final String column in _columns) DataColumn(label: Text(column))],
                            source: _productsDataSource,
                          );
                        },
                      ),
                    ],
                  );
                }
                return snapshot.connectionState == ConnectionState.waiting ? const Center(child: CircularProgressIndicator(color: purpleColor)) : Center(child: Text(snapshot.error.toString()));
              },
            ),
          ),
          const SizedBox(width: 20),
          const SizedBox(width: 20),
          SideMenu(callback: () => setState(() {})),
        ],
      ),
    );
  }
}
