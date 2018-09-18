import 'package:flutter/material.dart';
import 'package:ucf_parking/DisplayCard.dart';
import 'package:ucf_parking/Garage.dart';
import 'package:ucf_parking/WebScraper.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:map_view/map_view.dart';
import 'package:ucf_parking/school.dart';

void main() {
  MapView.setApiKey("AIzaSyCOZxrc1ORQiZoy_yqesyKe8ma9vHBapxM");

  runApp(MyApp());
}
const DEBUG = true;

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
      home: new SplashScreen(),
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

  //defaults to the ucf tab
  var _currentTabIndex = 0;

  List<DisplayCard> cards = List<DisplayCard>();
  School school;

  // callback that we pass into each DisplayCard to refresh
  // the state after we modify it in place
  // it's fucking witchcraft, "how to call build without calling build"
  void callback() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    school = School.UCF;
    refreshList();
  }

  Future<Null> refreshList() async {
    WebScraper scraper = WebScraper(school);
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
        actions: <Widget>[IconButton(icon: Icon(Icons.filter_list), onPressed: null)],
        backgroundColor: Colors.amber,
      ),
      body: RefreshIndicator(
        key: refreshKey,
        child: ListView.builder(
          itemBuilder: (context, index) {
            if (cards.isEmpty)
              return Card(
                child: Text("PLz. Referesh."),
              );
            return Padding(
              padding: const EdgeInsets.all(7.0),
              child: cards[index].getCard(),
            );
          },
          itemCount: cards.length,
          physics: BouncingScrollPhysics(),
        ),
        onRefresh: refreshList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.amber[700],
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text("UCF"),
            icon: Icon(Icons.directions_car),
          ),
          BottomNavigationBarItem(
            title: Text("FIU"),
            icon: Icon(Icons.directions_car),
          ),
          BottomNavigationBarItem(
            title: Text("OSU"),
            icon: Icon(Icons.directions_car),
          ),
        ],
        onTap: (int index){
          //decently sized switch & case for handling buttons
          switch (index){
            //UCF
            case 0:
              setState(() {
                this.school = School.UCF;
                this._currentTabIndex = index;
                if(DEBUG) print("current nav-bar index = $_currentTabIndex");
              });
              break;

            //Florida International
            case 1:
              this.school = School.FIU;
              this._currentTabIndex = index;
              if(DEBUG) print("current nav-bar index = $_currentTabIndex");
              break;

            //Ohio State
            case 2:
              setState(() {
                this.school = School.OSU;
                this._currentTabIndex = index;
                if(DEBUG) print("current nav-bar index = $_currentTabIndex");
              });
              break;

            //default to UCF - #NationalChamps
            default:
              setState(() {
                this.school = School.UCF;
                this._currentTabIndex = index;
                if(DEBUG) print("current nav-bar index = $_currentTabIndex");
              });
              break;
          }
        },

      ),
    );
    return scaffold;
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage(title: "Pegasus Parking")));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Image.asset(
        'images/SplashScreen.jpg',
        alignment: Alignment.center,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}