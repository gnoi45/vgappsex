import 'dart:convert';
import 'package:e_relax_hybrid/AppUrl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


int _state=0;
class ForgetPassword extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ForgetPassw();
  }

}

class ForgetPassw extends State<ForgetPassword> {

  final myController = TextEditingController();


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }


  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        "Forget Password",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
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
                    alignment: Alignment.topRight,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child:  Text(
                      "Forget Password",
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
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      padding: EdgeInsets.all(17.0),
                      onPressed: ()
                      {
                        if(myController.text.isEmpty)
                          {
                            loginToast("Please Enter Email Id");
                            return;
                          }
                        setState(() {
                          _state=1;
                        });
                        forget(myController.text);
                      },
                      child: setUpButtonChild(),
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.blue)),
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  forget(String email) async {
    final response = await http
        .post(AppUrl.FORGET_URL, body: {
      "email": ""+email
    });

    final data = jsonDecode(response.body);
    int value = data['status'];
    String msg=data['msg'];

    if (value == 200) {
      setState(() {
        _state=0;
      });
      print("Logged IN");
      loginToast(msg);

    } else {
      setState(() {
        _state=0;
      });
      print("fail");
      loginToast(msg);
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



}
