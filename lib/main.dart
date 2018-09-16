import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:ucf_parking/DisplayCard.dart';
import 'package:ucf_parking/Garage.dart';
import 'package:ucf_parking/WebScraper.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
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
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  DisplayCard error_card = DisplayCard.Error("Something's a little wonky!", "Check your internet connection and try again");

  // callback that we pass into each DisplayCard to refresh
  // the state after we modify it in place
  // it's fucking witchcraft, "how to call build without calling build"
  void callback() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus = result.toString();
//        if(_connectionStatus != ConnectivityResult.none){
          refreshList();
//        }

      });
    });
    //refreshList();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<Null> initConnectivity() async {
    String connectionStatus;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = connectionStatus;
    });
  }

  Future<Null> refreshList() async {
    //refreshKey.currentState?.show(atTop: false);
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
    print(_connectionStatus);

    //if no internet, insert error card at top
    if(_connectionStatus == "Connectivity.none"){
      setState(() {
        cards.insert(0, error_card);
      });
    }

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
