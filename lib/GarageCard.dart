import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ucf_parking/Garage.dart';

class GarageCard {
  Garage garage;

  GarageCard(this.garage);

  static Card getCard(Garage g, VoidCallback iconButtonOnTap) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              g.garageName,
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        //SizedBox(height: 8.0,),
                        Row(
                          children: <Widget>[
                            Text("Spots Available: "),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "${g.availableSpots}",
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("Estimated Time to Park: "),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              "~${g.timeToPark} min",
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Column(
                      children: <Widget>[
                        Padding(
                          // This is to shift the progress indicator slightly to the
                          // left so that it looks pretty.
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 0.0),
                          child: CircularPercentIndicator(
                            radius: 75.0,
                            lineWidth: 5.0,
                            percent: g.percentFull / 100.0,
                            center: new Text("${g.percentFull}%" + '\n' + " full"),
                            progressColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              ],

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down),
                  onPressed: iconButtonOnTap,
                ),
              ],
            ),
          ],
        ),

      ),
      elevation: 12.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    );
  }
}
