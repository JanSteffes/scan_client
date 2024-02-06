import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scan_client/models/notifiers/selected_files_notifier.dart';
import 'package:scan_client/widgets/pages/discover_page.dart';
import 'package:scan_client/widgets/pages/main_page.dart';

void main() {
  // TODO get good window sizes

  // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //   DesktopWindow.setMinWindowSize(Size(300, 400));
  //   DesktopWindow.setMaxWindowSize(Size(300, 400));
  // }
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Scan App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: DiscoverPage());
  }
}
