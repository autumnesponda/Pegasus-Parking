import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:connectivity/connectivity.dart';
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.amber,
      ),
      home: new MyHomePage(title: 'Pegasus Parking'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var random;
  List<Card> cards = List<Card>();
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() => _connectionStatus = result.toString());
    });
    refreshList();
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

  //region
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    WebScraper scraper = WebScraper();

    //check if we have internet

    initConnectivity().whenComplete(() async {
      if(_connectionStatus.endsWith("wifi")){
        //if we have internet
        List<Garage> garageData = await scraper.scrape();
        List<Card> cardData = List<Card>();
        cards.clear();
        garageData.forEach((g) {
          cardData.add(Card(

            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            g.garageName,
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      //SizedBox(height: 8.0,),
                      Row(
                        children: <Widget>[
                          Text("Spots Available: "),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            "${g.availableSpots}",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("Estimated Parking Time: "),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            "~${g.timeToPark} min",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        //this is to shift the progress indicator slightly to the
                        //left so that it looks pretty
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 0.0),
                        child: CircularPercentIndicator(
                          radius: 75.0,
                          lineWidth: 5.0,
                          percent: g.percentFull / 100.0,
                          center: new Text("${g.percentFull}%" + '\n' + " full"),
                          progressColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            elevation: 12.0,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          ));
        });
        setState(() {
          cards = cardData;
        });
      }
    });

    //if we don't have internet
    if (_connectionStatus != "ConnectivityResult.wifi") {
      //Todo: add an ErrorCard to cardData at position 0

    } else {

    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    print(_connectionStatus);

    ScrollController _scrollController = new ScrollController();
    Scaffold scaffold = Scaffold(
//      bottomNavigationBar: BottomNavigationBar(
//        items: <BottomNavigationBarItem>[
//          BottomNavigationBarItem(title: Text("List"), icon: Icon(Icons.list)),
//          BottomNavigationBarItem(title: Text("Map"), icon: Icon(Icons.map))
//        ],
//      ),
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
            return cards[index];
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
