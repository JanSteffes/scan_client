import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scan_client/pages/contents/file_content.dart';
import 'package:scan_client/pages/contents/icontent.dart';
import 'package:scan_client/pages/contents/scan_content.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _currentIndex = 0;
  final List<IContent> _children = [FileContent(), ScanContent()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped, // new
            currentIndex: _currentIndex, // new
            items: _children.map((e) => e.getNavItem()).toList()));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
