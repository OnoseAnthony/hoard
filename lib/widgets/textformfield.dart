import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoard/constants.dart';

buildTextField(String hintText, TextEditingController controller) {
  return Container(
    child: TextFormField(
      keyboardType: TextInputType.text,
      controller: controller,
      validator: (val) => val.isEmpty ? 'Field cannot be empty' : null,
      inputFormatters: [],
      decoration: InputDecoration(
          suffixIcon: null,
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 13,
          ),
          contentPadding: EdgeInsets.only(top: 15.0, bottom: 5.0)),
    ),
  );
}

buildVerifyPhoneNumberField(TextEditingController controller, context) {
  return Container(
    width: 35,
    height: 35,
    decoration: BoxDecoration(
      color: kWhiteColor,
      borderRadius: BorderRadius.circular(3),
      boxShadow: [
        BoxShadow(
          color: kGreyColor,
          blurRadius: 0.25,
        )
      ],
    ),
    child: TextFormField(
      onChanged: (val) {},
      keyboardType: TextInputType.number,
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        new LengthLimitingTextInputFormatter(1),
      ],
      validator: (val) => val.isEmpty ? 'Field Cannot be empty' : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 15, bottom: 10),
        hintStyle: TextStyle(fontSize: 13),
        border: InputBorder.none,
      ),
    ),
  );
}

buildPhoneNumberTextField(
    String hintText, TextEditingController controller, Widget prefixIcon) {
  return Container(
    child: TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (val) {},
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        new LengthLimitingTextInputFormatter(10),
      ],
      validator: (val) => val.isEmpty ? 'Field Cannot be empty' : null,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: kBlackColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBlackColor),
        ),
      ),
    ),
  );
}
