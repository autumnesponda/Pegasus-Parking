import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ucf_parking/DisplayCard.dart';
import 'package:ucf_parking/Garage.dart';
import 'package:ucf_parking/WebScraper.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:map_view/map_view.dart';


void main() {
  MapView.setApiKey("AIzaSyCOZxrc1ORQiZoy_yqesyKe8ma9vHBapxM");
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pegasus Parking',
      theme: new ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: new MyHomePage(title: 'Pegasus Parking'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  List<DisplayCard> cards = List<DisplayCard>();

  // callback that we pass into each DisplayCard to refresh
  // the state after we modify it in place
  // it's fucking witchcraft, "how to call build without calling build"
  void callback() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  Future<Null> refreshList() async {
    WebScraper scraper = WebScraper();

    List<Garage> garageData = await scraper.scrape();
    List<DisplayCard> cardData = List<DisplayCard>();
    cards.clear();
    garageData.forEach((g) {
      cardData.add(DisplayCard.Garage(g, callback));
    });

    setState(() {
      cards = cardData;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
      Scaffold scaffold = Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(child: new Text('Pegasus Parking')),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (cards.isEmpty)
              return Card(
                child: Text("PLz. Referesh."),
              );
            return cards[index].getCard();
          },
          itemCount: cards.length,
          physics: BouncingScrollPhysics(),
        ),
        onRefresh: refreshList,
      ),
    );
    return scaffold;
  }
}
