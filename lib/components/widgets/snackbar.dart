import 'package:flutter_trabalho2_opta1/commons.dart';

showSnackbar({
  required BuildContext context,
  required String label,
  bool isError = true,
}){
  SnackBar snackBar = SnackBar(
    content: Text(label),
    backgroundColor: (isError ? AppColors.error : AppColors.secondary),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
    ),
    duration: const Duration(seconds: 3),
    showCloseIcon: true,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}