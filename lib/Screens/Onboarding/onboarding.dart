import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoard/Models/onboarding.dart';
import 'package:hoard/Screens/homeWrapper.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/text.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  List<OnboardingModel> list = OnboardingModel.list;
  var _controller = PageController();
  var initialPage = 0;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;

    _controller.addListener(() {
      setState(() {
        initialPage = _controller.page.round();
      });
    });
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          Container(
            padding: kPrimaryPadding(size),
            child: buildContent(_controller),
          ),
          Positioned(
            left: 20,
            top: size * 0.07,
            right: 20,
            child: buildAppBar(context),
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: buildBottomBar(),
          ),
        ],
      ),
    );
  }

  buildAppBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        initialPage != 0
            ? InkWell(
                onTap: () {
                  if (initialPage > 0)
                    _controller.animateToPage(initialPage - 1,
                        duration: Duration(microseconds: 500),
                        curve: Curves.easeIn);
                },
                child: Icon(
                  LineAwesomeIcons.arrow_left,
                  size: 27,
                  color: kPrimaryColor,
                ),
              )
            : Icon(null),
        initialPage != list.length - 1
            ? InkWell(
                onTap: () {
                  if (initialPage < list.length)
                    _controller.animateToPage(list.length,
                        duration: Duration(microseconds: 500),
                        curve: Curves.easeInOut);
                },
                child: buildTitlenSubtitleText('Skip', kPrimaryColor, 16.0,
                    FontWeight.bold, TextAlign.end, null))
            : Icon(null),
      ],
    );
  }

  buildContent(PageController controller) {
    return PageView.builder(
        controller: controller,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _displayImage(list[index].imagePath),
              _displayText(list[index].title, list[index].subtitle),
            ],
          );
        });
  }

  _displayImage(String imagePath) {
    return Container(
      height: 300,
      margin: EdgeInsets.only(top: 60, bottom: 30),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(imagePath), fit: BoxFit.scaleDown)),
    );
  }

  _displayText(String title, String subtitle) {
    return Column(
      children: [
        buildTitlenSubtitleText(
            title, kPrimaryColor, 22, FontWeight.bold, TextAlign.center, null),
        SizedBox(
          height: 20,
        ),
        buildTitlenSubtitleText(subtitle, kTextSubtitleColor, 14,
            FontWeight.normal, TextAlign.center, null),
      ],
    );
  }

  buildBottomBar() {
    Widget widget;
    if (initialPage != list.length - 1)
      widget = Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < list.length; i++)
              i == initialPage
                  ? _buildPageIndicator(true)
                  : _buildPageIndicator(false),
            Spacer(),
            _indicator(),
          ],
        ),
      );
    else
      widget = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _circularIndicator(),
        ],
      );
    return widget;
  }

  _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.only(right: 6.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? kSuccessColor : kSuccessColor.withOpacity(0.2),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  _indicator() {
    return Container(
      width: 60,
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 2.9,
                valueColor: AlwaysStoppedAnimation(kSuccessColor),
                value: (initialPage + 1) / (list.length),
                backgroundColor: kGreyColor,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                if (initialPage < list.length)
                  _controller.animateToPage(initialPage + 1,
                      duration: Duration(microseconds: 500),
                      curve: Curves.easeIn);
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: kSuccessColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                child: Icon(
                  LineAwesomeIcons.arrow_right,
                  color: kWhiteColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _circularIndicator() {
    return Container(
      width: 60,
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 2.9,
                valueColor: AlwaysStoppedAnimation(kSuccessColor),
                value: 100,
                backgroundColor: kTextSubtitleColor,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () async {
                storage.write(key: 'isFirstTime', value: 'true');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeWrapper()));
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: kSuccessColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                child: Icon(
                  LineAwesomeIcons.arrow_right,
                  color: kWhiteColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
