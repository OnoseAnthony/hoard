import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hoard/DataHandler/appData.dart';
import 'package:hoard/Models/loan.dart';
import 'package:hoard/Models/user.dart';
import 'package:hoard/Services/firebase/auth.dart';
import 'package:provider/provider.dart';

class DatabaseService {
  User firebaseUser;
  BuildContext context;

  DatabaseService({@required this.firebaseUser, this.context});

  //collection reference for hoard users
  final CollectionReference userProfileCollection =
      FirebaseFirestore.instance.collection('Customers');

  //collection reference for loans
  final CollectionReference userLoanCollection =
      FirebaseFirestore.instance.collection('Loans');

  // Function to check if the user uid exists in the firestore hoard user (Customer) collection
  Future<bool> checkUser() async {
    var document = await userProfileCollection.doc(firebaseUser.uid).get();
    if (document.exists)
      return Future.value(true);
    else
      return Future.value(false);
  }

  // Function to get hoard user data from firestore
  Future<HoardUser> getHoardUserData() async {
    DocumentSnapshot snapshot =
        await userProfileCollection.doc(firebaseUser.uid).get();
    return _customUserDataFromSnapshot(snapshot);
  }

  // method to return hoard user data object from snapshot
  HoardUser _customUserDataFromSnapshot(DocumentSnapshot snapshot) {
    HoardUser hoardUser = HoardUser(
        uid: snapshot.get('uid'),
        firstName: snapshot.get('firstName'),
        lastName: snapshot.get('lastName'),
        photoUrl: snapshot.get('photoUrl'),
        portfolio: snapshot.get('portfolio'));
    Provider.of<AppData>(context, listen: false).updateHoardUser(hoardUser);
    return hoardUser;
  }

  Future<bool> updatehoardUserData(
      String firstName, String lastName, String photoUrl, Map portfolio) async {
    HoardUser hoardUser = HoardUser(
      uid: firebaseUser.uid,
      firstName: firstName,
      lastName: lastName,
      photoUrl: photoUrl,
      portfolio: portfolio,
    );
    try {
      await userProfileCollection.doc(firebaseUser.uid).set({
        'uid': firebaseUser.uid,
        'firstName': firstName,
        'lastName': lastName,
        'emailAddress': firebaseUser.email,
        'phoneNumber': firebaseUser.phoneNumber,
        'photoUrl': photoUrl,
        'portfolio': portfolio,
      });
      Provider.of<AppData>(context, listen: false).updateHoardUser(hoardUser);
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  // Function to save loan request to database
  Future<bool> saveLoanRequest() async {
    var _firebaseUser = AuthService().getCurrentUser();
    LoanInfo saveLoan = Provider.of<AppData>(context, listen: false).postLoan;

    try {
      await userLoanCollection.add({
        "userId": _firebaseUser.uid,
        "loanName": saveLoan.loanName,
        "loanId": saveLoan.loanId,
        "contractPeriod": saveLoan.contractPeriod,
        "expiryPeriod": saveLoan.expiryPeriod,
        "upcomingRepayment": saveLoan.upcomingRepayment,
        "contractFormattedDate": saveLoan.contractFormattedDate,
        "contractAmount": saveLoan.contractAmount,
        "repaidAmount": saveLoan.repaidAmount,
        "monthlyInstallment": saveLoan.monthlyInstallment,
        "totalInterest": saveLoan.totalInterest,
        "isFullyPaid": saveLoan.isFullyPaid,
        "paymentSchedule": saveLoan.paymentSchedule,
        "timeStamp": DateTime.now().toString(),
      });

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  // Function to get user loan data from firestore
  Future<List<LoanInfo>> getUserLoanList() async {
    QuerySnapshot snapshot = await userLoanCollection
        .where("userId", isEqualTo: firebaseUser.uid)
        .orderBy('contractFormattedDate', descending: true)
        .get();
    return (userLoanFromSnapshot(snapshot));
  }

  // method to return user loan object from firestore snapshot
  List<LoanInfo> userLoanFromSnapshot(QuerySnapshot snapshot) {
    double totalLoanOwed = 0.00;
    var data = snapshot.docs.map((doc) {
      totalLoanOwed +=
          doc.data()['contractAmount'] - doc.data()['repaidAmount'];
      return LoanInfo(
        docId: doc.id,
        userId: doc.data()['userId'],
        loanName: doc.data()['loanName'],
        loanId: doc.data()['loanId'],
        contractPeriod: doc.data()['contractPeriod'],
        expiryPeriod: doc.data()['expiryPeriod'],
        upcomingRepayment: doc.data()['upcomingRepayment'],
        contractFormattedDate: doc.data()['contractFormattedDate'],
        contractAmount: doc.data()['contractAmount'],
        repaidAmount: doc.data()['repaidAmount'],
        monthlyInstallment: doc.data()['monthlyInstallment'],
        totalInterest: doc.data()['totalInterest'],
        isFullyPaid: doc.data()['isFullyPaid'],
        paymentSchedule: doc.data()['paymentSchedule'],
      );
    }).toList();
    Provider.of<AppData>(context, listen: false)
        .updateTotalLoanOwed(totalLoanOwed);
    return data;
  }

  // Function to update loan status for a particular loan in firestore
  Future<bool> updateLoanInfo(
    String expiryPeriod,
    String upcomingRepayment,
    double repaidAmount,
    bool isFullyPaid,
    String docId,
  ) async {
    try {
      await userLoanCollection.doc(docId).update({
        "expiryPeriod": expiryPeriod,
        "upcomingRepayment": upcomingRepayment,
        "repaidAmount": repaidAmount,
        "isFullyPaid": isFullyPaid,
      });

      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}
