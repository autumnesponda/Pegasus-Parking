import 'package:ucf_parking/Garage.dart';

abstract class MapViewConfigForGarage {
  static Future<Uri> getUriFor(Garage garage) async {

    switch(garage.garageName) {
      case "Garage A":
        break;
      case "Garage B":
        break;
      case "Garage C":
        break;
      case "Garage D":
        break;
      case "Garage H":
        break;
      case "Garage I":
        break;
      case "Garage Libra":
        break;
      default:
        break;

    }
  }
}