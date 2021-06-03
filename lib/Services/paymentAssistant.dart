import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoard/DataHandler/appData.dart';
import 'package:hoard/Models/user.dart';
import 'package:hoard/Services/firebase/auth.dart';
import 'package:hoard/constants.dart';
import 'package:provider/provider.dart';
import 'package:rave_flutter/rave_flutter.dart';

class PaymentAssistant {
  static Future<dynamic> processTransaction(
      BuildContext context, double _amount, String txRef) async {
    HoardUser hoardUser =
        Provider.of<AppData>(context, listen: false).hoardUser;
    User firebaseUser = AuthService().getCurrentUser();
    Widget companyName = Text('Hoard Inc');

    // Get a reference to RavePayInitializer
    var initializer = RavePayInitializer(
        amount: _amount,
        publicKey: kRavePublicKey,
        encryptionKey: kRaveEncryptionKey)
      ..country = "NG"
      ..currency = 'USD'
      ..email = firebaseUser.email
      ..fName = hoardUser.firstName
      ..lName = hoardUser.lastName
      ..narration = 'Loan Repayment'
      ..txRef = txRef
      ..subAccounts = []
      ..acceptMpesaPayments = false
      ..acceptAccountPayments = false
      ..acceptCardPayments = true
      ..acceptAchPayments = false
      ..acceptGHMobileMoneyPayments = false
      ..acceptUgMobileMoneyPayments = false
      ..staging = true
      ..companyName = companyName
      ..isPreAuth = false
      ..displayEmail = true
      ..displayFee = true;

    // Initialize and get the transaction result
    RaveResult response = await RavePayManager()
        .prompt(context: context, initializer: initializer);

    RaveStatus txStatus = response.status;

    switch (txStatus) {
      case (RaveStatus.success):
        return response.rawResponse;
        break;

      case (RaveStatus.error):
        return "Failed";
        break;

      case (RaveStatus.cancelled):
        return "Cancelled";
        break;
    }
  }
}
