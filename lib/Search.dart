// Flutter code sample for DropdownButton

// This sample shows a `DropdownButton` with a large arrow icon,
// purple text style, and bold purple underline, whose value is one of "One",
// "Two", "Free", or "Four".
//
// ![](https://flutter.github.io/assets-for-api-docs/assets/material/dropdown_button.png)

import 'package:e_relax_hybrid/AppBar/AppBarWidget.dart';
import 'package:e_relax_hybrid/SearchResult.dart';
import 'package:flutter/material.dart';

/// This Widget is the main application widget.
class Search extends StatefulWidget {
  static const String _title = 'Search';

  @override
  State<StatefulWidget> createState() {
    return _MyStatefulWidgetState();
  }
}



class _MyStatefulWidgetState extends State<Search> {
  var selectedCurrency, selectedType;
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  List<String> _accountType = <String>[
    'Gurgaon',
    'Delhi',
    'Banglore',
    'Chandigarh'
  ];

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: appBarWidget(context, "Search"),
        body: Form(
          key: _formKeyValue,
          autovalidate: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            children: <Widget>[
              SizedBox(height: 20.0),
              new TextFormField(
                controller: myController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    labelText: 'Search',
                  ),
              ),

              SizedBox(height: 20.0),
              Row(
                children: <Widget>[
                  DropdownButton(
                    items: _accountType
                        .map((value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: TextStyle(color: Colors.blue),
                      ),
                      value: value,
                    ))
                        .toList(),
                    onChanged: (selectedAccountType) {
                      print('$selectedAccountType');
                      setState(() {
                        selectedType = selectedAccountType;
                      });
                    },
                    value: selectedType,
                    isExpanded: false,
                    hint: Text(
                      'Choose Location',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
              SizedBox(height:15.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text("Submit", style: TextStyle(fontSize: 24.0)),
                            ],
                          )),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                          return new SearchResult(myController.text);
                        }));
                      },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0))),
                ],
              ),
            ],
          ),
        ));
  }
}
