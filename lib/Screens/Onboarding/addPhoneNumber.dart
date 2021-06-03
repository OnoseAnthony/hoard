import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoard/Services/firebase/auth.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/buttons.dart';
import 'package:hoard/widgets/dialogs.dart';
import 'package:hoard/widgets/text.dart';
import 'package:hoard/widgets/textformfield.dart';

class AddPhoneNumber extends StatefulWidget {
  @override
  _AddPhoneNumberState createState() => _AddPhoneNumberState();
}

class _AddPhoneNumberState extends State<AddPhoneNumber> {
  final _formKey = GlobalKey<FormState>();
  var phoneDialCode = '+234';
  TextEditingController _controller = TextEditingController();
  bool value = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        padding: kPrimaryPadding(size),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitlenSubtitleText('Enter your number', kPrimaryColor, 16,
                    FontWeight.w600, TextAlign.start, null),
                SizedBox(
                  height: 10,
                ),
                buildTitlenSubtitleText(
                    'We will send a code to verify your mobile number',
                    kTextSubtitleColor,
                    13,
                    FontWeight.normal,
                    TextAlign.start,
                    null),
                SizedBox(
                  height: 30,
                ),
                buildPhoneNumberTextField(
                    'Phone number', _controller, buildCountryDropDown()),
                SizedBox(
                  height: 100,
                ),
                Row(
                  children: [
                    Checkbox(
                      activeColor: kSuccessColor,
                      checkColor: kWhiteColor,
                      value: value,
                      onChanged: (bool) {
                        setState(() {
                          value = bool;
                        });
                      },
                    ),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'I have read and accepted all ',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  color: kTextSubtitleColor,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            TextSpan(
                                text: 'Hoard\'s terms and conditions',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 12,
                                    color: kTextSubtitleColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      isDismissible: false,
                                      enableDrag: false,
                                      builder: (context) => Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: Container(),
                                      ),
                                    );
                                  }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState.validate() && value) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => NavigationLoader(context));
                      final phoneNumber =
                          phoneDialCode.trim() + _controller.text.trim();
                      AuthService().phoneAuthentication(phoneNumber, context);
                    } else if (!value)
                      showToast(context,
                          'please accept the terms and conditions', true);
                  },
                  child: buildSubmitButton('NEXT'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildCountryDropDown() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CountryListPick(
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              title: Text('Select Country'),
            ),

            // To disable option set to false
            theme: CountryTheme(
              isShowFlag: true,
              isShowTitle: false,
              isShowCode: true,
              isDownIcon: true,
              showEnglishName: true,
            ),
            // Set default value
            initialSelection: '+234',
            onChanged: (CountryCode code) {
              setState(() {
                phoneDialCode = code.dialCode;
              });
            },
          ),
          SizedBox(
            width: 2,
          ),
          Container(
            height: 25,
            child: VerticalDivider(color: kGreyColor, thickness: 2),
          ),
        ],
      ),
    );
  }
}
