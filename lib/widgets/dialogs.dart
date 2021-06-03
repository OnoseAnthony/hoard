import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hoard/DataHandler/appData.dart';
import 'package:hoard/Models/loan.dart';
import 'package:hoard/Screens/homeWrapper.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/buttons.dart';
import 'package:hoard/widgets/sharedWidgets.dart';
import 'package:hoard/widgets/text.dart';
import 'package:provider/provider.dart';

Dialog loanCompleteDialog(context) {
  LoanInfo postLoan =
      Provider.of<AppData>(context, listen: false).postLoan ?? LoanInfo();
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    child: Container(
      height: 450,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
        child: Column(
          children: [
            buildTitlenSubtitleText('Great!', kSuccessColor, 13.0,
                FontWeight.w500, TextAlign.center, null),
            SizedBox(
              height: 10,
            ),
            buildTitlenSubtitleText('Loan Success', kPrimaryColor, 20.0,
                FontWeight.bold, TextAlign.center, null),
            SizedBox(
              height: 5,
            ),
            buildTitlenSubtitleText(
                'Below is your summary',
                Colors.grey.shade400,
                13.0,
                FontWeight.w500,
                TextAlign.center,
                null),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildSummaryItem('Purpose Loan', postLoan.loanName),
                  SizedBox(
                    height: 10,
                  ),
                  buildSummaryItem(
                      'Total loan', '\$${postLoan.contractAmount}'),
                  SizedBox(
                    height: 10,
                  ),
                  buildSummaryItem('Duration', postLoan.expiryPeriod),
                  SizedBox(
                    height: 10,
                  ),
                  buildSummaryItem(
                      'Installment', '\$${postLoan.monthlyInstallment}/month'),
                  SizedBox(
                    height: 10,
                  ),
                  buildSummaryItem('Due Date', 'CRT Month 1'),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeWrapper()),
                          (route) => false);
                    },
                    child: buildSubmitButton('Back to home'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

buildSummaryItem(String title, String subtitle) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      buildTitlenSubtitleText(title, Colors.grey.shade400, 13.0,
          FontWeight.w500, TextAlign.start, null),
      buildTitlenSubtitleText(
          subtitle, kPrimaryColor, 13.0, FontWeight.bold, null, null),
    ],
  );
}

Dialog loanRepaymentCompleteDialog(context) {
  RepaymentSummaryInfo repaymentSummaryInfo =
      Provider.of<AppData>(context, listen: false).repaymentSummaryInfo;
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    child: Container(
      height: 450,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
        child: Column(
          children: [
            buildTitlenSubtitleText('Great!', kSuccessColor, 13.0,
                FontWeight.w500, TextAlign.center, null),
            SizedBox(
              height: 10,
            ),
            buildTitlenSubtitleText('Repayment Success', kPrimaryColor, 20.0,
                FontWeight.bold, TextAlign.center, null),
            SizedBox(
              height: 5,
            ),
            buildTitlenSubtitleText(
                'Below is your summary',
                Colors.grey.shade400,
                13.0,
                FontWeight.w500,
                TextAlign.center,
                null),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildSummaryItem(
                      'Purpose Loan', repaymentSummaryInfo.loanPurpose),
                  SizedBox(
                    height: 10,
                  ),
                  buildSummaryItem(
                      'Total loan', '\$${repaymentSummaryInfo.loanTotal}'),
                  SizedBox(
                    height: 10,
                  ),
                  buildSummaryItem(
                      'Amount Paid', '\$${repaymentSummaryInfo.amountPaid}'),
                  SizedBox(
                    height: 10,
                  ),
                  buildSummaryItem(
                      'Amount Owed', '\$${repaymentSummaryInfo.amountOwed}'),
                  SizedBox(
                    height: 10,
                  ),
                  buildSummaryItem(
                      'Duration', '${repaymentSummaryInfo.duration} Months'),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeWrapper()),
                          (route) => false);
                    },
                    child: buildSubmitButton('Back to home'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

showToast(context, String msg, bool isError) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    margin: !isError ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      color: isError ? kErrorColor : kSuccessColor,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(isError ? Icons.cancel : Icons.check,
            size: 18, color: kWhiteColor),
        SizedBox(
          width: 12.0,
        ),
        buildTitlenSubtitleText(
            msg, kWhiteColor, 13, FontWeight.w500, TextAlign.center, null)
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: isError ? ToastGravity.SNACKBAR : ToastGravity.TOP,
    toastDuration: Duration(seconds: 3),
  );
}

Dialog NavigationLoader(BuildContext context) {
  return Dialog(
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: kWhiteColor,
      ),
      height: 80.0,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 40, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            LoaderWidget(),
            SizedBox(
              width: 30,
            ),
            buildTitlenSubtitleText('please wait a moment...', kPrimaryColor,
                13, FontWeight.bold, TextAlign.center, null),
          ],
        ),
      ),
    ),
  );
}

loaderContainer() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: kWhiteColor,
    ),
    height: 80.0,
    child: Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 40, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          LoaderWidget(),
          SizedBox(
            width: 30,
          ),
          buildTitlenSubtitleText('please wait a moment...', kPrimaryColor, 13,
              FontWeight.bold, TextAlign.center, null),
        ],
      ),
    ),
  );
}
