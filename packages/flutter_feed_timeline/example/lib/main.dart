import "package:example/apps/navigator/app.dart";
import "package:flutter/material.dart";
import "package:intl/date_symbol_data_local.dart";

Future<void> main() async {
  await initializeDateFormatting();

  runApp(const NavigatorApp());
}
