import 'dart:async';

import 'package:ucf_parking/Garage.dart';

abstract class IWebScrape {
  Future<List<Garage>> scrape();
}