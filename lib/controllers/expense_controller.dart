import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense_model.dart';

class ExpenseController extends ChangeNotifier {
  static const String jsonKeyPreference = 'EXPENSE_LIST';
  List<ExpenseModel> _expenseList = [];
  List<ExpenseModel> get expenseList => _expenseList;
  int _idCounter = 0;

  ExpenseController() {
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
      print('Error loading expenses: $e');
    }
  }

  Future<void> saveExpenses() async {
    try {
      final preference = await SharedPreferences.getInstance();
      final String jsonString = jsonEncode(_expenseList.map((e) => e.toJson()).toList());
      await preference.setString(jsonKeyPreference , jsonString);
    } catch (e) {
      print('Error saving expenses: $e');
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
      print('Expense with id $id not found');
    }
  } catch (e) {
    print('Error saving expenses: $e');
  }
}

  void deleteExpense(int id) {
    _expenseList.removeWhere((expense) => expense.id == id);
    saveExpenses();
    notifyListeners();
  }

  static void addExpenseStatic(BuildContext context, ExpenseModel expense) {
    final expenseController = Provider.of<ExpenseController>(context, listen: false);
    expenseController.addExpense(expense);
  }

  static void updateExpenseStatic(BuildContext context, int id, ExpenseModel newExpense) {
    final expenseController = Provider.of<ExpenseController>(context, listen: false);
    expenseController.updateExpense(id, newExpense);
  }

  static void deleteExpenseStatic(BuildContext context, int id) {
    final expenseController = Provider.of<ExpenseController>(context, listen: false);
    expenseController.deleteExpense(id);
  }
}
