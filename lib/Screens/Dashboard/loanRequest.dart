import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoard/Screens/Dashboard/loanRepaymentSchedule.dart';
import 'package:hoard/Utils/loanRequestHelper.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/buttons.dart';
import 'package:hoard/widgets/dialogs.dart';
import 'package:hoard/widgets/text.dart';
import 'package:hoard/widgets/textformfield.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class LoanRequest extends StatefulWidget {
  const LoanRequest({Key key}) : super(key: key);

  @override
  _LoanRequestState createState() => _LoanRequestState();
}

class _LoanRequestState extends State<LoanRequest> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController loanNameController = TextEditingController();
  int borrowAmount = 7000;
  int duration = 6;

  @override
  void dispose() {
    loanNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: kPrimaryColor,
        systemNavigationBarColor: kBackgroundColor));
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        height: size,
        child: SingleChildScrollView(
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
                          'Loan Calculator',
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
              Card(
                elevation: 2.0,
                color: kWhiteColor,
                margin:
                    EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
                shadowColor: kBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTitlenSubtitleText(
                                'Loan Name',
                                kPrimaryColor.withOpacity(0.7),
                                13,
                                FontWeight.w500,
                                null,
                                null),
                            buildTextField('', loanNameController),
                            SizedBox(
                              height: 30,
                            ),
                            buildTitlenSubtitleText(
                                'Borrowed Amount',
                                kPrimaryColor.withOpacity(0.7),
                                13,
                                FontWeight.w500,
                                null,
                                null),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                buildTitlenSubtitleText(
                                    '\$$borrowAmount.',
                                    kPrimaryColor,
                                    25,
                                    FontWeight.bold,
                                    null,
                                    null),
                                buildTitlenSubtitleText('00', kPrimaryColor, 25,
                                    FontWeight.bold, null, null),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 8.0),
                          trackHeight: 5.0,
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 20.0),
                          overlayColor: kSuccessColor.withOpacity(0.04),
                        ),
                        child: Slider(
                            value: borrowAmount.toDouble(),
                            min: 200,
                            max: 10000,
                            activeColor: kSuccessColor,
                            inactiveColor: kBackgroundColor,
                            onChanged: (double newValue) {
                              setState(() {
                                borrowAmount = newValue.round();
                              });
                            }),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, bottom: 20, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTitlenSubtitleText(
                                '\$300',
                                kPrimaryColor.withOpacity(0.7),
                                13,
                                FontWeight.w500,
                                null,
                                null),
                            buildTitlenSubtitleText(
                                '\$10,000',
                                kPrimaryColor.withOpacity(0.7),
                                13,
                                FontWeight.w500,
                                null,
                                null),
                          ],
                        ),
                      ),
                      Container(
                        height: 1.4,
                        color: kBackgroundColor,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildTitlenSubtitleText(
                                'Repayment Period',
                                kPrimaryColor.withOpacity(0.7),
                                13,
                                FontWeight.w500,
                                null,
                                null),
                            SizedBox(
                              height: 8,
                            ),
                            buildTitlenSubtitleText('$duration Months',
                                kPrimaryColor, 25, FontWeight.bold, null, null),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 8.0),
                          trackHeight: 5.0,
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 20.0),
                          overlayColor: kSuccessColor.withOpacity(0.04),
                        ),
                        child: Slider(
                            divisions: 7,
                            value: duration.toDouble(),
                            min: 3,
                            max: 24,
                            activeColor: kSuccessColor,
                            inactiveColor: kBackgroundColor,
                            onChanged: (double newValue) {
                              setState(() {
                                duration = newValue.round();
                              });
                            }),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, bottom: 20, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildTitlenSubtitleText(
                                '3 months',
                                kPrimaryColor.withOpacity(0.7),
                                13,
                                FontWeight.w500,
                                null,
                                null),
                            buildTitlenSubtitleText(
                                '24 months',
                                kPrimaryColor.withOpacity(0.7),
                                13,
                                FontWeight.w500,
                                null,
                                null),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4.0,
                color: kWhiteColor,
                margin: EdgeInsets.only(left: 30, right: 30, top: 10.0),
                shadowColor: kBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTitlenSubtitleText(
                          'Monthly cost for $duration months',
                          kPrimaryColor.withOpacity(0.7),
                          13,
                          FontWeight.w500,
                          null,
                          null),
                      SizedBox(
                        height: 8,
                      ),
                      buildTitlenSubtitleText('\$0.00', kPrimaryColor, 25,
                          FontWeight.bold, null, null),
                      SizedBox(
                        height: 13,
                      ),
                      buildTitlenSubtitleText(
                          'You are borrowing \$$borrowAmount over $duration months at 0% interest rate with'
                          ' a total loan cost of \$0.00. No added fees.',
                          kPrimaryColor.withOpacity(0.7),
                          12,
                          FontWeight.normal,
                          TextAlign.start,
                          null),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: kSidePadding,
                child: InkWell(
                  onTap: () async {
                    if (_formKey.currentState.validate()) {
                      if (checkLoanLimit(context, borrowAmount.toDouble())) {
                        showToast(context,
                            'loan amount exceeds 60% of portfolio', true);
                      } else {
                        createPaymentSchedule(
                            context,
                            loanNameController.text.trim(),
                            borrowAmount.toDouble(),
                            duration);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => RepaymentSchedule()));
                      }
                    }
                  },
                  child: buildSubmitButton('Continue'),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
