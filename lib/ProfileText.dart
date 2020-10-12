import 'package:e_relax_hybrid/AllAddress.dart';
import 'package:e_relax_hybrid/ChangePassword.dart';
import 'package:e_relax_hybrid/UpdateProfile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Address.dart';
import 'EditProfile.dart';
import 'InfoCard.dart';

const url = 'Change Password';
const email = 'Address';
const phone = 'Edit Profile';
const location = 'Logout';


class ProfileText extends StatefulWidget {
  @override
  Pro createState() => Pro();
}

class Pro extends State<ProfileText> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }


  void _showDialog(BuildContext context, {String title, String msg}) {
    final Dialog = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: <Widget>[
        RaisedButton(
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Close',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
      ],
    );
    showDialog(context: context, builder: (x) =>  Dialog);
  }

  String x="";
  getPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      String name = preferences.getString("name");
      x=name;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('images/fahim.jpg'),
            ),
            Text(
              ''+x,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pacifico',
              ),
            ),
            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.white,
              ),
            ),
            InfoCard(
              text: phone,
              icon: Icons.account_circle,
              onPressed: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                  return new UpdateProfile();
                }));
              },
            ),
            InfoCard(
              text: email,
              icon: Icons.add_location,
              onPressed: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                  return new AllAddress();
                }));
              },
            ),
            InfoCard(
              text: url,
              icon: Icons.lock,
              onPressed: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                  return new ChangePassword();
                }));
              },
            ),
//            InfoCard(
//              text: location,
//              icon: Icons.call_missed_outgoing,
//              onPressed: () {
//
//              },
//            ),
          ],
        ),
      ),
    );
  }
}