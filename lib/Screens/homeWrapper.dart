import 'package:flutter/material.dart';
import 'package:hoard/Screens/Onboarding/addPhoneNumber.dart';
import 'package:hoard/Services/firebase/auth.dart';
import 'package:hoard/Services/firebase/firestore.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/buttons.dart';
import 'package:hoard/widgets/dashboardNavigationBar.dart';
import 'package:hoard/widgets/dialogs.dart';
import 'package:hoard/widgets/text.dart';

class HomeWrapper extends StatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override
  Widget build(BuildContext context) {
    final user = AuthService().getCurrentUser();
    if (user == null) {
      return AddPhoneNumber();
    } else
      return InternetRouter();
  }

  InternetRouter() {
    return FutureBuilder(
        future: DatabaseService(
                firebaseUser: AuthService().getCurrentUser(), context: context)
            .getHoardUserData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var hoardUser = snapshot.data;
            if (snapshot.data != null && hoardUser != null) {
              return DashboardBottomNavigation();
            } else {
              return DashBoardNoNetwork();
            }
          } else {
            return Container(
              color: kBackgroundColor,
              padding: kSidePadding,
              child: Center(
                child: loaderContainer(),
              ),
            );
          }
        });
  }
}

class DashBoardNoNetwork extends StatelessWidget {
  const DashBoardNoNetwork({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(color: kWhiteColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTitlenSubtitleText(
                          'Network Request Failed',
                          Colors.black,
                          20,
                          FontWeight.bold,
                          TextAlign.center,
                          null),
                      SizedBox(
                        height: 15,
                      ),
                      buildTitlenSubtitleText(
                          'No internet connection',
                          kGreyColor,
                          13,
                          FontWeight.normal,
                          TextAlign.center,
                          null),
                      buildTitlenSubtitleText(
                          'Check your internet, then tap the button to retry',
                          kGreyColor,
                          13,
                          FontWeight.normal,
                          TextAlign.center,
                          null),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: InkWell(
                          onTap: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeWrapper()),
                              (route) => false),
                          child: buildSubmitButton('RETRY'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
