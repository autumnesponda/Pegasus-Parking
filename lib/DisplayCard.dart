import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ucf_parking/Garage.dart';

enum CardType {ErrorCard, GarageCard, MapCard}

//enum SortType {}

class DisplayCard{
  static StaticMapProvider _staticMapProvider = StaticMapProvider("AIzaSyCOZxrc1ORQiZoy_yqesyKe8ma9vHBapxM");
  Garage garage;
  String errorTitle;
  String errorSubtitle;
  VoidCallback buttonOnPress;
  CardType _cardType;

  set cardType(CardType value) {
    _cardType = value;
  }

  CardType get cardType => _cardType;

  DisplayCard.Error(this.errorTitle, this.errorSubtitle) {
    this.cardType = CardType.ErrorCard;
  }

  DisplayCard.Garage(this.garage, this.buttonOnPress) {
    this.errorTitle = null;
    this.errorSubtitle = null;
    this.cardType = CardType.GarageCard;
  }

  DisplayCard.Map(this.garage, this.buttonOnPress) {
    this.errorTitle = null;
    this.errorSubtitle = null;
    this.cardType = CardType.MapCard;
  }

  Color getProgressColor(){
    if(garage.percentFull < 50)
      return Colors.green;
    if(garage.percentFull < 75)
      return Colors.amber;
    else{
      return Colors.red;
    }
  }

  Card getCard() {
    switch (this.cardType) {
      case CardType.GarageCard:
        return makeGarageCard();
      case CardType.ErrorCard:
        return makeErrorCard();
      case CardType.MapCard:
        return makeMapCard();
    }
    return null;
  }

  void toggleCardType() {
    switch (this.cardType) {
      case CardType.GarageCard:
        cardType = CardType.MapCard;
        break;
      case CardType.MapCard:
        cardType = CardType.GarageCard;
        break;
      default:
        break;
    }
    buttonOnPress();
  }

  Card makeMapCard() {
    return Card(
      color: Colors.grey[50],
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
                              garage.garageName,
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
                              "${garage.availableSpots}",
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
                              "~${garage.timeToPark} min",
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
                            percent: garage.percentFull / 100.0,
                            center: new Text("${garage.percentFull}%" + '\n' + " full"),
                            progressColor: getProgressColor(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Divider(
                  height: 10.0,
                  color: Colors.grey[700],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
              child: DecoratedBox(
                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                child: SizedBox(
                  height: 175.0,
                  child: Center(
                    child: Text("Here goes a static map for ${garage.garageName}"),
                  ),
                  // TODO: STATIC MAP GOES HERE!
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.keyboard_arrow_up),
              onPressed: toggleCardType,
            ),
          ],
        ),

      ),
      elevation: 12.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    );
  }

  Card makeErrorCard() {
    return Card(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          ListTile(
            title: Center(child: Text(
              this.errorTitle,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            )),
            subtitle: Center(child: Text(
              this.errorSubtitle,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )),
          ),
        ]),
      ),
      elevation: 12.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
    );
  }

  Card makeGarageCard() {
    return Card(
      color: Colors.grey[50],
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
                              garage.garageName,
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
                              "${garage.availableSpots}",
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
                              "~${garage.timeToPark} min",
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold, color: getProgressColor()),
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
                            percent: garage.percentFull / 100.0,
                            center: new Text("${garage.percentFull}%" + '\n' + " full"),
                            progressColor: getProgressColor(),
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
                  onPressed: toggleCardType,
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