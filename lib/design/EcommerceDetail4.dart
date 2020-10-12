import 'dart:convert';

import 'package:e_relax_hybrid/Address.dart';
import 'package:e_relax_hybrid/AppBar/AppBarWidget.dart';
import 'package:e_relax_hybrid/AppUrl.dart';
import 'package:e_relax_hybrid/test/AppSignIn.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home/home.dart';


import '../Razorpay.dart';

String slug;
String x_id;
int xx=0;

class ServiceDetailScreen extends StatefulWidget {
  ServiceDetailScreen(String x) {
    slug = x;
  }

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ServiceDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    xx=0;
    getPref();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      int status = preferences.getInt("status");
      x_id = preferences.getString("id");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfafafa),
      appBar: appBarWidget(context, "Service Details"),
      body: FutureBuilder(
        future: getDetails(),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return createDetailView(context, snapshot);
          }
        },
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: RaisedButton(
        elevation: 0,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            side: BorderSide(color: Colors.blue)),
        onPressed: () {
          if (x_id == null || x_id.isEmpty) {
            Navigator.of(context)
                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
              return new AppSignIn();
            }));
          } else if (x_id.isNotEmpty) {
    //        try {
            //   var options = {
            //     'key': 'rzp_live_BM4umL9VjVnfaq',
            //     'amount': 100,
            //     'name': 'Acme Corp.',
            //     'description': 'Fine T-Shirt',
            //     'prefill': {
            //       'contact': '8888888888',
            //       'email': 'test@razorpay.com'
            //     }
            //   };
            //   Razorpay _razorpay = Razorpay();
            //   _razorpay.open(options);
            //   _razorpay.on(
            //       Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
            //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
            //   _razorpay.on(
            //       Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
            // } catch (e) {}

            book();


          }
        },
        color: Colors.blue,
        textColor: Colors.white,
        child: Container(
          padding: EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 15),
          child: Text("Buy Now".toUpperCase(),
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white)),
        ),
      ),
    );
  }


  book() async {
    final response = await http
        .post(AppUrl.BOOK_SERVICE, body: {
      "cust_id": x_id,
      "service_id": slug
    });

    // loginToast("cust_id"+xx_id+" service_id"+slug);
    final data = jsonDecode(response.body);
    int value = data['status'];

    if (value == 200) {

      // String mobile = data['msg']['mobile'];
      // String emailAPI = data['msg']['email'];
      // String nameAPI = data['msg']['fullname'];
      // String id = data['msg']['id'];
      // // setState(() {
      //   _state=0;
      //   savePref(mobile, emailAPI, nameAPI, id,value);
      // });
      print("Logged IN");
      loginToast("Booked Successfully");
      // Navigator.of(context)
      //     .pushReplacement(MaterialPageRoute<Null>(builder: (BuildContext context) {
      //   return new Home();
      // }));
    } else {
      // setState(() {
      //   _state=0;
      // });
      print("fail");
      loginToast("Some Error Occurred");
    }
  }

}



void _handlePaymentSuccess(PaymentSuccessResponse response) {
  // Do something when payment succeeds
}

void _handlePaymentError(PaymentFailureResponse response) {
  // Do something when payment fails
}

void _handleExternalWallet(ExternalWalletResponse response) {
  // Do something when an external wallet was selected
}

Widget createDetailView(BuildContext context, AsyncSnapshot snapshot) {
  SUBS values = snapshot.data;
  return DetailScreen(
    productDetails: values,
  );
}

class DetailScreen extends StatefulWidget {
  SUBS productDetails;

  DetailScreen({Key key, this.productDetails}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState(productDetails);
}


_launchURL(String url) async {
  String urls=Uri.encodeFull(url);
  if (await canLaunch(urls)) {
    await launch(urls);
  } else {
    loginToast("Path Not Correct");
  }
}

ServiceType selectedType;

class _DetailScreenState extends State<DetailScreen> {
  ServiceType dropdownValue;
  TextEditingController myController;
  SUBS productDetails;


  void initState() {
    // TODO: implement initState
    super.initState();
    getDropDownItem();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    dropdownValue=null;
    xx=0;
    super.dispose();
  }


  void getDropDownItem(){

    setState(() {

      if(dropdownValue!=null && !dropdownValue.name.toString().contains("Select Service Type"))
        {
          selectedType = dropdownValue ;
          myController = TextEditingController(text: dropdownValue.price);
          //loginToast(selectedType.name);
          return;
        }


      myController = TextEditingController(text: productDetails.model.product_sale);
    });
  }


