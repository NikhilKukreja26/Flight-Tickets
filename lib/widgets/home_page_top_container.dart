import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'custom_shape_clipper.dart';
import '../constants.dart';
import '../pages/flight_list.dart';

const TextStyle dropDownLabelStyle = TextStyle(
  color: Colors.white,
  fontSize: 16.0,
);

const TextStyle dropDownMenuItemStyle = TextStyle(
  color: Colors.black,
  fontSize: 16.0,
);

List<String> locations = ['Boston (BOS)', 'New York City (JFK)'];

class Location {
  final String name;

  Location.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        name = map['name'];

  Location.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);
}

class HomePageTopContainer extends StatefulWidget {
  @override
  _HomePageTopContainerState createState() => _HomePageTopContainerState();
}

class _HomePageTopContainerState extends State<HomePageTopContainer> {
  var selectedLocationIndex = 0;
  var isFlightSelected = true;

  final TextEditingController _searchFieldController =
      TextEditingController(text: locations[1]);

  addLocations(BuildContext context, List<DocumentSnapshot> snapshots) {
    for (int i = 0; i < snapshots.length; i++) {
      final Location location = Location.fromSnapshot(snapshots[i]);
      locations.add(location.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            height: 400.0,
            decoration: containerBoxDecoration,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50.0),
                StreamBuilder<Object>(
                    stream:
                        Firestore.instance.collection('locations').snapshots(),
                    builder: (context, snapshot) {
                      // if (snapshot.hasData)
                      //   addLocations(context, snapshot.data.documents);
                      return !snapshot.hasData
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 16.0),
                                  PopupMenuButton(
                                    onSelected: (index) {
                                      setState(() {
                                        selectedLocationIndex = index;
                                      });
                                    },
                                    itemBuilder: (context) =>
                                        <PopupMenuItem<int>>[
                                      PopupMenuItem(
                                        child: Text(
                                          locations[0],
                                          style: dropDownMenuItemStyle,
                                        ),
                                        value: 0,
                                      ),
                                      PopupMenuItem(
                                        child: Text(
                                          locations[1],
                                          style: dropDownMenuItemStyle,
                                        ),
                                        value: 1,
                                      ),
                                    ],
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          locations[selectedLocationIndex],
                                          style: dropDownLabelStyle,
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            );
                    }),
                const SizedBox(height: 50.0),
                Text(
                  'Where would\nyou want to go',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    child: TextField(
                      controller: _searchFieldController,
                      style: dropDownMenuItemStyle,
                      cursorColor: appTheme.primaryColor,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 14.0),
                        suffixIcon: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(30.0),
                          child: InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => InheritedFlightListing(
                                    fromLocation:
                                        locations[selectedLocationIndex],
                                    toLocation: _searchFieldController.text,
                                    child: FlightListingScreen(),
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          isFlightSelected = true;
                        });
                      },
                      child: ChoiceChip(
                        iconData: Icons.flight_takeoff,
                        text: 'Flights',
                        isSelected: isFlightSelected,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isFlightSelected = false;
                        });
                      },
                      child: ChoiceChip(
                        iconData: Icons.hotel,
                        text: 'Hotels',
                        isSelected: !isFlightSelected,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ChoiceChip extends StatefulWidget {
  final IconData iconData;
  final String text;
  final bool isSelected;

  const ChoiceChip({
    Key key,
    this.iconData,
    this.text,
    this.isSelected,
  }) : super(key: key);

  @override
  _ChoiceChipState createState() => _ChoiceChipState();
}

class _ChoiceChipState extends State<ChoiceChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: widget.isSelected
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20.0),
            )
          : null,
      child: Row(
        children: <Widget>[
          Icon(
            widget.iconData,
            color: Colors.white,
            size: 20.0,
          ),
          const SizedBox(width: 8.0),
          Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
