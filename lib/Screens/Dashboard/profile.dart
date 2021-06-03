import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoard/DataHandler/appData.dart';
import 'package:hoard/Models/user.dart';
import 'package:hoard/Screens/Dashboard/editProfile.dart';
import 'package:hoard/Screens/homeWrapper.dart';
import 'package:hoard/Services/firebase/auth.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/dialogs.dart';
import 'package:hoard/widgets/sharedWidgets.dart';
import 'package:hoard/widgets/text.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: kWhiteColor,
        systemNavigationBarColor: kBackgroundColor));
    double size = MediaQuery.of(context).size.height;
    HoardUser hoardUser =
        Provider.of<AppData>(context, listen: false).hoardUser;
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Container(
        height: size,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: kTopPadding(size),
              child: Container(
                margin: kSidePadding,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  hoardUser != null && hoardUser.photoUrl != ''
                      ? Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0)),
                          child: CachedNetworkImage(
                            imageUrl: hoardUser.photoUrl,
                            placeholder: (context, url) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    kPrimaryColor),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        )
                      : buildContainerIcon(Icons.person, kSuccessColor),
                  SizedBox(
                    height: 25,
                  ),
                  buildTitlenSubtitleText(
                      '${hoardUser.firstName} ${hoardUser.lastName}',
                      kPrimaryColor,
                      22,
                      FontWeight.bold,
                      null,
                      null),
                  SizedBox(
                    height: 5,
                  ),
                  buildTitlenSubtitleText(
                      '${AuthService().getCurrentUser().email}',
                      kTextSubtitleColor,
                      16,
                      FontWeight.w500,
                      null,
                      null),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile(
                                      isFromAuth: false,
                                    ))),
                        child:
                            buildProfileOptions('Edit Profile', Icons.refresh),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      InkWell(
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => NavigationLoader(context),
                          );
                          bool isLoggedOut = await AuthService().signOut();
                          if (isLoggedOut)
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeWrapper()),
                                (route) => false);
                          else {
                            showToast(context,
                                'Error occurred, try again later', true);
                            Navigator.pop(context);
                          }
                        },
                        child: buildProfileOptions('Log Out', Icons.arrow_back),
                      ),
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
                    Flexible(
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            final profileItems = [
                              buildPortfolioItem(
                                  context, LineAwesomeIcons.phone, 'Support'),
                              buildPortfolioItem(
                                context,
                                LineAwesomeIcons.file_invoice,
                                'Subscription plan',
                              ),
                              buildPortfolioItem(
                                  context,
                                  LineAwesomeIcons.credit_card,
                                  'Payment methods'),
                              buildPortfolioItem(context, LineAwesomeIcons.key,
                                  'Change password'),
                              buildPortfolioItem(
                                  context, LineAwesomeIcons.cog, 'Settings'),
                              buildPortfolioItem(
                                  context, LineAwesomeIcons.info, 'About App'),
                            ];
                            return profileItems[index];
                          },
                          itemCount: 6),
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

  buildProfileOptions(String text, IconData iconData) {
    return Column(
      children: [
        Material(
          shadowColor: Colors.grey.shade400.withOpacity(0.6),
          color: Colors.grey.shade400.withOpacity(0.6),
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              iconData,
              size: 18,
              color: kWhiteColor,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        buildTitlenSubtitleText(text, kPrimaryColor.withOpacity(0.8), 13,
            FontWeight.w500, null, null),
      ],
    );
  }

  buildPortfolioItem(
    BuildContext context,
    IconData iconData,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: kSuccessColor.withOpacity(0.1),
                ),
                child: Icon(iconData, size: 18, color: kSuccessColor),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    buildTitlenSubtitleText(
                        text,
                        kPrimaryColor.withOpacity(0.8),
                        13,
                        FontWeight.bold,
                        null,
                        null),
                    Spacer(),
                    Icon(LineAwesomeIcons.angle_right,
                        size: 15.0, color: Colors.grey.shade400),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 1.4,
                  color: kBackgroundColor,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
