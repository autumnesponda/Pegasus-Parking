import 'package:ucf_parking/Garage.dart';

abstract class IWebScrape {
  List<Garage> scrape(String source);
}