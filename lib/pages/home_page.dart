import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
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
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('cities')
                .orderBy('newPrice')
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : _buildCitiesList(context, snapshot.data.documents);
            }),
      ),
    ],
  );
}

Widget _buildCitiesList(
    BuildContext context, List<DocumentSnapshot> snapshots) {
  return ListView.builder(
      itemCount: snapshots.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return CityCard(city: City.fromSnapshot(snapshots[index]));
      });
}

class City {
  final String imagePath, cityName, monthYear, discount;
  final int oldPrice, newPrice;

  City.fromMap(Map<String, dynamic> map)
      : assert(map['cityName'] != null),
        assert(map['monthYear'] != null),
        assert(map['discount'] != null),
        assert(map['imagePath'] != null),
        imagePath = map['imagePath'],
        cityName = map['cityName'],
        monthYear = map['monthYear'],
        discount = map['discount'],
        oldPrice = map['oldPrice'],
        newPrice = map['newPrice'];

  City.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data);
}

final formatCurrency = NumberFormat.simpleCurrency();

class CityCard extends StatelessWidget {
  final City city;

  CityCard({this.city});

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
                  child: CachedNetworkImage(
                    imageUrl: city.imagePath,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      heightFactor: 18.0,
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      color: Colors.black,
                    ),
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
                            '${city.cityName}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${city.monthYear}',
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
                          '${city.discount}%',
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
                '${formatCurrency.format(city.newPrice)}',
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
                "(${formatCurrency.format(city.oldPrice)})",
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
