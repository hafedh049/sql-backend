import 'package:flutter/material.dart';
import 'package:sql_admin/models/products_model.dart';
import '../utils/helpers/data_sources.dart';
import '../utils/shared.dart';

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
  final List<String> _columns = const <String>["UID", "USERNAME", "PASSWORD"];
  final GlobalKey<State> _pagerKey = GlobalKey<State>();
  final List<UserModel> _products = <UserModel>[for (int index = 0; index < 1000; index++) UserModel("1V$index", "2V$index", "3V$index")];

  @override
  String get restorationId => 'paginated_product_table';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_productSelections, 'selected_row_indices');
    registerForRestoration(_rowIndex, 'current_row_index');
    registerForRestoration(_rowsPerPage, 'rows_per_page');

    if (!_initialized) {
      _productsDataSource = UsersDataSource(context, _products);
      _initialized = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _productsDataSource = UsersDataSource(context, _products);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _rowsPerPage.dispose();
    _productsDataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
}
