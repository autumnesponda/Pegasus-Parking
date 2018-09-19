import 'dart:math';
import 'package:ucf_parking/Garage.dart';
import 'package:ucf_parking/IWebScrape.dart';
import 'package:ucf_parking/school.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'dart:async';

class WebScraper implements IWebScrape {
  var _url;
  var school;

  WebScraper.ucf(){
    this._url = 'http://secure.parking.ucf.edu/GarageCount/';
    this.school = School.UCF;
  }

  WebScraper(School school){
    switch (school){
      case School.UCF:
        this._url = 'http://secure.parking.ucf.edu/GarageCount/';
        this.school = School.UCF;
        break;

      case School.FIU:
        break;

      case School.OSU:
        break;

      default:
        this._url = 'http://secure.parking.ucf.edu/GarageCount/';
        this.school = School.UCF;
    }

  }

  @override
  Future<List<Garage>> scrape() async {
    http.Response response = await http.get(_url);

    Document document = parser.parse(response.body);

    List<Garage> garages = List();
    Garage currentGarage = Garage.initToEmpty();

    // The relevant garage data is stored in 'dxgv' classes, so we only look at
    // elements in those classes.
    document.getElementsByClassName('dxgv').forEach((Element element) {

      // If the first node in this element contains the string "Garage", it
      // it contains the name of this garage. So we add it to currentGarage,
      // the placeholder garage (which we will insert into the list later).
      if (element.nodes[0].toString().contains("Garage")) {
        if (currentGarage.garageName != null) {
          garages.add(currentGarage);
          currentGarage = Garage.initToEmpty();
          var garageName = element.nodes[0].toString();
          currentGarage.garageName = garageName.substring(1, garageName.length - 1);
        }
        
        else {
          var garageName = element.nodes[0].toString();
          currentGarage.garageName = garageName.substring(1, garageName.length - 1);
        }
      }

      // The current element contains the currently available parking spaces and capacity.
      else if (element.nodes.length == 3) {

        // Get the number of currently available spots. We'll use the substring method to
        // remove non-numeric parts of the string like quotes and backslashes.
        String availableSpotsRawString = element.nodes[1].nodes[0].toString();
        availableSpotsRawString = availableSpotsRawString.substring(1, availableSpotsRawString.length - 1);
        int availableSpots = int.parse(availableSpotsRawString);
        currentGarage.availableSpots = availableSpots;

        // Get the total capacity of the garage. Get the numeric part of the string
        // using the substring method like above.
        String capacityRawString = element.nodes[2].toString().substring(2, 6);
        int capacity = int.parse(capacityRawString);
        currentGarage.capacity = capacity;

        // Get the fullness percentage of the garage and cast it to an int.
        int percent = (availableSpots / capacity * 100).round();
        currentGarage.percentFull = 100 - ((percent <= 100) ? percent : 100);

        // magical formula to very accurately grab an estimate for time to park
        int x = currentGarage.percentFull;
        currentGarage.timeToPark = (2 + 0.2777273*x - 0.009374242*pow(x, 2) + 0.0001288182*pow(x, 3) - 2.484848e-7*pow(x, 4)).round();
      }

      // Only add the current garage to the list if it is initialized with the proper values.
      if (currentGarage.isComplete()) {
        garages.add(currentGarage);
        currentGarage = Garage.initToEmpty();
      }
    });

    return garages;
  }
}
