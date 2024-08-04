import 'package:flutter/material.dart';
import 'package:flutter_trabalho2_opta1/components/colors.dart';
import 'package:flutter_trabalho2_opta1/components/labels.dart';
import 'package:flutter_trabalho2_opta1/components/textfields.dart';
import 'package:flutter_trabalho2_opta1/controllers/expense_controller.dart';
import 'package:flutter_trabalho2_opta1/models/expense_model.dart';

class ExpenseForm extends StatefulWidget {
  final ExpenseModel? existingExpense;

  const ExpenseForm({super.key, this.existingExpense});

  @override
  ExpenseFormState createState() => ExpenseFormState();
}

class ExpenseFormState extends State<ExpenseForm> {
  // Vars
  static const double _formPadding = 8.0;

  // Controllers
  final _formKey = GlobalKey<FormState>();
  final _yearController = TextEditingController();
  final _purposeController = TextEditingController();
  final _amountController = TextEditingController();
  String _month = AppLabels.monthsList[0];
  String _type = AppLabels.typesList[0];

  @override
  void initState() {
    super.initState();
    if (widget.existingExpense != null) {
      _yearController.text = widget.existingExpense!.year.toString();
      _purposeController.text = widget.existingExpense!.purpose;
      _amountController.text = widget.existingExpense!.amount.toString();
      _month = widget.existingExpense!.month;
      _type = widget.existingExpense!.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingExpense == null
            ? AppLabels.appBarForm
            : AppLabels.appBarEdit),
      ),

// SCREEN STYLE
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppColors.containerBG,
          borderRadius: BorderRadius.circular(16),
        ),

// FORMS
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

// LINE 1: PURPOSE
              Padding(
                padding: const EdgeInsets.symmetric(vertical: _formPadding),
                child: createTextFormField(
                  label: AppLabels.purpose,
                  controller: _purposeController,
                  textInputType: TextInputType.name,
                  validator: validateEmpty,
                ),
              ),

// LINE 2: Type & Amount
              Row(
                children: [

// TYPE
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: _formPadding),
                      child: createDropdownButtonFormField(
                        value: _type,
                        label: AppLabels.type,
                        items: AppLabels.typesList,
                        onChanged: (value) {
                          setState(() {
                            _type = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

// AMOUNT
                  Expanded(
                    child: Padding(
                      padding:
                        const EdgeInsets.symmetric(vertical: _formPadding),
                      child: createTextFormField(
                        label: AppLabels.amount,
                        controller:  _amountController,
                        textInputType:  TextInputType.number,
                        validator: validateAmount,
                      ),
                    ),
                  ),
                ],
              ),

// LINE 3: MOUNTH & YEAR
              Row(
                children: [

// MONTH
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: _formPadding),
                      child: createDropdownButtonFormField(
                        value: _month,
                        label: AppLabels.month,
                        items: AppLabels.monthsList,
                        onChanged: (value) {
                          setState(() {
                            _month = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

// YEAR
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: _formPadding),
                      child: createTextFormField(
                        label: AppLabels.year,
                        controller: _yearController,
                        textInputType: TextInputType.number,
                        validator: validateYear,
                      ),
                    ),
                  ),
                ],
              ),

// SAVE BUTTON
              const Spacer(), // Pushes the button to the bottom
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newExpense = ExpenseModel(
                      year: int.parse(_yearController.text),
                      month: _month,
                      purpose: _purposeController.text,
                      amount: double.parse(_amountController.text),
                      type: _type,
                    );
                    if (widget.existingExpense != null) {
                      newExpense.id = widget.existingExpense!.id;// Preserve ID for update
                      ExpenseController.updateExpenseStatic(
                        context, newExpense.id, newExpense);
                    } else {
                      ExpenseController.addExpenseStatic(context, newExpense);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.existingExpense == null
                    ? AppLabels.addExpense
                    : AppLabels.updateExpense),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
