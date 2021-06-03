import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoard/DataHandler/appData.dart';
import 'package:hoard/Models/loan.dart';
import 'package:hoard/Services/firebase/auth.dart';
import 'package:hoard/Services/firebase/firestore.dart';
import 'package:hoard/Services/requestAssistant.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/buttons.dart';
import 'package:hoard/widgets/dialogs.dart';
import 'package:hoard/widgets/text.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RepaymentSchedule extends StatelessWidget {
  const RepaymentSchedule({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: kPrimaryColor,
        systemNavigationBarColor: kBackgroundColor));
    double size = MediaQuery.of(context).size.height;
    LoanInfo postLoan =
        Provider.of<AppData>(context, listen: false).postLoan ?? LoanInfo();

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Container(
        height: size,
        child: Column(
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
                        postLoan.loanId,
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
              margin: kSidePadding,
              padding:
                  EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildTitlenSubtitleText(postLoan.loanName, kPrimaryColor,
                      18.0, FontWeight.bold, TextAlign.center, null),
                  SizedBox(
                    height: 20,
                  ),
                  buildTitlenSubtitleText(
                      'Remaining to be repaid:',
                      Colors.grey.shade400,
                      13.0,
                      FontWeight.w500,
                      TextAlign.center,
                      null),
                  SizedBox(
                    height: 10,
                  ),
                  buildTitlenSubtitleText('\$${postLoan.contractAmount}',
                      kPrimaryColor, 30, FontWeight.bold, null, null),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      buildScheduleItem(
                          'Paid to date:',
                          '\$0.00',
                          'Monthly payment:',
                          '\$${postLoan.monthlyInstallment}'),
                      SizedBox(
                        height: 20,
                      ),
                      buildScheduleItem(
                          'Contract amount:',
                          '\$${postLoan.contractAmount}',
                          'Total interest:',
                          '\$0.00'),
                      SizedBox(
                        height: 20,
                      ),
                      buildScheduleItem(
                          'Contract period:',
                          '${postLoan.contractPeriod}',
                          'To end:',
                          '${postLoan.expiryPeriod}'),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                ),
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitlenSubtitleText('Payment options', kPrimaryColor,
                          15, FontWeight.bold, null, null),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        elevation: 0.5,
                        shadowColor: kBackgroundColor,
                        color: kWhiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 15.0, bottom: 8.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildTitlenSubtitleText(
                                      'AutoPay: On',
                                      kPrimaryColor,
                                      15,
                                      FontWeight.bold,
                                      null,
                                      null),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  buildTitlenSubtitleText(
                                      'Card: *3284',
                                      Colors.grey.shade400,
                                      11.0,
                                      FontWeight.w500,
                                      TextAlign.center,
                                      null),
                                ],
                              ),
                              Spacer(),
                              Switch(
                                value: true,
                                onChanged: (val) {
                                  print(val);
                                },
                                activeColor: kWhiteColor,
                                activeTrackColor: kSuccessColor,
                                inactiveTrackColor: kBackgroundColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => NavigationLoader(context),
                          );

                          bool isSaved = await DatabaseService(
                                  firebaseUser: AuthService().getCurrentUser(),
                                  context: context)
                              .saveLoanRequest();
                          if (isSaved) {
                            showToast(
                                context, 'loan request successful', false);

                            String header =
                                'Dear ${Provider.of<AppData>(context, listen: false).hoardUser.firstName},';
                            String body =
                                'Your loan request of ${postLoan.contractAmount} was received and is currently being processed. '
                                'You should receive an alert from Hoard soon. Stay Jiggy!';
                            await RequestAssistant.sendMail(
                                'Loan Request Success', header, body);

                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => loanCompleteDialog(context),
                            );
                          } else {
                            Navigator.pop(context);
                            showToast(context,
                                'loan request failed. try later!', true);
                          }
                        },
                        child: buildSubmitButton('Submit Request'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildScheduleItem(
      String title, String subtitle, String title2, String subtitle2) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitlenSubtitleText(title, Colors.grey.shade400, 13.0,
                FontWeight.w500, TextAlign.start, null),
            SizedBox(
              height: 8.0,
            ),
            buildTitlenSubtitleText(
                subtitle, kPrimaryColor, 20, FontWeight.bold, null, null),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            buildTitlenSubtitleText(title2, Colors.grey.shade400, 13.0,
                FontWeight.w500, TextAlign.start, null),
            SizedBox(
              height: 10.0,
            ),
            buildTitlenSubtitleText(
                subtitle2, kPrimaryColor, 20, FontWeight.bold, null, null),
          ],
        ),
      ],
    );
  }
}
