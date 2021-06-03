# hoard

Project Ope

## Getting Started

This project is a minimal stock display and loan request/repayment application built for the Trove Engineering Challenge.

A few resources to get started if you clone this Flutter project:

- Run flutter pub get in the project

Provide all required keys in the Constants.dart file

Create an account on the Flutterwave Developer Service to get the following keys

- String kRavePublicKey = "kRavePublicKey"; //Flutterwave Public key for accepting payments
- String kRaveEncryptionKey = "kRaveEncryptionKey"; //Flutterwave encryption key for accepting payments

For sending notifications one of the following or both can be used

Create an account on the Twilio Web Service to get the following keys

- String kTwilioAcountId = "kTwilioAcountId"; //Twilio account id for sending sms notifications
- String kTwilioAuthToken = "kTwilioAuthToken"; //Twilio authentication token for sending sms notifications
- String kTwilioNumber = "kTwilioNumber"; //Your Twilio number for sending sms notifications

Create an account on the Yahoo Service to get the following keys. PS - Create an OTP for hoard on the yahoo account for this to work.
- String kYahooID = "Yahoo Email Address"; //Your Yahoo mail address for sending email notifications
- String kYahooToken = "Yahoo App Password";  //Your generated yahoo password for sending email notifications

All systems go? Use Flutter run to start project
