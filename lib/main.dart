import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scan_client/models/notifiers/selected_files_notifier.dart';
import 'package:scan_client/widgets/pages/main_page.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      exit(1);
    };
    runApp(ChangeNotifierProvider(
        create: (context) => SelectedFiles(), child: MyApp()));
  }, (Object error, StackTrace stack) {
    var errorJson = jsonEncode(error);
    log("==> Error: $errorJson");
    log("==> stackTrace: $stack");
    exit(1);
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Scan App',
        theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue),
        home: MainPage(title: 'ScanApp'));
  }
}
