import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoard/DataHandler/appData.dart';
import 'package:hoard/Models/loan.dart';
import 'package:hoard/Services/firebase/auth.dart';
import 'package:hoard/Services/firebase/firestore.dart';
import 'package:hoard/Services/paymentAssistant.dart';
import 'package:hoard/Services/requestAssistant.dart';
import 'package:hoard/Utils/enums.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/dialogs.dart';
import 'package:hoard/widgets/text.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoanDetail extends StatelessWidget {
  final LoanInfo loanInfo;

  const LoanDetail({Key key, this.loanInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: kPrimaryColor,
        systemNavigationBarColor: kBackgroundColor));
    double size = MediaQuery.of(context).size.height;
    int length = int.parse(loanInfo.contractPeriod.split(' ').first);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        height: size,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: kTopPadding(size + 100),
              child: Container(
                margin: kSidePadding,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          LineAwesomeIcons.arrow_left,
                          color: kPrimaryColor.withOpacity(0.8),
                        )),
                    buildTitlenSubtitleText(
                        loanInfo.loanName,
                        kPrimaryColor.withOpacity(0.8),
                        18,
                        FontWeight.bold,
                        null,
                        null),
                    SizedBox(),
                  ],
                ),
              ),
            ),
            Container(
              height: 130.0,
              margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 10),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildTitlenSubtitleText('Total left to pay', kBackgroundColor,
                      13, FontWeight.w500, null, null),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTitlenSubtitleText(
                          '\$${(loanInfo.contractAmount) - (loanInfo.repaidAmount)}',
                          kWhiteColor,
                          22,
                          FontWeight.bold,
                          null,
                          null),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 8,
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(kSuccessColor),
                            value: loanInfo.repaidAmount == 0.00
                                ? 0 / 6
                                : (int.parse(loanInfo.upcomingRepayment
                                            .split(' ')
                                            .last) -
                                        1) /
                                    6,
                            backgroundColor: kBackgroundColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      buildTitlenSubtitleText(
                          loanInfo.repaidAmount == 0.00
                              ? '0/${(loanInfo.contractPeriod.split(' ').first)}'
                              : '${(int.parse(loanInfo.upcomingRepayment.split(' ').last) - 1)}/${(loanInfo.contractPeriod.split(' ').first)}',
                          kBackgroundColor,
                          10,
                          FontWeight.w500,
                          null,
                          null),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: kSidePadding,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 18.0),
                      child: buildTitlenSubtitleText('Payments', kPrimaryColor,
                          18, FontWeight.bold, null, null),
                    ),
                    Flexible(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return buildLoanInfo(
                              context,
                              'CRT Month ${index + 1}',
                              loanInfo.monthlyInstallment,
                              loanInfo.upcomingRepayment ==
                                      'CRT Month ${index + 1}'
                                  ? true
                                  : false,
                              (index + 1) <
                                      int.parse(loanInfo.upcomingRepayment
                                          .split(' ')
                                          .last)
                                  ? true
                                  : false);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildLoanInfo(context, String date, double repaymentAmount, bool isUpcoming,
      bool isPaid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitlenSubtitleText(
              isUpcoming ? '$date - Upcoming' : date,
              !isUpcoming ? Colors.grey.shade300 : Colors.grey.shade700,
              13,
              FontWeight.w500,
              null,
              null),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 70.0,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                  color: !isUpcoming
                      ? Colors.grey.shade200
                      : Colors.grey.shade300),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: !isUpcoming
                      ? kSuccessColor.withOpacity(0.1)
                      : kSuccessColor.withOpacity(0.2),
                ),
                child: Icon(LineAwesomeIcons.caret_up,
                    size: 18,
                    color: !isUpcoming
                        ? kSuccessColor.withOpacity(0.3)
                        : kSuccessColor),
              ),
              title: buildTitlenSubtitleText(
                  '\$$repaymentAmount',
                  !isUpcoming
                      ? kPrimaryColor.withOpacity(0.4)
                      : kPrimaryColor.withOpacity(0.8),
                  13,
                  FontWeight.bold,
                  null,
                  null),
              subtitle: buildTitlenSubtitleText(
                  isPaid
                      ? LoanStatus.PAID.toString()
                      : LoanStatus.UNPAID.toString(),
                  !isUpcoming ? Colors.grey.shade300 : Colors.grey.shade500,
                  13,
                  FontWeight.w500,
                  null,
                  null),
              trailing: isUpcoming
                  ? InkWell(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (context) => NavigationLoader(context),
                        );

                        var trxResponse =
                            await PaymentAssistant.processTransaction(
                                context, repaymentAmount, loanInfo.loanId);

                        if (trxResponse != 'Cancelled' &&
                            trxResponse != 'Failed') {
                          print(trxResponse);
                          print('Transaction successful');
                          showToast(context, 'payment successful. please wait!',
                              false);

                          RepaymentSummaryInfo _repaymentSummaryInfo =
                              RepaymentSummaryInfo(
                            loanPurpose: loanInfo.loanName,
                            loanTotal: loanInfo.contractAmount,
                            amountPaid: loanInfo.monthlyInstallment,
                            amountOwed: loanInfo.contractAmount -
                                (loanInfo.repaidAmount +
                                    loanInfo.monthlyInstallment),
                            duration: (int.parse(loanInfo.contractPeriod
                                        .split(' ')
                                        .first) -
                                    int.parse(loanInfo.upcomingRepayment
                                        .split(' ')
                                        .last))
                                .toString(),
                          );
                          Provider.of<AppData>(context, listen: false)
                              .updateRepaymentSummaryInfo(
                                  _repaymentSummaryInfo);

                          bool isSubmitted = await DatabaseService(
                                  firebaseUser: AuthService().getCurrentUser(),
                                  context: context)
                              .updateLoanInfo(
                                  '${(int.parse(loanInfo.contractPeriod.split(' ').first) - int.parse(loanInfo.upcomingRepayment.split(' ').last)).toString()} months',
                                  'CRT Month ${int.parse(loanInfo.upcomingRepayment.split(' ').last) + 1}',
                                  loanInfo.repaidAmount +
                                      loanInfo.monthlyInstallment,
                                  int.parse(loanInfo.upcomingRepayment
                                                  .split(' ')
                                                  .last) +
                                              1 ==
                                          int.parse(loanInfo.contractPeriod
                                              .split(' ')
                                              .first)
                                      ? true
                                      : false,
                                  loanInfo.docId);

                          if (isSubmitted) {
                            String header =
                                'Dear ${Provider.of<AppData>(context, listen: false).hoardUser.firstName},';
                            String body =
                                'Hoard has received $repaymentAmount towards repayment of your outstanding loan with name ${loanInfo.loanName} and contract id ${loanInfo.loanId}. '
                                'Please check your dashboard for updated loan record. Stay Jiggy!';
                            await RequestAssistant.sendMail(
                                'Loan Repayment Success', header, body);

                            showToast(context,
                                'loan status updated successfully', false);
                          }

                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) =>
                                loanRepaymentCompleteDialog(context),
                          );
                        } else if (trxResponse == 'Failed') {
                          print('Transaction Failed. Try again later');
                          Navigator.pop(context);
                          showToast(context, 'payment failed. try again later!',
                              true);
                        } else {
                          print('Transaction Cancelled');
                          Navigator.pop(context);
                          showToast(context,
                              'payment cancelled. please try again!', true);
                        }
                      },
                      child: buildTitlenSubtitleText(
                          'Pay',
                          kSuccessColor.withOpacity(0.8),
                          13,
                          FontWeight.bold,
                          null,
                          null),
                    )
                  : buildTitlenSubtitleText(
                      'Pay',
                      kSuccessColor.withOpacity(0.4),
                      13,
                      FontWeight.bold,
                      null,
                      null),
            ),
          )
        ],
      ),
    );
  }
}
