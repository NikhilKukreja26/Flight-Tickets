import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/home_page_top_container.dart';
import '../widgets/custom_app_bottom_bar.dart';

var viewAllStyle = TextStyle(
  fontSize: 14.0,
  color: appTheme.primaryColor,
);

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomAppBottomBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            HomePageTopContainer(),
            homeScreenBottomPart,
          ],
        ),
      ),
    );
  }

  final homeScreenBottomPart = Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Text(
              'Currently Watched Items',
              style: dropDownMenuItemStyle,
            ),
            Spacer(),
            Text(
              'VIEW ALL (12)',
              style: viewAllStyle,
            ),
          ],
        ),
      ),
      Container(
        height: 240.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: cityCards,
        ),
      ),
    ],
  );
}

List<CityCard> cityCards = [
  CityCard(
    imagePath: 'assets/images/athens.jpg',
    cityName: 'Athens',
    monthYear: 'Apr 2020',
    discount: '40',
    oldPrice: '9999',
    newPrice: '4999',
  ),
  CityCard(
    imagePath: 'assets/images/lasvegas.jpg',
    cityName: 'Las Vegas',
    monthYear: 'Feb 2020',
    discount: '45',
    oldPrice: '4299',
    newPrice: '2250',
  ),
  CityCard(
    imagePath: 'assets/images/sydney.jpeg',
    cityName: 'Sydney',
    monthYear: 'May 2020',
    discount: '50',
    oldPrice: '5999',
    newPrice: '3999',
  ),
];

class CityCard extends StatelessWidget {
  final String imagePath, cityName, monthYear, discount, oldPrice, newPrice;

  const CityCard({
    this.imagePath,
    this.cityName,
    this.monthYear,
    this.discount,
    this.oldPrice,
    this.newPrice,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 210.0,
                  width: 160.0,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  width: 160.0,
                  height: 60.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black,
                          Colors.black12,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10.0,
                  right: 10.0,
                  bottom: 10.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(
                            cityName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            monthYear,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          shape: BoxShape.rectangle,
                        ),
                        child: Text(
                          '$discount%',
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                width: 5.0,
              ),
              Text(
                '\$$newPrice',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                '\$$oldPrice',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
