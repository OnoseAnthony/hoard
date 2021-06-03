import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoard/Screens/Dashboard/home.dart';
import 'package:hoard/Screens/Dashboard/loan.dart';
import 'package:hoard/Screens/Dashboard/profile.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/text.dart';

class DashboardBottomNavigation extends StatefulWidget {
  const DashboardBottomNavigation({Key key}) : super(key: key);

  @override
  _DashboardBottomNavigationState createState() =>
      _DashboardBottomNavigationState();
}

class _DashboardBottomNavigationState extends State<DashboardBottomNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: kBackgroundColor,
        systemNavigationBarColor: kBackgroundColor));
    return Scaffold(
      body: getChildren(),
      bottomNavigationBar: BubbleBottomBar(
        backgroundColor: kWhiteColor,
        opacity: .07,
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
          });
        },
        elevation: 4,
        hasInk: false,
        //new, gives a cute ink effect
        inkColor: Colors.black12,
        //optional, uses theme color if not specified
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: kPrimaryColor,
              icon: Icon(
                Icons.dashboard,
                color: kBackgroundColor,
                size: 22,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: kSuccessColor,
              ),
              title: buildTitlenSubtitleText(
                  'Home', kSecondaryColor, 16, FontWeight.bold, null, null)),
          BubbleBottomBarItem(
              backgroundColor: kPrimaryColor,
              icon: Icon(
                Icons.money,
                color: kBackgroundColor,
                size: 22,
              ),
              activeIcon: Icon(
                Icons.money,
                color: kSuccessColor,
              ),
              title: buildTitlenSubtitleText(
                  'Loan', kSecondaryColor, 16, FontWeight.bold, null, null)),
          BubbleBottomBarItem(
              backgroundColor: kPrimaryColor,
              icon: Icon(
                Icons.menu,
                color: kBackgroundColor,
                size: 22,
              ),
              activeIcon: Icon(
                Icons.menu,
                color: kSuccessColor,
              ),
              title: buildTitlenSubtitleText('My Profile', kSecondaryColor, 16,
                  FontWeight.bold, null, null)),
        ],
      ),
    );
  }

  getChildren() {
    final List<Widget> _childrenUser = [Home(), Loan(), Profile()];
    return _childrenUser[_currentIndex];
  }
}
