import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class IContent extends StatefulWidget {
  String getTitle();
  Icon getIcon();
  BottomNavigationBarItem getNavItem();
}
