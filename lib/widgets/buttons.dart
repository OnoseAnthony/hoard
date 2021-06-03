import 'package:flutter/material.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/text.dart';

buildSubmitButton(String text) {
  return Container(
    height: 50,
    padding: EdgeInsets.symmetric(horizontal: 13),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      color: kSuccessColor,
    ),
    child: Center(
        child: buildTitlenSubtitleText(
            text, kWhiteColor, 15.0, FontWeight.bold, TextAlign.center, null)),
  );
}
