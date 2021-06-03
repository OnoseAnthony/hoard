import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hoard/DataHandler/appData.dart';
import 'package:hoard/Models/user.dart';
import 'package:hoard/Screens/Dashboard/editProfile.dart';
import 'package:hoard/Screens/Onboarding/verifyPhoneNumber.dart';
import 'package:hoard/Screens/homeWrapper.dart';
import 'package:hoard/Services/firebase/firestore.dart';
import 'package:hoard/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User getCurrentUser() {
    return auth.currentUser;
  }

  Future<bool> updateUserEmailAddress(String emailAddress, context) async {
    User user = auth.currentUser;
    if (user != null)
      try {
        await user.updateEmail(emailAddress);
        Provider.of<AppData>(context, listen: false).updateFirebaseUser(user);
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
  }

  Future phoneAuthentication(String phoneNumber, BuildContext context) async {
    auth.verifyPhoneNumber(
      codeAutoRetrievalTimeout: (String verificationId) {},
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        Navigator.pop(context);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => NavigationLoader(context),
        );

        UserCredential result = await auth.signInWithCredential(credential);

        User user = result.user;

        if (user != null &&
            await DatabaseService(firebaseUser: user, context: context)
                    .checkUser() !=
                true) {
          //New user so we create an instance
          //create an instance of the database service to create customer profile

          showToast(context, 'Authentication successful. please wait', false);

          //provide the user info to the provider
          Provider.of<AppData>(context, listen: false).updateFirebaseUser(user);

          //GOTO PROFILE SCREEN
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProfile(
                        isFromAuth: true,
                      )));
        } else if (user != null &&
            await DatabaseService(firebaseUser: user, context: context)
                    .checkUser() ==
                true) {
          HoardUser _hoardUser = await DatabaseService(
                  firebaseUser: getCurrentUser(), context: context)
              .getHoardUserData();

          //returning hoard user found in the hoard user customer collection, we show toast and then navigate to home screen
          showToast(context, 'Authentication successful. please wait', false);

          //provide the firebase user info to the provider
          Provider.of<AppData>(context, listen: false).updateFirebaseUser(user);

          //check if user has profile  set up
          if (_hoardUser == null)
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProfile(
                          isFromAuth: true,
                        )));
          else
            //GOTO HOME SCREEN
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomeWrapper()));
        }
      },
      verificationFailed: (FirebaseAuthException exception) {
        Navigator.pop(context);
        showToast(context, 'Authentication failed. try later', true);
      },
      codeSent: (String verificationID, [int forceResendingToken]) {
        // if the code send is not validated automatically we pop the dialog before navigating
        Navigator.pop(context);

        //NAVIGATE TO THE SCREEN WHERE THEY CAN ENTER THE CODE SENT

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyPhone(
                      phoneNumber: phoneNumber,
                      verificationId: verificationID,
                      auth: auth,
                    )));
      },
    );
  }

  Future<bool> signOut() async {
    User user = auth.currentUser;
    if (user != null)
      try {
        await auth.signOut();
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
  }
}
