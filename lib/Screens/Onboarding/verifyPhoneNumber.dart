import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hoard/DataHandler/appData.dart';
import 'package:hoard/Models/user.dart';
import 'package:hoard/Screens/Dashboard/editProfile.dart';
import 'package:hoard/Screens/homeWrapper.dart';
import 'package:hoard/Services/firebase/auth.dart';
import 'package:hoard/Services/firebase/firestore.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/buttons.dart';
import 'package:hoard/widgets/dialogs.dart';
import 'package:hoard/widgets/text.dart';
import 'package:hoard/widgets/textformfield.dart';
import 'package:provider/provider.dart';

class VerifyPhone extends StatefulWidget {
  String phoneNumber;
  String verificationId;
  FirebaseAuth auth;

  VerifyPhone({this.phoneNumber, this.verificationId, this.auth});

  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingController _controller, _controller1, _controller2, _controller3, _controller4, _controller5  = TextEditingController();
  TextEditingController _controller = TextEditingController();
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  TextEditingController _controller5 = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        padding: kPrimaryPadding(size),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitlenSubtitleText('Enter code', kPrimaryColor, 15,
                    FontWeight.bold, TextAlign.start, null),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    buildTitlenSubtitleText(
                        'An SMS code was sent to  ',
                        kTextSubtitleColor,
                        13,
                        FontWeight.normal,
                        TextAlign.start,
                        null),
                    buildTitlenSubtitleText(widget.phoneNumber, kPrimaryColor,
                        15, FontWeight.bold, TextAlign.start, null),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: buildTitlenSubtitleText(
                      'Edit phone number',
                      Color(0xFF27AE60),
                      13,
                      FontWeight.normal,
                      TextAlign.start,
                      null),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildVerifyPhoneNumberField(_controller, context),
                    buildVerifyPhoneNumberField(_controller1, context),
                    buildVerifyPhoneNumberField(_controller2, context),
                    buildVerifyPhoneNumberField(_controller3, context),
                    buildVerifyPhoneNumberField(_controller4, context),
                    buildVerifyPhoneNumberField(_controller5, context),
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                InkWell(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => NavigationLoader(context),
                      );

                      final codeString = _controller.text.trim() +
                          _controller1.text.trim() +
                          _controller2.text.trim() +
                          _controller3.text.trim() +
                          _controller4.text.trim() +
                          _controller5.text.trim();

                      AuthCredential authCredential =
                          PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: codeString);

                      UserCredential result = await widget.auth
                          .signInWithCredential(authCredential);

                      User user = result.user;

                      if (user != null &&
                          await DatabaseService(
                                      firebaseUser: user, context: context)
                                  .checkUser() !=
                              true) {
                        //New user so we create an instance

                        //create an instance of the database service to create user profile and set isDriver to false for the customer

                        showToast(context,
                            'Authentication successful. please wait', false);

                        //provide the user info to the provider
                        Provider.of<AppData>(context, listen: false)
                            .updateFirebaseUser(user);

                        //GOTO PROFILE SCREEN
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile(
                                      isFromAuth: true,
                                    )));
                      } else if (user != null &&
                          await DatabaseService(
                                      firebaseUser: user, context: context)
                                  .checkUser() ==
                              true) {
                        HoardUser _hoardUser = await DatabaseService(
                                firebaseUser: AuthService().getCurrentUser(),
                                context: context)
                            .getHoardUserData();

                        //returning user found in the hoard user customer collection, we show toast and then navigate to home screen
                        showToast(context,
                            'Authentication successful. please wait', false);

                        //provide the user info to the provider
                        Provider.of<AppData>(context, listen: false)
                            .updateFirebaseUser(user);

                        //check if user has email set up
                        if (_hoardUser == null)
                          //GOTO PROFILE SCREEN
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                        isFromAuth: true,
                                      )));
                        else
                          //GOTO HOME SCREEN
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeWrapper()));
                      }
                    }
                  },
                  child: buildSubmitButton('NEXT'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
