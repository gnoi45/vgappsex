import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'AppUrl.dart';
import 'home/home.dart';
import 'main.dart';

class UpdateProfile extends StatefulWidget {
  @override
  AppSingU1 createState() => AppSingU1();
}


class AppSingU1 extends State<UpdateProfile> {

  TextEditingController myController;
  TextEditingController myController1;
  TextEditingController myController2;
  String name;
  String email;
  String phoneNumber;

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
    super.dispose();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name=preferences.getString("name");
      email=preferences.getString("email");
      phoneNumber=preferences.getString("value");
      myController = TextEditingController(text: name);
      myController1 = TextEditingController(text: email);
      myController2 = TextEditingController(text: phoneNumber);


    });
  }


  update(String _name,String _email,String _phoneNumber) async {
    final response = await http
        .post(AppUrl.UPDATE_PROFILE, body: {
      "user_id": ""+customer_id,
      "name": ""+_name,
      "email":""+_email,
      "mobile":""+_phoneNumber
    });


    final data = jsonDecode(response.body);
    int value = data['status'];

    if (value == 200) {


      setState(() {
        savePref(_phoneNumber, _email, _name, customer_id,value);
      });
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

  savePref(String value, String email, String name, String id,int status) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("value", value);
      preferences.setString("name", name);
      preferences.setString("email", email);
      preferences.setString("id", id);
      preferences.setInt("status",status);
      preferences.commit();
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
        padding: EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 30),
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
            Container(
                width: double.infinity,
                alignment: Alignment.center,
                child:  Text(
                  "Update Profile",
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: defaultFontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                )
            ),
            SizedBox(
              height: 100,
            ),
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
                  Icons.title,
                  color: Color(0xFF666666),
                  size: defaultIconSize,
                ),
                fillColor: Color(0xFFF2F3F5),
                hintStyle: TextStyle(
                    color: Color(0xFF666666),
                    fontFamily: defaultFontFamily,
                    fontSize: defaultFontSize),
                hintText: "User Name",
              ),
            ),
            SizedBox(
              height: 15,
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
                  Icons.email,
                  color: Color(0xFF666666),
                  size: defaultIconSize,
                ),
                fillColor: Color(0xFFF2F3F5),
                hintStyle: TextStyle(
                    color: Color(0xFF666666),
                    fontFamily: defaultFontFamily,
                    fontSize: defaultFontSize),
                hintText: "Email Id",
              ),
            ),
            SizedBox(
              height: 15,
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
                  Icons.phone,
                  color: Color(0xFF666666),
                  size: defaultIconSize,
                ),
                fillColor: Color(0xFFF2F3F5),
                hintStyle: TextStyle(
                    color: Color(0xFF666666),
                    fontFamily: defaultFontFamily,
                    fontSize: defaultFontSize),
                hintText: "Phone Number",
              ),
            ),
            SizedBox(
              height: 15,
            ),

            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              child: RaisedButton(
                padding: EdgeInsets.all(17.0),
                onPressed: () {

                  if(myController.text.isEmpty)
                  {
                    loginToast("Please Enter Name");
                    return;
                  }

                  if(myController1.text.isEmpty)
                  {
                    loginToast("Please Enter Email Id");
                    return;
                  }

                  if (!RegExp(
                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                      .hasMatch(myController1.text)) {
                    loginToast("Please Enter Valid Email Id");
                    return;
                  }

                  if(myController2.text.isEmpty)
                  {
                    loginToast("Please Enter Mobile Number");
                    return;
                  }



                  update(myController.text,myController1.text,myController2.text);
                },
                child: Text(
                  "Update",
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
                  shape: BoxShape.circle, color: Color(0xFFF2F3F7)),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
