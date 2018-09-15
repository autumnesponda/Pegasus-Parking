import 'package:ucf_parking/Garage.dart';
import 'dart:async';

abstract class IWebScrape {
  Future<List<Garage>> scrape(String source);
}