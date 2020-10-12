import 'package:e_relax_hybrid/Contactus.dart';
import 'package:e_relax_hybrid/MyOrders.dart';
import 'package:e_relax_hybrid/ProfileText.dart';
import 'package:e_relax_hybrid/Proxorders.dart';
import 'package:e_relax_hybrid/UserProfile.dart';
import 'package:e_relax_hybrid/getAllServices.dart';
import 'package:e_relax_hybrid/main.dart';
import 'package:e_relax_hybrid/test/AppSignIn.dart';
import 'package:e_relax_hybrid/test/OTP.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Login.dart';
import '../Products.dart';
import '../Terms.dart';
import '../cart.dart';
import '../faq_page.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

String x_id;
class _AppDrawerState extends State<AppDrawer> {

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
      x_id = preferences.getString("id");
    });
  }



  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("YES"),
      onPressed: () {
        signOut();
      },
    );

    Widget Cancel = FlatButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you want to Logout?"),
      actions: [okButton, Cancel],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
//    AuthBlock auth = Provider.of<AuthBlock>(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home, color: Theme.of(context).accentColor),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_basket,
                    color: Theme.of(context).accentColor),
                title: Text('Products'),
//                trailing: Text('New',
//                    style: TextStyle(color: Theme.of(context).primaryColor)),
                onTap: () {
//                  Navigator.pop(context);
//                  Navigator.pushNamed(context, '/Products');

//                  Navigator.push(context, new MaterialPageRoute(
//                      builder: (context) => Products()
//                  ));
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new Products();
                  }));
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.category, color: Theme.of(context).accentColor),
                title: Text('My Orders'),
                onTap: () {
                  if (x_id == null || x_id.isEmpty) {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new AppSignIn();
                    }));
                  } else if(x_id.isNotEmpty){
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new Proxorders();
                    }));
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.border_clear,
                    color: Theme.of(context).accentColor),
                title: Text('Services'),
                onTap: () {
                  //Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new getAllServices();
                  }));
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle,
                    color: Theme.of(context).accentColor),
                title: Text('Profile'),
                onTap: () {
                  if (x_id == null || x_id.isEmpty) {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new AppSignIn();
                    }));
                  } else if(x_id.isNotEmpty){
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new ProfileText();
                    }));
                  }
                },
              ),
              Divider(),
              // ListTile(
              //   leading:
              //       Icon(Icons.ac_unit, color: Theme.of(context).accentColor),
              //   title: Text('FAQ'),
              //   onTap: () {
              //     //Navigator.pop(context);
              //     Navigator.of(context).push(
              //         MaterialPageRoute<Null>(builder: (BuildContext context) {
              //       return new FaqPage();
              //     }));
              //   },
              // ),
              ListTile(
                leading:
                    Icon(Icons.title, color: Theme.of(context).accentColor),
                title: Text('Terms & Conditions'),
                onTap: () {
//                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new Terms();
                  }));
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.contacts, color: Theme.of(context).accentColor),
                title: Text('Contact Us'),
                onTap: () {
//                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new Contactus();
                  }));
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app,
                    color: Theme.of(context).accentColor),
                title: Text('Logout'),
                onTap: () async {
                  if (x_id == null || x_id.isEmpty) {
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                      return new AppSignIn();
                    }));
                  } else if(x_id.isNotEmpty){
                    showAlertDialog(context);
                  }
                },
              )
            ],
          ),
        )
      ],
    );
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("value", null);
      preferences.setString("name", null);
      preferences.setString("email", null);
      preferences.setString("id", null);
      preferences.setInt("status", null);

      preferences.commit();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute<Null>(builder: (BuildContext context) {
        return new AppSignIn();
      }));
    });
  }
}
