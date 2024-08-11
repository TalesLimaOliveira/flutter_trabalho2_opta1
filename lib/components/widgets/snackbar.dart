import 'package:flutter_trabalho2_opta1/commons.dart';

showSnackbar({
  required BuildContext context,
  required String label,
  bool isError = true,
}){
  SnackBar snackBar = SnackBar(
    content: Text(label),
    backgroundColor: (isError ? AppColors.error : AppColors.success),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
    ),
    duration: const Duration(seconds: 4),
    showCloseIcon: true,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}