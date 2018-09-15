import 'package:ucf_parking/Garage.dart';
import 'package:ucf_parking/IWebScrape.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'dart:async';

class WebScraper implements IWebScrape {
  final _url = 'http://secure.parking.ucf.edu/GarageCount/';

  @override
  Future<List<Garage>> scrape () async {
    // TODO: Parse through parsed data.
    http.Response response = await http.get(_url);

    Document document = parser.parse(response.body);


    document.getElementsByClassName('dxgv').forEach((Element element){
//      print(element.text);
      print(element.attributes.keys);
    });

    return List<Garage>();
  }
}