import 'package:e_relax_hybrid/AppBar/AppBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<Panel> panels = [
    Panel(
        'HOW CAN I CHANGE MY SHIPPING ADDRESS?',
        'By default, the last used shipping address will be saved intoto your Sample Store account. When you are checkingout your order, the default shipping address will be displayedand you have the option to amend it if you need to.',
        false),
    Panel(
        'HOW CAN I TRACK MY ORDERS & PAYMENT?',
        'By default, the last used shipping address will be saved intoto your Sample Store account. When you are checkingout your order, the default shipping address will be displayedand you have the option to amend it if you need to.',
        false),
    Panel(
        'HOW LONG WILL IT TAKE FOR MY ORDER TO ARRIVE AFTER I MAKE PAYMENT?',
        'By default, the last used shipping address will be saved intoto your Sample Store account. When you are checkingout your order, the default shipping address will be displayedand you have the option to amend it if you need to.',
        false),
    Panel(
        'HOW DO YOU SHIP MY ORDERS?',
        'By default, the last used shipping address will be saved intoto your Sample Store account. When you are checkingout your order, the default shipping address will be displayedand you have the option to amend it if you need to.',
        false),
    Panel(
        'HOW DO I MAKE PAYMENTS USING Razorpay? HOW DOES IT WORK?',
        'By default, the last used shipping address will be saved intoto your Sample Store account. When you are checkingout your order, the default shipping address will be displayedand you have the option to amend it if you need to.',
        false)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(context, "FAQ"),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:24.0,right:24.0,bottom: 16.0),
              ),... panels.map((panel)=>ExpansionTile(
                  title: Text(
                    panel.title,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600]),
                  ),

                  children: [Container(
                      padding: EdgeInsets.all(16.0),
                      color: Color(0xffFAF1E2),
                      child: Text(
                          panel.content,
                          style:
                          TextStyle(color: Colors.grey, fontSize: 12)))])).toList(),

            ],
          ),
        ),
      ),
    );
  }
}

class Panel {
  String title;
  String content;
  bool expanded;

  Panel(this.title, this.content, this.expanded);
}