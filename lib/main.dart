import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
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

  static double value = 0.66;


  @override
  Widget build(BuildContext context) {
    List<Card> cards = <Card>[
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Center(child: Text("Garage A", style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),)),
              SizedBox(height: 12.0,),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Estimated Parking Time:", style: TextStyle(fontSize: 16.0),),
                  SizedBox(width: 8.0,),
                  Text("4 min", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                  SizedBox(width: 12.0,),
                  CircularPercentIndicator(
                    radius: 75.0,
                    lineWidth: 5.0,
                    percent: .66,
                    center: new Text("66%" + '\n' + " full"),
                    progressColor: Colors.orange,
                  ),
//                  SizedBox(width: 12.0,),
                  SizedBox(width: 4.0,),
                ],
              ),
              SizedBox(height: 8.0,),
              SizedBox(height: 12.0,),
            ],
          ),
        ),
        elevation: 12.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Garage B", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),),
                    //SizedBox(height: 8.0,),
                    Row(
                      children: <Widget>[
                        Text("Spots Available: "),
                        SizedBox(width: 8.0,),
                        Text("378", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Estimated Parking Time: "),
                        SizedBox(width: 8.0,),
                        Text("4 min", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 16.0,),
                Column(
                  children: <Widget>[
                    Padding(
                      //this is to shift the progress indicator slightly to the
                      //left so that it looks pretty
                      padding: const EdgeInsets.fromLTRB(0.0,0.0,4.0,0.0),
                      child: CircularPercentIndicator(
                        radius: 75.0,
                        lineWidth: 5.0,
                        percent: .66,
                        center: new Text("66%" + '\n' + " full"),
                        progressColor: Colors.orange,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        elevation: 12.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      Card(child: Text("Garage C")),
      Card(child: Text("Garage D")),
      Card(child: Text("Garage E")),
      Card(child: Text("Garage F")),
      Card(child: Text("Garage G")),
      Card(child: Text("Garage H")),
      Card(child: Text("Garage I")),
    ];
    return new Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(title: Text("List"), icon: Icon(Icons.list)),
          BottomNavigationBarItem(title: Text("Map"), icon: Icon(Icons.map))
        ],
      ),
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(child: new Text(widget.title)),
      ),
      body: ListView.builder(
        itemCount: 9,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: cards[index],
          );
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
