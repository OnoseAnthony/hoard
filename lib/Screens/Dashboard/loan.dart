import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoard/Models/loan.dart';
import 'package:hoard/Screens/Dashboard/loanDetails.dart';
import 'package:hoard/Screens/Dashboard/loanRequest.dart';
import 'package:hoard/Services/firebase/auth.dart';
import 'package:hoard/Services/firebase/firestore.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/dialogs.dart';
import 'package:hoard/widgets/text.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Loan extends StatelessWidget {
  const Loan({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: kPrimaryColor,
        systemNavigationBarColor: kBackgroundColor));
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        height: size,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: kTopPadding(size),
              child: Container(
                margin: kSidePadding,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitlenSubtitleText('Digital Loans', kWhiteColor,
                            20, FontWeight.bold, null, null),
                        SizedBox(
                          height: 10,
                        ),
                        buildTitlenSubtitleText(
                            'Request now, pay later',
                            kTextSubtitleColor,
                            13,
                            FontWeight.w500,
                            null,
                            null),
                      ],
                    ),
                    Material(
                      elevation: 8,
                      shadowColor: kPrimaryColor.withOpacity(.3),
                      color: Colors.grey.shade700.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(LineAwesomeIcons.info,
                            size: 16, color: kSuccessColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 160.0,
              margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildTitlenSubtitleText('PAY WITHIN 6 OR 12 MONTHS',
                      kBackgroundColor, 14, FontWeight.w500, null, null),
                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      buildTitlenSubtitleText('Transaction Limit',
                          kBackgroundColor, 13, FontWeight.w500, null, null),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          buildTitlenSubtitleText('\$6,000.', kWhiteColor, 22,
                              FontWeight.bold, null, null),
                          buildTitlenSubtitleText('00', kWhiteColor, 22,
                              FontWeight.bold, null, null),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, bottom: 30),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  buildLoanOptions(false, Icons.history_toggle_off, context),
                  SizedBox(
                    width: 20,
                  ),
                  buildLoanOptions(false, LineAwesomeIcons.wallet, context),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => LoanRequest())),
                      child: buildLoanOptions(true, null, context),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                ),
                padding: kSidePadding,
                child: Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0),
                        color: kWhiteColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            buildTitlenSubtitleText('Recent Loans',
                                kPrimaryColor, 18, FontWeight.bold, null, null),
                            buildTitlenSubtitleText('View all', kSuccessColor,
                                13, FontWeight.bold, null, null),
                          ],
                        ),
                      ),
                      Flexible(
                        child: FutureBuilder(
                          future: DatabaseService(
                                  firebaseUser: AuthService().getCurrentUser(),
                                  context: context)
                              .getUserLoanList(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              List<LoanInfo> loanRequestList = snapshot.data;
                              if (snapshot.data != null &&
                                  loanRequestList.length >= 1) {
                                return ListView.separated(
                                  itemCount: loanRequestList.length,
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    LoanInfo loan = loanRequestList[index];
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => LoanDetail(
                                                    loanInfo: loan)));
                                      },
                                      child: buildPortfolioItem(
                                          context,
                                          loan.loanName,
                                          loan.contractFormattedDate,
                                          '\$${loan.repaidAmount}',
                                          '${loan.isFullyPaid}',
                                          '\$${loan.contractAmount}',
                                          loan.contractPeriod),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      height: 1.4,
                                      color: kBackgroundColor,
                                    );
                                  },
                                );
                              } else {
                                return buildNullFutureBuilderItem(
                                    context, 'loan');
                              }
                            } else {
                              return Container(
                                child: Center(
                                  child: loaderContainer(),
                                ),
                              );
                            }
                          },
                        ),
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

  buildPortfolioItem(context, String loanName, String date, String amountPaid,
      String status, String loanAmount, String duration) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.deepOrangeAccent.withOpacity(0.2),
                ),
                child: Icon(LineAwesomeIcons.caret_down,
                    size: 18, color: Colors.deepOrangeAccent),
              ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTitlenSubtitleText(
                      loanName,
                      kPrimaryColor.withOpacity(0.8),
                      13,
                      FontWeight.bold,
                      null,
                      null),
                  SizedBox(
                    height: 10.0,
                  ),
                  buildTitlenSubtitleText(date, kTextSubtitleColor, 13,
                      FontWeight.w500, null, null),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTitlenSubtitleText(
                      '$amountPaid',
                      kPrimaryColor.withOpacity(0.8),
                      13,
                      FontWeight.bold,
                      null,
                      null),
                  SizedBox(
                    height: 10.0,
                  ),
                  buildTitlenSubtitleText(status, kTextSubtitleColor, 13,
                      FontWeight.w500, null, null),
                ],
              ),
              SizedBox(
                width: 25,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTitlenSubtitleText(
                      '$loanAmount',
                      kPrimaryColor.withOpacity(0.8),
                      13,
                      FontWeight.bold,
                      null,
                      null),
                  SizedBox(
                    height: 10.0,
                  ),
                  buildTitlenSubtitleText('$duration', kTextSubtitleColor, 13,
                      FontWeight.w500, null, null),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildLoanOptions(bool isApply, IconData iconData, BuildContext context) {
    return Container(
      height: 55,
      width: !isApply ? 55 : MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey.shade700.withOpacity(0.4)),
      child: !isApply
          ? Icon(
              iconData,
              size: 23,
              color: kWhiteColor,
            )
          : Center(
              child: buildTitlenSubtitleText('Apply for a loan',
                  kBackgroundColor, 15, FontWeight.bold, null, null),
            ),
    );
  }

  buildNullFutureBuilderItem(context, label) {
    return Container(
        child: Center(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 2,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                buildTitlenSubtitleText(
                    label == 'loan'
                        ? 'No Loan Request'
                        : label == 'notification'
                            ? 'No Notification'
                            : 'No Promotion',
                    Colors.black,
                    13,
                    FontWeight.bold,
                    TextAlign.center,
                    null),
                SizedBox(
                  height: 5,
                ),
                buildTitlenSubtitleText(
                    label == 'loan' ? 'No recent loan request' : '',
                    kGreyColor,
                    13,
                    FontWeight.normal,
                    TextAlign.center,
                    null),
              ],
            ),
          ),
        ),
      ],
    )));
  }
}
