import 'dart:convert';

import 'package:e_relax_hybrid/home/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppUrl.dart';

//String xx_id="";
class Address extends StatefulWidget {
  @override
  Addressx createState() => Addressx();
}


class Addressx extends State<Address> {
  TextEditingController myController;
  TextEditingController myController1;
  TextEditingController myController2;
  TextEditingController myController3;
  TextEditingController myController4;
  TextEditingController myController5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    myController1.dispose();
    myController2.dispose();
    myController3.dispose();
    myController4.dispose();
    myController5.dispose();
    super.dispose();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      //xx_id = preferences.getString("id");
      myController = TextEditingController(text: "");
      myController1 = TextEditingController(text: "");
      myController2 = TextEditingController(text: "");
      myController3 = TextEditingController(text: "");
      myController4 = TextEditingController(text: "");
      myController5 = TextEditingController(text: "");
      loginToast(xx_id);
    });
  }
  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }


  @override
  Widget build(BuildContext context) {
    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;




    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
        width: double.infinity,
        height: double.infinity,
        color: Colors.white70,
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: InkWell(
                child: Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Icon(Icons.close),

                  ),

                ),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
            ),
            Flexible(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  TextField(
                    showCursor: true,
                    controller: myController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.add_location,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Plot No",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    showCursor: true,
                    controller: myController1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.add_location,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Street",
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    showCursor: true,
                    controller: myController2,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.add_location,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "Area",
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    showCursor: true,
                    controller: myController3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.add_location,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "City",
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    showCursor: true,
                    controller: myController4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.add_location,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "State",
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    showCursor: true,
                    controller: myController5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.add_location,
                        color: Color(0xFF666666),
                        size: defaultIconSize,
                      ),
                      fillColor: Color(0xFFF2F3F5),
                      hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontFamily: defaultFontFamily,
                          fontSize: defaultFontSize),
                      hintText: "PinCode",
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      padding: EdgeInsets.all(17.0),
                      onPressed: () {
                        if(myController.text.isEmpty)
                        {
                          loginToast("Please Enter Plot");
                          return;
                        }

                        if(myController1.text.isEmpty)
                        {
                          loginToast("Please Enter Street");
                          return;
                        }

                        if(myController2.text.isEmpty)
                        {
                          loginToast("Please Enter Area");
                          return;
                        }

                        if(myController3.text.isEmpty)
                        {
                          loginToast("Please Enter City");
                          return;
                        }

                        if(myController4.text.isEmpty)
                        {
                          loginToast("Please Enter State");
                          return;
                        }

                        if(myController5.text.isEmpty)
                        {
                          loginToast("Please Enter PinCode");
                          return;
                        }

                        update(myController.text, myController1.text, myController2.text, myController3.text, myController4.text, myController5.text);
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Poppins-Medium.ttf',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.blue)),
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  update(String plot,String street,String area,String city,String state,String pincode) async {
    final response = await http
        .post(AppUrl.SAVE_ADDRESS, body: {
      "cust_id": ""+xx_id,
      "plot_no": ""+plot,
      "street":""+street,
      "area":""+area,
      "city":""+city,
      "state":""+state,
      "pincode":""+pincode
    });


    final data = jsonDecode(response.body);
    int value = data['status'];

    if (value == 200) {

      //
      // setState(() {
      //   savePref(_phoneNumber, _email, _name, customer_id,value);
      // });
      print("Logged IN");
      loginToast("Successfully updated");
      Navigator.of(context)
          .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
        return new Home();
      }));
    } else {
      print("fail");
      loginToast("Some Error Occurred");
    }
  }
}

