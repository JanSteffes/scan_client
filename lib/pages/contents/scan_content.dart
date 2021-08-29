import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scan_client/pages/contents/icontent.dart';

class ScanContent extends StatefulWidget implements IContent {
  ScanContent({Key? key}) : super(key: key);

  @override
  _ScanContentState createState() => _ScanContentState();

  @override
  Icon getIcon() {
    return Icon(Icons.scanner);
  }

  @override
  String getTitle() {
    return "Scannen";
  }

  @override
  BottomNavigationBarItem getNavItem() {
    return BottomNavigationBarItem(
      icon: getIcon(),
      label: getTitle(),
    );
  }
}

class _ScanContentState extends State<ScanContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}
