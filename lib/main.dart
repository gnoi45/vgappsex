
import 'package:e_relax_hybrid/test/AppSignIn.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'OtpPage.dart';
import 'home/home.dart';


void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MultiVendor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
String customer_id;
String get()
{
  return customer_id;
}
class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      int status = preferences.getInt("status");

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute<Null>(builder: (BuildContext context) {
        return new Home();
      }));

//      if(status==200)
//      {
//        customer_id=preferences.getString("id");
// Navigator.of(context)
//          .pushReplacement(MaterialPageRoute<Null>(builder: (BuildContext context) {
//        return new Home();
//      }));
//      }
//      else
//      {
//        Navigator.of(context)
//            .pushReplacement(MaterialPageRoute<Null>(builder: (BuildContext context) {
//          return new AppSignIn();
//        }));
//      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
    );
  }
}
