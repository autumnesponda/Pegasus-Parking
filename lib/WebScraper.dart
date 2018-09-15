import 'package:ucf_parking/Garage.dart';
import 'package:ucf_parking/IWebScrape.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'dart:async';

class WebScraper implements IWebScrape {
  final _url = 'http://secure.parking.ucf.edu/GarageCount/';

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
          currentGarage.garageName = element.nodes[0].toString();
        }
        
        else {
          currentGarage.garageName = element.nodes[0].toString();
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
        currentGarage.percentFull = 100 - (availableSpots / capacity * 100).round();
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
