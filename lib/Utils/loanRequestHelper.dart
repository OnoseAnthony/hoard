import 'dart:math';

import 'package:hoard/DataHandler/appData.dart';
import 'package:hoard/Models/loan.dart';
import 'package:provider/provider.dart';

createPaymentSchedule(
    context, String loanName, double loanAmount, int duration) {
  double installment = loanAmount / duration;
  LoanInfo postLoan = LoanInfo(
    loanName: loanName,
    loanId: createLoanID(),
    contractPeriod: '$duration months',
    expiryPeriod: '$duration months',
    upcomingRepayment: 'CRT Month 1',
    contractFormattedDate: getFormattedCreationDate(),
    contractAmount: loanAmount,
    repaidAmount: 0.00,
    monthlyInstallment: installment.roundToDouble(),
    totalInterest: 0.00,
    isFullyPaid: false,
    paymentSchedule: getScheduledPayments(duration, installment),
  );

  Provider.of<AppData>(context, listen: false).updatePostLoan(postLoan);
}

checkLoanLimit(context, double loanAmount) {
  int portfolioValue = Provider.of<AppData>(context, listen: false)
      .hoardUser
      .portfolio["portfolioValue"];
  double portfolioValueD = portfolioValue.toDouble();
  double totalLoanOwed =
      Provider.of<AppData>(context, listen: false).totalLoanOwed;
  bool limitPassed = false;
  double portfolioLimit = 0.6 * portfolioValueD;
  double currentLoan = totalLoanOwed + loanAmount;
  if (currentLoan > portfolioLimit) limitPassed = true;

  return limitPassed;
}

List<Map> getScheduledPayments(int duration, double monthlyInstallments) {
  List<Map> scheduledPayments = [];
  for (int i = 0; i < duration; i++) {
    Map item = {"CRT Month ${i + 1}": monthlyInstallments};
    scheduledPayments.add(item);
  }
  return scheduledPayments;
}

String createLoanID() {
  var random = Random.secure();
  var iD = random.nextInt(99999);
  var iD2 = random.nextInt(999);
  String stringId = iD.toString();
  String stringId2 = iD2.toString();
  return 'Contract No$stringId-hd$stringId2';
}

String getFormattedCreationDate() {
  int day = DateTime.now().day;
  int month = DateTime.now().month;
  int minute = DateTime.now().second;
  int hour = DateTime.now().hour;
  String med = hour >= 12 ? 'PM' : 'AM';
  String formattedDate = '$month $day - $hour:$minute $med';
  return formattedDate;
}
