import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hoard/DataHandler/appData.dart';
import 'package:hoard/Models/user.dart';
import 'package:hoard/Screens/homeWrapper.dart';
import 'package:hoard/Services/firebase/auth.dart';
import 'package:hoard/Services/firebase/firestore.dart';
import 'package:hoard/Services/firebase/storage.dart';
import 'package:hoard/Utils/portfolioHelper.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/buttons.dart';
import 'package:hoard/widgets/dialogs.dart';
import 'package:hoard/widgets/sharedWidgets.dart';
import 'package:hoard/widgets/text.dart';
import 'package:hoard/widgets/textformfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  bool isFromAuth;

  EditProfile({@required this.isFromAuth});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  File staticProfileImage;
  HoardUser hoardUser;

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailAddressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    hoardUser = widget.isFromAuth
        ? null
        : Provider.of<AppData>(context, listen: false).hoardUser;
    if (widget.isFromAuth)
      return Scaffold(
        backgroundColor: kWhiteColor,
        body: Stack(
          children: [
            Container(
              height: size,
              padding: EdgeInsets.only(left: 40, right: 40, top: size * 0.12),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () async {
                          var image = await ImagePicker.pickImage(
                              source: ImageSource.gallery, imageQuality: 65);
                          setState(() {
                            staticProfileImage = image;
                          });
                        },
                        child: staticProfileImage != null
                            ? buildContainerImage(
                                staticProfileImage, kGreyColor)
                            : buildContainerIcon(Icons.person, kSuccessColor),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildTitlenSubtitleText(
                          'Update Profile Info',
                          kPrimaryColor,
                          18,
                          FontWeight.w700,
                          TextAlign.center,
                          null),
                      SizedBox(
                        height: 50,
                      ),
                      buildTextField('First Name', firstNameController),
                      SizedBox(
                        height: 40,
                      ),
                      buildTextField('Last Name', lastNameController),
                      SizedBox(
                        height: 40,
                      ),
                      buildTextField('Email Address', emailAddressController),
                      SizedBox(
                        height: 80,
                      ),
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState.validate() &&
                              staticProfileImage != null) {
                            showDialog(
                              context: context,
                              builder: (context) => NavigationLoader(context),
                            );

                            await AuthService().updateUserEmailAddress(
                                emailAddressController.text.trim(), context);

                            bool isSubmitted = await DatabaseService(
                                    firebaseUser:
                                        AuthService().getCurrentUser(),
                                    context: context)
                                .updatehoardUserData(
                                    firstNameController.text.trim(),
                                    lastNameController.text.trim(),
                                    await getAndUploadProfileImage(
                                        staticProfileImage),
                                    getPorfolio());

                            if (isSubmitted) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeWrapper()));
                            } else {
                              Navigator.pop(context);
                              showToast(context,
                                  'Error occurred. try again later!!', true);
                            }
                          } else if (_formKey.currentState.validate() &&
                              staticProfileImage == null) {
                            showDialog(
                              context: context,
                              builder: (context) => NavigationLoader(context),
                            );

                            await AuthService().updateUserEmailAddress(
                                emailAddressController.text.trim(), context);
                            bool isSubmitted = await DatabaseService(
                                    firebaseUser:
                                        AuthService().getCurrentUser(),
                                    context: context)
                                .updatehoardUserData(
                                    firstNameController.text.trim(),
                                    lastNameController.text.trim(),
                                    '',
                                    getPorfolio());

                            if (isSubmitted) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeWrapper()));
                            } else {
                              Navigator.pop(context);
                              showToast(context,
                                  'Error occurred. try again later!!', true);
                            }
                          }
                        },
                        child: buildSubmitButton('NEXT'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    else
      return Scaffold(
        backgroundColor: kWhiteColor,
        body: Stack(
          children: [
            Container(
              height: size,
              padding: EdgeInsets.only(left: 40, right: 40, top: size * 0.14),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () async {
                          var image = await ImagePicker.pickImage(
                              source: ImageSource.gallery, imageQuality: 65);
                          setState(() {
                            staticProfileImage = image;
                          });
                        },
                        child: staticProfileImage == null &&
                                hoardUser != null &&
                                hoardUser.photoUrl != ''
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
                            : staticProfileImage != null
                                ? buildContainerImage(
                                    staticProfileImage, kGreyColor)
                                : buildContainerIcon(
                                    Icons.person, kSuccessColor),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildTitlenSubtitleText(
                          hoardUser != null
                              ? '${hoardUser.firstName} ${hoardUser.lastName}'
                              : 'Welcome, User',
                          kPrimaryColor,
                          18,
                          FontWeight.w700,
                          TextAlign.center,
                          null),
                      SizedBox(
                        height: 50,
                      ),
                      buildTextField(
                          hoardUser != null
                              ? '${hoardUser.firstName}'
                              : 'First Name',
                          firstNameController),
                      SizedBox(
                        height: 40,
                      ),
                      buildTextField(
                          hoardUser != null
                              ? '${hoardUser.lastName}'
                              : 'Last Name',
                          lastNameController),
                      SizedBox(
                        height: 40,
                      ),
                      buildTextField(
                          AuthService().getCurrentUser().email ??
                              'Email Address',
                          emailAddressController),
                      SizedBox(
                        height: 80,
                      ),
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState.validate() &&
                              staticProfileImage != null) {
                            showDialog(
                              context: context,
                              builder: (context) => NavigationLoader(context),
                            );

                            AuthService().updateUserEmailAddress(
                                emailAddressController.text.trim(), context);
                            bool isSubmitted = await DatabaseService(
                                    firebaseUser:
                                        AuthService().getCurrentUser(),
                                    context: context)
                                .updatehoardUserData(
                                    firstNameController.text.trim() ??
                                        hoardUser.firstName,
                                    lastNameController.text.trim() ??
                                        hoardUser.lastName,
                                    await getAndUploadProfileImage(
                                        staticProfileImage),
                                    hoardUser.portfolio);

                            if (isSubmitted) {
                              Navigator.pop(context);
                              showToast(context, 'profile updated successfully',
                                  false);
                            } else {
                              Navigator.pop(context);
                              showToast(context,
                                  'Error occurred. try again later!!', true);
                            }
                          } else if (_formKey.currentState.validate() &&
                              staticProfileImage == null) {
                            showDialog(
                              context: context,
                              builder: (context) => NavigationLoader(context),
                            );

                            AuthService().updateUserEmailAddress(
                                emailAddressController.text.trim(), context);
                            bool isSubmitted = await DatabaseService(
                                    firebaseUser:
                                        AuthService().getCurrentUser(),
                                    context: context)
                                .updatehoardUserData(
                                    firstNameController.text.trim() ??
                                        hoardUser.firstName,
                                    lastNameController.text.trim() ??
                                        hoardUser.lastName,
                                    hoardUser.photoUrl,
                                    hoardUser.portfolio);

                            if (isSubmitted) {
                              Navigator.pop(context);
                              showToast(context, 'profile updated successfully',
                                  false);
                            } else {
                              Navigator.pop(context);
                              showToast(context,
                                  'Error occurred. try again later!!', true);
                            }
                          }
                        },
                        child: buildSubmitButton('SAVE'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            getDrawerNavigator(context, size, 'Edit Profile'),
          ],
        ),
      );
  }
}
