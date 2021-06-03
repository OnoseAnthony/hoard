import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/text.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      color: kSuccessColor,
      size: 30.0,
    );
  }
}

buildContainerImage(File imagePath, Color color) {
  if (imagePath != null)
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        image: DecorationImage(image: FileImage(imagePath), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(25.0),
      ),
    );
  else
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
    );
}

buildContainerIcon(IconData iconData, Color color) {
  return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: color,
      ),
      child: Icon(iconData, size: 40, color: kWhiteColor));
}

getDrawerNavigator(context, double size, String title) {
  return Positioned(
    top: size * 0.07,
    left: 15.0,
    child: InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        children: [
          Icon(LineAwesomeIcons.times, size: 20, color: kPrimaryColor),
          SizedBox(
            width: 25,
          ),
          buildTitlenSubtitleText(
              title, Colors.black, 18, FontWeight.w600, TextAlign.start, null),
        ],
      ),
    ),
  );
}
