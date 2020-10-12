import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class EditProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditProfiles();
  }
}

class EditProfiles extends State<EditProfile> {
  String _name;
  String _email;
  String _password;
  String _phoneNumber;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _name=preferences.getString("name");
      _email=preferences.getString("email");
      _phoneNumber=preferences.getString("value");
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  Widget _buildName(String sx) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 10,
      initialValue: ""+sx,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildEmail(String em) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      initialValue: ""+em,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }


  Widget _buildPhoneNumber(String mm) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Phone number'),
      keyboardType: TextInputType.phone,
      initialValue: ""+mm,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Phone number is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _phoneNumber = value;
      },
    );
  }


  update() async {
    final response = await http
        .post("http://shopninja.in/e-relax/api2/public/index.php/updateUserProfile", body: {
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
        return new MyHomePage();
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(_name),
              _buildEmail(_email),
              _buildPhoneNumber(_phoneNumber),
              SizedBox(height: 100),
              RaisedButton(
                color: Colors.blue,
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {

                  if (!_formKey.currentState.validate()) {
                    return;
                  }

                  _formKey.currentState.save();

                  update();
//
//                  print(_name);
//                  print(_email);
//                  print(_phoneNumber);
//                  print(_password);

//                  Navigator.of(context)
//                      .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
//                    return new SecondRoute();
//                  }));
                  //Send to API
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}