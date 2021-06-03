import 'package:hoard/Services/firebase/auth.dart';
import 'package:hoard/constants.dart';
import 'package:mailer2/mailer.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class RequestAssistant {
  static Future<dynamic> sendSms(String messageBody) async {
    TwilioFlutter twilioFlutter = TwilioFlutter(
        accountSid: kTwilioAcountId,
        authToken: kTwilioAuthToken,
        twilioNumber: kTwilioNumber);

    await twilioFlutter.sendSMS(
        toNumber: AuthService().getCurrentUser().phoneNumber,
        messageBody: messageBody);
  }

  static Future<dynamic> sendMail(
      String subject, String messageHeader, String messageBody) {
    var options = new YahooSmtpOptions()
      ..username = kYahooID
      ..password = kYahooToken;

    var emailTransport = new SmtpTransport(options);

    var envelope = new Envelope()
      ..from = kYahooID
      ..recipients.add(AuthService().getCurrentUser().email)
      ..subject = subject
      ..fromName = 'Anthony From Hoard'
      ..text = 'This is a cool email message. Whats up? 語'
      ..html = "<h1>$messageHeader</h1><p>$messageBody</p>";

    emailTransport
        .send(envelope)
        .then((envelope) => print('Email sent!'))
        .catchError((e) => print('Error occurred: $e'));
  }
}
