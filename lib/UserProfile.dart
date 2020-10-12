import 'package:e_relax_hybrid/AllAddress.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Address.dart';
import 'ChangePassword.dart';
import 'EditProfile.dart';

class UserProfile extends StatefulWidget {
  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
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
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment(1, 1),
                width: MediaQuery.of(context).size.width,
                height: 190,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage("https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80"),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: new BorderRadius.circular(60),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white, size: 32,
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      border: Border(
                          bottom: BorderSide( //                   <--- left side
                            color: Colors.grey[300],
                            width: 1.0,
                          )
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                      child: Text(
                        x,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child:  ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.edit, color: Theme.of(context).accentColor, size: 28,),
                        title: Text('Edit Profile', style: TextStyle(color: Colors.black, fontSize: 17)),
                        trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                        onTap: (){ Navigator.of(context)
                            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                          return new EditProfile();
                        }));},
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.vpn_key, color: Theme.of(context).accentColor, size: 28,),
                        title: Text('Address', style: TextStyle(color: Colors.black, fontSize: 17)),
                        trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                        onTap: (){ Navigator.of(context)
                            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                          return new AllAddress();
                        }));},
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.lock, color: Theme.of(context).accentColor, size: 28,),
                        title: Text('Logout', style: TextStyle(color: Colors.black, fontSize: 17)),
                        trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).accentColor),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        )
    );
  }
}
