import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../widgets/custom_shape_clipper.dart';
import '../widgets/home_page_top_container.dart';

final Color discountBackgroundColor = Color(0xFFFFE08D);
final Color flightBorderColor = Color(0xFFE6E6E6);
final Color chipBackgroundColor = Color(0xFFE6E6E6);

final formatCurrency = NumberFormat.simpleCurrency();

class InheritedFlightListing extends InheritedWidget {
  final String toLocation, fromLocation;

  InheritedFlightListing({this.toLocation, this.fromLocation, Widget child})
      : super(child: child);

  static InheritedFlightListing of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(InheritedFlightListing);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}

class FlightListingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            FlightListTopPart(),
            FlightListBottomPart(),
          ],
        ),
      ),
    );
  }
}

class FlightListTopPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 160.0,
            decoration: containerBoxDecoration,
          ),
        ),
        _buildSearchCard(context),
      ],
    );
  }

  Widget _buildSearchCard(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20.0),
        Card(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${InheritedFlightListing.of(context).fromLocation}',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 20.0,
                      ),
                      Text(
                        '${InheritedFlightListing.of(context).toLocation}',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Expanded(
                  child: Icon(
                    Icons.import_export,
                    color: Colors.black,
                    size: 32.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FlightListBottomPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Best Deals for Next 6 Months',
              style: dropDownMenuItemStyle,
            ),
          ),
          const SizedBox(height: 10.0),
          StreamBuilder(
            stream: Firestore.instance.collection('deals').snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _buildDealsList(
                      context,
                      snapshot.data.documents,
                    );
            },
          ),
          // FlightCard(),
          // FlightCard(),
          // FlightCard(),
          // FlightCard(),
        ],
      ),
    );
  }
}

Widget _buildDealsList(BuildContext context, List<DocumentSnapshot> snapshots) {
  return ListView.builder(
    itemCount: snapshots.length,
    shrinkWrap: true,
    physics: ClampingScrollPhysics(),
    itemBuilder: (context, index) {
      return FlightCard(
        flightDetails: FlightDetails.fromSnapshot(snapshots[index]),
      );
    },
  );
}

class FlightDetails {
  final String airlines, date, discount, rating;
  final int oldPrice, newPrice;

  FlightDetails.fromMap(Map<String, dynamic> map)
      : assert(map['airlines'] != null),
        assert(map['date'] != null),
        assert(map['discount'] != null),
        assert(map['rating'] != null),
        airlines = map['airlines'],
        date = map['date'],
        discount = map['discount'],
        oldPrice = map['oldPrice'],
        newPrice = map['newPrice'],
        rating = map['rating'];

  FlightDetails.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);
}

class FlightCard extends StatelessWidget {
  final FlightDetails flightDetails;

  FlightCard({
    this.flightDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: flightBorderColor,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '${formatCurrency.format(flightDetails.newPrice)}',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '(${formatCurrency.format(flightDetails.oldPrice)})',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8.0,
                    // runSpacing: -8.0,
                    children: <Widget>[
                      FlightDetailChip(
                        iconData: Icons.calendar_today,
                        label: '${flightDetails.date}',
                      ),
                      FlightDetailChip(
                        iconData: Icons.flight_takeoff,
                        label: '${flightDetails.airlines}',
                      ),
                      FlightDetailChip(
                        iconData: Icons.star,
                        label: '${flightDetails.rating}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10.0,
            right: 0.0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: discountBackgroundColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                '${flightDetails.rating}',
                style: TextStyle(
                  color: appTheme.primaryColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FlightDetailChip extends StatelessWidget {
  final IconData iconData;
  final String label;

  FlightDetailChip({this.iconData, this.label});

  @override
  Widget build(BuildContext context) {
    return RawChip(
      label: Text(label),
      labelStyle: TextStyle(
        color: Colors.black,
        fontSize: 14.0,
      ),
      backgroundColor: chipBackgroundColor,
      avatar: Icon(
        iconData,
        size: 14.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
