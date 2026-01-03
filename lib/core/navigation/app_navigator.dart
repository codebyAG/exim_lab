import 'package:flutter/material.dart';

class AppNavigator {
  // 🔹 SIMPLE PUSH
  static Future<T?> push<T>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // 🔹 PUSH & REPLACE (WELCOME → LOGIN)
  static Future<T?> replace<T>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.pushReplacement<T, T>(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // 🔹 CLEAR STACK & GO (LOGIN → DASHBOARD)
  static Future<T?> clearAndGo<T>(
    BuildContext context,
    Widget page,
  ) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      MaterialPageRoute(builder: (_) => page),
      (_) => false,
    );
  }

  // 🔹 POP ONE SCREEN
  static void pop(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }

  // 🔹 POP UNTIL FIRST
  static void popToRoot(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  // 🔹 SHOW SNACKBAR
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.black87,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }

  // 🔹 SHOW ALERT DIALOG
  static Future<void> showDialogBox(
    BuildContext context, {
    required String title,
    required String message,
    String okText = 'OK',
    VoidCallback? onOk,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onOk != null) onOk();
            },
            child: Text(okText),
          ),
        ],
      ),
    );
  }

  // 🔹 CONFIRMATION DIALOG (YES / NO)
  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String yesText = 'Yes',
    String noText = 'No',
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(noText),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(yesText),
              ),
            ],
          ),
        ) ??
        false;
  }

  // 🔹 SHOW BOTTOM SHEET
  static Future<T?> showBottomSheet<T>(
    BuildContext context,
    Widget child, {
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => child,
    );
  }

  // 🔹 LOADING DIALOG
  static void showLoading(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(message ?? 'Please wait...'),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 HIDE LOADING
  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
