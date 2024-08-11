import 'package:flutter_trabalho2_opta1/commons.dart';

String? validateEmpty(String? value) {
  if (value == null || value.isEmpty) {
    return AppLabels.valueError;
  }
  return null;
}

String? validateYear(String? value) {
  if (value == null || value.isEmpty) {
    return AppLabels.valueError;
  }
  final int? year = int.tryParse(value);
  if (year == null || year < 2000 || year > 3000) {
    return AppLabels.valueError; 
  }
  return null; 
}

String? validateAmount(String? value) {
  if (value == null || value.isEmpty) {
    return AppLabels.valueError;
  }

  final double? amount = double.tryParse(value.replaceAll(',', '.'));
  if (amount == null || amount <= 0.0) {
    return AppLabels.valueError; 
  }
  return null; 
}


Widget createTextFormField({
  String? label,
  TextEditingController? controller,
  TextInputType? textInputType,
  String? Function(String?)? validator,
  Icon? icon,
  bool obscureText = false,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: textInputType,
    validator: validator,

    obscureText: obscureText,
    decoration: getInputDecoration(hint: label, icon: icon),
    style: const TextStyle(
      color: AppColors.text,
      fontSize: 15.0,
    ),
  );
}

Widget createDropdownButtonFormField({
  required String label,
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return DropdownButtonFormField<String>(
    decoration: getInputDecoration(label: label),

    value: value,
    items: items.map((item) {
      return DropdownMenuItem(
        value: item,
        child: Text(item),
      );
    }).toList(),
    onChanged: onChanged,
  );
}

InputDecoration getInputDecoration({
  String? label,
  String? hint,
  Icon? icon,
}) {
  return InputDecoration(
    prefixIcon: icon,
    labelText: label,
    hintText: hint,
    fillColor: AppColors.formBG,
    filled: true,
    labelStyle: const TextStyle(color: AppColors.text),
    contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.buttonBG, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.text, width: 3),
    ),

    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.error, width: 3),
    ),
  );
}
