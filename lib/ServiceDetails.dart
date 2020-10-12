import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;

import 'Razorpay.dart';

String XY;

class ServiceDetails extends StatefulWidget {
  ServiceDetails(String id)
  {
    XY=id;
  }


  @override
  State<StatefulWidget> createState() {
    return ServiceDetailx();
  }
}

class ServiceDetailx extends State<ServiceDetails> {


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("Service Details")
        ),
        body:FutureBuilder<Model>(
          future: getDetails(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError)loginToast(snapshot.error);

            return snapshot.hasData
                ? Service(model:snapshot.data)
                : Center(child: CircularProgressIndicator());
          },
        )
    );

  }

}


Future<Model> getDetails(http.Client client) async {

  final response = await client
      .post("http://shopninja.in/e-relax/api2/public/index.php/singleService", body: {
    "service_id": ""+XY
  });

  final data = jsonDecode(response.body);
  int value = data['status'];

  if (value == 200) {
    String product_sale_price = data['msg']['sale_price'];
    String long_description = data['msg']['long_desc'];
    String nameAPI = data['msg']['name'];
    String id = data['msg']['service_id'];
    String image = data['msg']['image'];

    //loginToast(nameAPI);
    return Model(nameAPI,image,long_description,product_sale_price);
  } else {
    print("fail");
    loginToast("Some Error Occurred");
    return Model("","","","");
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


class Model{
  String title;
  String image;
  String long_desc;
  String product_sale;


  Model(this.title, this.image, this.long_desc, this.product_sale);


}

class Service extends StatelessWidget{
  final Model model;

  Service({Key key, this.model}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 260,
                child: Hero(
                  tag: "gkv",
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: model.image,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment(-1.0, -1.0),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Text(
                          model.title,
                          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  model.product_sale,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                  '\$200',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough
                                  )
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SmoothStarRating(
                                  allowHalfRating: false,
                                  starCount: 5,
//                                rating: product['rating'],
                                  size: 20.0,
                                  color: Colors.amber,
                                  borderColor: Colors.amber,
                                  spacing: -0.8
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                    '(0.00)',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    )
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment(-1.0, -1.0),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Description',
                                style: TextStyle(color: Colors.black, fontSize: 20,  fontWeight: FontWeight.w600),
                              ),
                            )
                        ),
                        Container(
                            alignment: Alignment(-1.0, -1.0),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Html(data:
                                model.long_desc,
                              ),
                            )
                        )
                      ],

                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: RaisedButton(
                        onPressed: () {
                          try {
                            var options = {
                              'key': 'rzp_live_BM4umL9VjVnfaq',
                              'amount': 100,
                              'name': 'Acme Corp.',
                              'description': 'Fine T-Shirt',
                              'prefill': {
                                'contact': '8888888888',
                                'email': 'test@razorpay.com'
                              }
                            };
                            Razorpay _razorpay = Razorpay();
                            _razorpay.open(options);
                            _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
                            _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
                            _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
                          }
                          catch(e)
                          {

                          }
                        },
                        child: const Text('Buy Now', style: TextStyle(fontSize: 20)),
                        color: Colors.blue,
                        textColor: Colors.white,
                        elevation: 5,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),

      ),
    );
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


}