  _DetailScreenState(SUBS subs)
  {
    productDetails=subs;
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          /*Image.network(
              widget.productDetails.data.productVariants[0].productImages[0]),*/
          Image.network(
            widget.productDetails.model.image,
            fit: BoxFit.fill,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),

      Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        color: Colors.white,
          child:
          Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("What are you Looking For",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                      SizedBox(
                        height: 15,
                      ),
          DropdownButton(
            items: widget.productDetails.serv
                .map((value) => DropdownMenuItem(
              child: Text(
                value.name,
                style: TextStyle(color: Colors.blue),
              ),
              value: value,
            ))
                .toList(),
            onChanged: (selectedAccountType) {
              //print(selectedAccountType.toString());
              setState(() {
                // if(xx==0)
                //   {
                //     xx+=1;
                //   }
                // else {
                //   dropdownValue = selectedAccountType;
                //   getDropDownItem();
                // }
                dropdownValue = selectedAccountType;
                  getDropDownItem();
              });
            },
            value: selectedType,
            isExpanded: true,
            hint: Text(
              'Select Service Type',
              style: TextStyle(color: Colors.blue),
            ),
          ),
  ],
          )

        ),
          SizedBox(
            height: 10,
          ),

          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
//                Text("SKU".toUpperCase(),
//                    style: TextStyle(
//                        fontSize: 16,
//                        fontWeight: FontWeight.w700,
//                        color: Color(0xFF565656))),
                Text(widget.productDetails.model.title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFfd0100))),
//                Icon(
//                  Icons.arrow_forward_ios,
//                  color: Color(0xFF999999),
//                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Price".toUpperCase(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                Text(
                   myController.text,
                    style: TextStyle(
                        color: (Color(0xFF0dc2cd)),
                        fontFamily: 'Roboto-Light.ttf',
                        fontSize: 20,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Description",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                SizedBox(
                  height: 15,
                ),
                Html(
                  data: widget.productDetails.model.long_desc,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Ratings & Reviews",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                Text("5 star",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFfd0100))),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF999999),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
      new GestureDetector(
        onTap: (){
          //loginToast(dropdownValue.rate_card.toString());
          _launchURL("http://erelaxindia.com/assets2/service_files/"+dropdownValue.rate_card.toString());
        },
          child:Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
            color: Color(0xFFFFFFFF),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Show Rate Sheets",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF565656))),
                SizedBox(
                  height: 15,
                ),
//                Column(
//                  children: generateProductSpecification(context),
//                )
              ],
            ),
          )
      )
        ],
      ),
    );
  }

//  List<Widget> generateProductSpecification(BuildContext context) {
//    List<Widget> list = [];
//    int count = 0;
//    widget.productDetails.data.productSpecifications.forEach((specification) {
//      Widget element = Container(
//        height: 30,
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: <Widget>[
//            Text(specification.specificationName,
//                textAlign: TextAlign.left,
//                style: TextStyle(
//                    fontSize: 14,
//                    fontWeight: FontWeight.w400,
//                    color: Color(0xFF444444))),
//            Text(specification.specificationValue,
//                textAlign: TextAlign.left,
//                style: TextStyle(
//                    fontSize: 14,
//                    fontWeight: FontWeight.w400,
//                    color: Color(0xFF212121))),
//          ],
//        ),
//      );
//      list.add(element);
//      count++;
//    });
//    return list;
//  }
}

class SUBS{
  Model model;
  List<ServiceType> serv;

  SUBS(this.model,this.serv);
}

class Model {
  String title;
  String image;
  String long_desc;
  String product_sale;

  Model(this.title, this.image, this.long_desc, this.product_sale);
}

Future<SUBS> getDetails() async {
  final response = await http.post(
      AppUrl.SINGLE_SERVICE,
      body: {"service_id": "" + slug});


  final response1 =
  await http.post(AppUrl.SERVICE_TYPE,body: {
    "service_id":""+slug
  });

  // Use the compute function to run parsePhotos in a separate isolate.
  List<ServiceType>  list= parsePhotos(response1.body);


  final data = jsonDecode(response.body);
  int value = data['status'];

  if (value == 200) {
    String product_sale_price = data['msg']['sale_price'];
    String long_description = data['msg']['long_desc'];
    String nameAPI = data['msg']['name'];
    String id = data['msg']['service_id'];
    String image = data['msg']['image'];

    //loginToast(nameAPI);
    return SUBS(Model(nameAPI, image, long_description, product_sale_price),list);
  } else {
    print("fail");
    loginToast("Some Error Occurred");
    // return SUBS("", "");|
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


class CArt extends StatelessWidget {
  String productName;

  CArt({
    Key key,
    @required this.productName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
          color: Colors.black12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(productName,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF565656))),
              Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF999999),
              )
            ],
          ),
        );
  }
}



class ServiceType {
  final String price;
  final String rate_card;
  final String show_rate;
  final String name;

  ServiceType({this.price, this.rate_card, this.show_rate,this.name});


  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
        price: json['price'] as String,
        rate_card: json['rate_card'] as String,
        show_rate: json['show_rate'] as String,
      name:json['name'] as String
    );
  }

  @override
  String toString() {
    return '{ ${this.name}, ${this.show_rate}, ${this.rate_card}, ${this.price} }';
  }

}

// Future<List<ServiceType>> fetchPhotos(http.Client client) async {
//   final response =
//   await client.post('http://shopninja.in/e-relax/api2/public/index.php/singleService',body: {
//     "service_id":""+slug
//   });
//
//   // Use the compute function to run parsePhotos in a separate isolate.
//   return compute(parsePhotos, response.body);
// }

// A function that converts a response body into a List<Photo>.
List<ServiceType> parsePhotos(String responseBody) {
  final parsed1 = jsonDecode(responseBody);
  final parsed=parsed1["msg"] as List;
  List<ServiceType> tagObjs = parsed.map((tagJson) => ServiceType.fromJson(tagJson)).toList();

  return tagObjs;
}