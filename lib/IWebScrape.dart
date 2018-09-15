import 'package:ucf_parking/Garage.dart';
import 'dart:async';

abstract class IWebScrape {
  static Future<List<Garage>> scrape(String source){}
}