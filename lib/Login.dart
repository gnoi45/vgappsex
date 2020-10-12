import 'dart:convert';

import 'package:e_relax_hybrid/main.dart';
import 'package:e_relax_hybrid/register.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }


}

class LoginState extends State<Login> {
  String _email;
  String _password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
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

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      keyboardType: TextInputType.visiblePassword,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  login() async {
    final response = await http
        .post("http://shopninja.in/e-relax/api2/public/index.php/login", body: {
      "username": _email,
      "userpass": _password
    });

    final data = jsonDecode(response.body);
    int value = data['status'];

    if (value == 200) {

      String mobile = data['msg']['mobile'];
      String emailAPI = data['msg']['email'];
      String nameAPI = data['msg']['fullname'];
      String id = data['msg']['id'];
      setState(() {
        customer_id=id;
        savePref(mobile, emailAPI, nameAPI, id,value);
      });
      print("Logged IN");
      loginToast("Login Successfull");
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute<Null>(builder: (BuildContext context) {
        return new MyHomePage();
      }));
    } else {
      print("fail");
      loginToast("Some Error Occurred");
    }
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
      appBar: AppBar(
          title: Text("Login")
      ),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildEmail(),
              _buildPassword(),
              SizedBox(width : double.infinity,
              child:  RaisedButton(
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
                login();
                },
              )),
              FlatButton(
                  child: Text('Register',style:TextStyle(color:Colors.blue,fontSize:16)),onPressed:(){
                Navigator.of(context)
                    .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                  return new Register();
                }));
              }
              ),
            ],
          ),

        ),
      ),
    );
  }
}