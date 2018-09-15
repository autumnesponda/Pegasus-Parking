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
    // TODO: Parse through parsed data.
    http.Response response = await http.get(_url);

    Document document = parser.parse(response.body);

    List<Garage> garages = List();
    Garage currentGarage = Garage.initToEmpty();

    document.getElementsByClassName('dxgv').forEach((Element element) {
      // garage name
      if (element.nodes[0].toString().contains("Garage")) {
        if (currentGarage.garageName != null) {
          garages.add(currentGarage);
          currentGarage = Garage.initToEmpty();
          currentGarage.garageName = element.nodes[0].toString();
        } else {
          currentGarage.garageName = element.nodes[0].toString();
        }
      }

      // current element contains the currently available parking spaces and capacity
      else if (element.nodes.length == 3) {
        // first we'll grab the currently available spots
        String availableSpotsRawString = element.nodes[1].nodes[0].toString().substring(1, element.nodes[1].nodes[0].toString().length - 1);
        int availableSpots = int.parse(availableSpotsRawString);
        currentGarage.availableSpots = availableSpots;

        String capacityRawString = element.nodes[2].toString().substring(2, 6);
        int capacity = int.parse(capacityRawString);
        currentGarage.capacity = capacity;

        currentGarage.percentFull = 100 - (availableSpots / capacity * 100).round();
      }

      if (currentGarage.isComplete()) {
        garages.add(currentGarage);
        currentGarage = Garage.initToEmpty();
      }
    });

    garages.forEach((g) => print("${g.toString()}"));

    return garages;
  }
}
