import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<TestScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        key: scaffoldKey,
        drawer: new DRW(),
        appBar: AppBar(
          title: Text("Drawer Bug!"),
        ),
        body: WillPopScope(
          onWillPop: () async {
            print("Drawer is open: ${scaffoldKey.currentState!.isDrawerOpen}");
            // Return a Future<bool> indicating whether to allow the back navigation
            return false; // Returning false will prevent the back navigation
          },
          child: Center(
            child: Text('Hello World!'),
          ),
        ),
      ),
    );
  }
}

class DRW extends StatefulWidget {
  const DRW({
    Key? key,
  }) : super(key: key);

  @override
  _DRWState createState() {
    return _DRWState();
  }
}

class _DRWState extends State<DRW> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      width: 100,
      child: Column(
        children: <Widget>[
          Icon(Icons.access_time),
        ],
      ),
    );
  }
}
