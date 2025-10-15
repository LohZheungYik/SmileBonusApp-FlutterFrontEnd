import 'package:flutter/material.dart';
import 'package:winkclone/view/earn_point_page.dart';
import 'package:winkclone/view/front_page.dart';
import 'package:winkclone/view/profile_page.dart';
import 'package:winkclone/view/redeem_page.dart';

class HomeViewModel extends ChangeNotifier {
  //current home screen page index
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  late List<Widget> pages;

  HomeViewModel() {
    pages = [
      FrontPage(onJumpToSecond: _jumpToSecondPage),
      EarnPoint(onJumpToThird: _jumpToThirdPage),
      RedeemPage(),
      ProfilePage(onJumpToSecond: _jumpToSecondPage),
    ];
  }

  //following func needed for nav screen through non-nav bar buttons.
  void _jumpToSecondPage() {
    _selectedIndex = 1;
    notifyListeners();
  }

  void _jumpToThirdPage() {
    _selectedIndex = 2;
    notifyListeners();
  }

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
