// ! It's a bad way to implement the SNACKBAR..
// ! Not recommend use 'BuildContext's across async gaps..
// ! But will work for now.. 
// ignore_for_file: use_build_context_synchronously

import 'package:flutter_trabalho2_opta1/commons.dart';

class ExpenseDao extends ChangeNotifier {
  static const String jsonKeyPreference = 'EXPENSE_LIST';
  List<ExpenseModel> _expenseList = [];
  List<ExpenseModel> get expenseList => _expenseList;
  int _idCounter = 0;

  ExpenseDao() {
    // Initialize empty list, the loading will be done by the context (SCREEN/WIDGET).
  }

  // PERSISTENCE
  Future<void> loadExpenses(BuildContext context) async {
    try {
      final preference = await SharedPreferences.getInstance();
      final String? jsonString = preference.getString(jsonKeyPreference);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(jsonString);
        _expenseList = jsonList.map((jsonItem) => ExpenseModel.fromJson(jsonItem)).toList();
        _idCounter = _expenseList.length;
        notifyListeners();
        showSnackbar(context: context, label: AppLabels.successLoading, isError: false);
      }
    } catch (e) {
      showSnackbar(context: context, label: AppLabels.errorLoading);
    }
  }

  Future<void> saveExpenses(BuildContext context) async {
    try {
      final preference = await SharedPreferences.getInstance();
      final String jsonString = jsonEncode(_expenseList.map((e) => e.toJson()).toList());
      await preference.setString(jsonKeyPreference, jsonString);
    } catch (e) {
      showSnackbar(context: context, label: AppLabels.errorSaving);
    }
  }

  // METHODS
  void addExpense(BuildContext context, ExpenseModel expense) {
    expense.id = _idCounter;
    _expenseList.add(expense);
    _idCounter++;
    saveExpenses(context);
    notifyListeners();
    showSnackbar(context: context, label: AppLabels.successAdding, isError: false);
  }

  void updateExpense(BuildContext context, int id, ExpenseModel newExpense) async {
    try {
      final index = _expenseList.indexWhere((expense) => expense.id == id);
      if (index != -1) {
        newExpense.id = id;
        _expenseList[index] = newExpense;
        await saveExpenses(context);
        notifyListeners();
        showSnackbar(context: context, label: AppLabels.successUpdating, isError: false);
      } else {
        showSnackbar(context: context, label: AppLabels.errorUpdating);
      }
    } catch (e) {
      showSnackbar(context: context, label: AppLabels.errorSaving);
    }
  }

  void deleteExpense(BuildContext context, int id) {
    _expenseList.removeWhere((expense) => expense.id == id);
    saveExpenses(context);
    notifyListeners();
    showSnackbar(context: context, label: AppLabels.successDeleting, isError: false);
  }

  static void addExpenseStatic(BuildContext context, ExpenseModel expense) {
    final expenseDao = Provider.of<ExpenseDao>(context, listen: false);
    expenseDao.addExpense(context, expense);
  }

  static void updateExpenseStatic(BuildContext context, int id, ExpenseModel newExpense) {
    final expenseDao = Provider.of<ExpenseDao>(context, listen: false);
    expenseDao.updateExpense(context, id, newExpense);
  }

  static void deleteExpenseStatic(BuildContext context, int id) {
    final expenseDao = Provider.of<ExpenseDao>(context, listen: false);
    expenseDao.deleteExpense(context, id);
  }
}
