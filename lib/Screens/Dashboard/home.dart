import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoard/DataHandler/appData.dart';
import 'package:hoard/Models/user.dart';
import 'package:hoard/constants.dart';
import 'package:hoard/widgets/text.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';


class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: kBackgroundColor,
        systemNavigationBarColor: kBackgroundColor));
    double size = MediaQuery
        .of(context)
        .size
        .height;

    HoardUser hoardUser = Provider
        .of<AppData>(context, listen: false)
        .hoardUser;
    List<dynamic> portfolioPositions = Provider
        .of<AppData>(context, listen: false)
        .hoardUser
        .portfolio["portfolioPositions"];
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        height: size,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: kTopPadding(size),
              child: Container(
                margin: kSidePadding,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTitlenSubtitleText(
                            'Hi, ${hoardUser.firstName} ${hoardUser.lastName}',
                            kPrimaryColor, 20,
                            FontWeight.bold, null, null),
                        SizedBox(
                          height: 10,
                        ),
                        buildTitlenSubtitleText(
                            'Welcome back to Hoard', kTextSubtitleColor, 13,
                            FontWeight.w500, null, null),
                      ],
                    ),

                    Material(
                      elevation: 8,
                      shadowColor: kPrimaryColor.withOpacity(.3),
                      color: kWhiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(LineAwesomeIcons.bell_1, size: 16,
                            color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              height: 210.0,
              margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
              padding: EdgeInsets.only(
                  left: 20, right: 20, top: 25, bottom: 10),
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      buildTitlenSubtitleText(
                          'Portfolio Value', kTextSubtitleColor, 14,
                          FontWeight.w500, null, null),

                      Container(
                        padding: EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kTextSubtitleColor),
                        ),
                        child: Icon(
                          Icons.trending_up, size: 16, color: kBlueColor,),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      buildTitlenSubtitleText('\$10,000.', kPrimaryColor, 22,
                          FontWeight.bold, null, null),

                      buildTitlenSubtitleText('00', kTextSubtitleColor, 22,
                          FontWeight.bold, null, null),
                    ],
                  ),
                  SizedBox(height: 15),

                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      buildIncreaseBlock(
                          buildTitlenSubtitleText(
                              '\$1,230.42 (320%)', kSuccessColor, 13,
                              FontWeight.bold, null, null),
                          true
                      ),

                      buildIncreaseBlock(
                          buildTitlenSubtitleText(
                              'June, 2021', kTextSubtitleColor, 13,
                              FontWeight.bold, null, null),
                          false
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(LineAwesomeIcons.apple, size: 25,
                            color: kPrimaryColor,),
                          SizedBox(width: 3,),
                          Icon(LineAwesomeIcons.amazon, size: 25,
                            color: Colors.orange,),
                          SizedBox(width: 3,),
                          buildTitlenSubtitleText('1+', kTextSubtitleColor, 15,
                              FontWeight.bold, null, null),
                        ],
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          buildBuySell(false),
                          SizedBox(width: 10,),
                          buildBuySell(true),

                        ],
                      ),

                    ],
                  ),


                ],
              ),
            ),

            Flexible(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                ),
                padding: kSidePadding,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        margin: EdgeInsets.only(bottom: 18.0),
                        color: kWhiteColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            buildTitlenSubtitleText(
                                'Explore Portfolio', kPrimaryColor, 15,
                                FontWeight.bold, null, null),

                            buildTitlenSubtitleText(
                                'View all', kSuccessColor, 13,
                                FontWeight.bold, null, null),
                          ],
                        ),
                      ),


                      Flexible(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: portfolioPositions.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            Map portfolioPosition = portfolioPositions[index];
                            if (index == 2)
                              return buildPortfolioItem(
                                  context,
                                  portfolioPosition["name"],
                                  portfolioPosition["symbol"],
                                  '${portfolioPosition["pricePerShare"]}',
                                  '${((15.67 + index) * (index + 1))
                                      .roundToDouble()}',
                                  '${portfolioPosition["equityValue"]}',
                                  '${portfolioPosition["totalQuantity"]}');
                            else if (index == 0)
                              return buildPortfolioItem(
                                  context,
                                  portfolioPosition["name"],
                                  portfolioPosition["symbol"],
                                  '${portfolioPosition["pricePerShare"]}',
                                  '${((15.67 + index) * (index + 1))
                                      .roundToDouble()}',
                                  '${portfolioPosition["equityValue"]}',
                                  '${portfolioPosition["totalQuantity"]}');
                            else if (index == 1)
                              return buildPortfolioItem(
                                  context,
                                  portfolioPosition["name"],
                                  portfolioPosition["symbol"],
                                  '${portfolioPosition["pricePerShare"]}',
                                  '${((15.67 + index) * (index + 1))
                                      .roundToDouble()}',
                                  '${portfolioPosition["equityValue"]}',
                                  '${portfolioPosition["totalQuantity"]}0');
                            else
                              return buildPortfolioItem(
                                  context,
                                  portfolioPosition["name"],
                                  portfolioPosition["symbol"],
                                  '${portfolioPosition["pricePerShare"]}',
                                  '0.00',
                                  '${portfolioPosition["equityValue"]}',
                                  '${portfolioPosition["totalQuantity"]}');
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 1.4, color: kBackgroundColor,);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildIncreaseBlock(Widget widget, bool isIncrement) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isIncrement
                ? kSuccessColor.withOpacity(0.2)
                : kTransparentColor,
            borderRadius: isIncrement ? BorderRadius.circular(2) : null,
          ),
          child: Icon(
            isIncrement ? LineAwesomeIcons.caret_up : LineAwesomeIcons.clock,
            size: isIncrement ? 12 : 16,
            color: isIncrement ? kSuccessColor : kTextSubtitleColor,),
        ),

        SizedBox(width: 3,),

        widget
      ],
    );
  }

  buildBuySell(bool isBuy) {
    return Container(
      height: 42,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: isBuy ? kBlueColor : kErrorColor.withOpacity(0.2),
      ),
      child: Center(
        child: buildTitlenSubtitleText(
            isBuy ? 'Buy' : 'Sell', isBuy ? kWhiteColor : kErrorColor, 15,
            FontWeight.bold, null, null),
      ),
    );
  }

  buildPortfolioItem(BuildContext context, String stockName, String ticker,
      String pricePerShare, String percentIncrease, String equity,
      String shareQuantity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Row(
            children: [

              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: AssetImage('assets/images/forex4.jpg'),
                      fit: BoxFit.cover,
                    )
                ),
              ),
              SizedBox(width: 10.0,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTitlenSubtitleText(
                      stockName, kPrimaryColor.withOpacity(0.8), 13,
                      FontWeight.bold, null, null),
                  SizedBox(
                    height: 10.0,
                  ),
                  buildTitlenSubtitleText(ticker, kTextSubtitleColor, 13,
                      FontWeight.w500, null, null),
                ],
              ),
            ],
          ),


          Row(
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: kSuccessColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(LineAwesomeIcons.caret_up, size: 12,
                            color: kSuccessColor),
                      ),
                      SizedBox(width: 3,),

                      buildTitlenSubtitleText(
                          '\$$pricePerShare', kPrimaryColor.withOpacity(0.8),
                          13,
                          FontWeight.bold, null, null),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  buildTitlenSubtitleText(
                      '$percentIncrease%', kTextSubtitleColor, 13,
                      FontWeight.w500, null, null),
                ],
              ),
              SizedBox(width: 25,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildTitlenSubtitleText(
                      '\$$equity', kPrimaryColor.withOpacity(0.8), 13,
                      FontWeight.bold, null, null),
                  SizedBox(
                    height: 10.0,
                  ),
                  buildTitlenSubtitleText(
                      '$shareQuantity shares', kTextSubtitleColor, 13,
                      FontWeight.w500, null, null),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }
}


