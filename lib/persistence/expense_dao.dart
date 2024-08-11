import 'package:flutter_trabalho2_opta1/commons.dart';

class ExpenseDao extends ChangeNotifier {
  static const String jsonKeyPreference = 'EXPENSE_LIST';
  List<ExpenseModel> _expenseList = [];
  List<ExpenseModel> get expenseList => _expenseList;
  int _idCounter = 0;

  ExpenseDao() {
    loadExpenses();
  }


//PERSISTENCE
  Future<void> loadExpenses() async {
    try {
      final preference = await SharedPreferences.getInstance();
      final String? jsonString = preference.getString(jsonKeyPreference);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(jsonString);
        _expenseList = jsonList.map((jsonItem) => ExpenseModel.fromJson(jsonItem)).toList();
        _idCounter = _expenseList.length;
        notifyListeners();
      }
    } catch (e) {
      showSnackbar(context: context, label: AppLabels.errorLoading);
    }
  }

  Future<void> saveExpenses() async {
    try {
      final preference = await SharedPreferences.getInstance();
      final String jsonString = jsonEncode(_expenseList.map((e) => e.toJson()).toList());
      await preference.setString(jsonKeyPreference , jsonString);
    } catch (e) {
      showSnackbar(context: context, label: AppLabels.errorSaving);
    }
  }


//METODHS
  void addExpense(ExpenseModel expense) {
    expense.id = _idCounter;
    _expenseList.add(expense);
    _idCounter++;
    saveExpenses();
    notifyListeners();
  }

void updateExpense(int id, ExpenseModel newExpense) async {
  try {
    final index = _expenseList.indexWhere((expense) => expense.id == id);
    if (index != -1) {
      newExpense.id = id;
      _expenseList[index] = newExpense;
      await saveExpenses();
      notifyListeners();
    } else {
      showSnackbar(context: context, label: AppLabels.errorUpdating);
    }
  } catch (e) {
    showSnackbar(context: context, label: AppLabels.errorSaving);
  }
}

  void deleteExpense(int id) {
    _expenseList.removeWhere((expense) => expense.id == id);
    saveExpenses();
    notifyListeners();
  }

  static void addExpenseStatic(BuildContext context, ExpenseModel expense) {
    final expenseDao= Provider.of<ExpenseDao>(context, listen: false);
    expenseDao.addExpense(expense);
  }

  static void updateExpenseStatic(BuildContext context, int id, ExpenseModel newExpense) {
    final expenseDao = Provider.of<ExpenseDao>(context, listen: false);
    expenseDao.updateExpense(id, newExpense);
  }

  static void deleteExpenseStatic(BuildContext context, int id) {
    final expenseDao = Provider.of<ExpenseDao>(context, listen: false);
    expenseDao.deleteExpense(id);
  }

}
