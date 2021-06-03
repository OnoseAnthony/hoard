import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoard/Screens/Onboarding/onboarding.dart';
import 'package:hoard/Screens/homeWrapper.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/dialogs.dart';

class AppWrapper extends StatefulWidget {
  @override
  _AppWrapperState createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    isFirstTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
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
                      Padding(
                        padding: EdgeInsets.only(left: 40, right: 40),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: loaderContainer(),
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

  void isFirstTime() async {
    final isFirstTime = await storage.read(key: 'isFirstTime');

    if (isFirstTime == null)
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Onboarding()));
    else
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeWrapper()));
  }
}
