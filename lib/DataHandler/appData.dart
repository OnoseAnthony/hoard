import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hoard/Models/loan.dart';
import 'package:hoard/Models/user.dart';

class AppData extends ChangeNotifier {
  LoanInfo postLoan;
  User firebaseUser;
  HoardUser hoardUser;
  RepaymentSummaryInfo repaymentSummaryInfo;
  double totalLoanOwed;

  updatePostLoan(LoanInfo _postLoan) {
    postLoan = _postLoan;
    notifyListeners();
  }

  updateFirebaseUser(User _user) {
    firebaseUser = _user;
    notifyListeners();
  }

  updateHoardUser(HoardUser _user) {
    hoardUser = _user;
    notifyListeners();
  }

  updateRepaymentSummaryInfo(RepaymentSummaryInfo _repaymentSummaryInfo) {
    repaymentSummaryInfo = _repaymentSummaryInfo;
    notifyListeners();
  }

  updateTotalLoanOwed(double _totalLoanOwed) {
    totalLoanOwed = _totalLoanOwed;
    notifyListeners();
  }
}
