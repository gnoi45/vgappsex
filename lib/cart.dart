import 'dart:convert';

import 'package:e_relax_hybrid/Razorpay.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'AppUrl.dart';
import 'home/home.dart';
import 'main.dart';


Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
  await client.post(AppUrl.GET_CART, body: {
    "customer_id": ""+xx_id
  });

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed1 = jsonDecode(responseBody);
  final parsed=parsed1["msg"].cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final String name;
  final String id;
  final String cart_id;
  final String quantity;
  final String title;
  final String filepath;

  Photo({this.name, this.id, this.cart_id,this.title, this.quantity, this.filepath});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      name: json['product_title'] as String,
      id: json['productID'] as String,
      cart_id:json['cart_id'] as String,
      title: json['product_sale_price'] as String,
      quantity: json['quantity'] as String,
      filepath: json['image'] as String,
    );
  }
}

String mainx(List<Photo> args) {
  var sum = 0;

  for (var i = 0; i < args.length; i++) {
    sum += int.parse(args.single.title);
  }

  return sum.toString();
}



class CartList  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? _CartListState(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _CartListState extends StatelessWidget{

  final List<Photo> photos;




  _CartListState({Key key, this.photos}) : super(key: key);

//  final List<Map<dynamic, dynamic>> products = [
//    {'name': 'IPhone', 'rating': 3.0, 'image': 'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80', 'price': '200'},
//    {'name': 'IPhone X 2', 'rating': 3.0, 'image': 'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80', 'price': '200'},
//    {'name': 'IPhone 11', 'rating': 4.0, 'image': 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80', 'price': '200'},
//
//  ];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: Container(
                  child: Text(photos.length.toString() + " ITEMS IN YOUR CART", textDirection: TextDirection.ltr, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
              ),
            ),
            Flexible(
              child: ListView.builder(
                  itemCount: photos.length,
                  itemBuilder: (context, index) {
                    final Photo item = photos[index];
                    return Dismissible(
                      // Each Dismissible must contain a Key. Keys allow Flutter to
                      // uniquely identify widgets.
                      key: Key(UniqueKey().toString()),
                      // Provide a function that tells the app
                      // what to do after an item has been swiped away.
                      onDismissed: (direction) {
                        if(direction == DismissDirection.endToStart) {
                          remove(photos[index].cart_id);
                        } else {
                          // Then show a snackbar.
                          Scaffold.of(context)
                              .showSnackBar(SnackBar(content: Text(item.name + " added to carts"), duration: Duration(seconds: 1)));
                        }
                        // Remove the item from the data source.

                          photos.removeAt(index);

                      },
                      // Show a red background as the item is swiped away.
                      background: Container(
                        decoration: BoxDecoration(color: Colors.red),
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Icon(Icons.delete, color: Colors.white),
                    ),

                          ],
                        ),
                      ),
                      secondaryBackground: Container(
                        decoration: BoxDecoration(color: Colors.red),
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),

                          ],
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          print('Card tapped.');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Divider(
                              height: 0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: ListTile(
                                trailing: Text('${item.title}'),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue
                                    ),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: item.filepath,
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()
                                      ),
                                      errorWidget: (context, url, error) => new Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  item.name,
                                  style: TextStyle(
                                      fontSize: 14
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(top: 2.0, bottom: 1),
                                          child: Text('in stock', style: TextStyle(
                                            color: Theme.of(context).accentColor,
                                            fontWeight: FontWeight.w700,
                                          )),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom :30.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text("TOTAL", style: TextStyle(fontSize: 16, color: Colors.grey),)
                          ),
                          Text("Rs "+mainx(photos),  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 15.0),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Expanded(
                    //           child: Text("Subtotal", style: TextStyle(fontSize: 14))
                    //       ),
                    //       Text("\$36.00", style: TextStyle(fontSize: 14, color: Colors.grey)),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 15.0),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Expanded(
                    //           child: Text("Shipping",  style: TextStyle(fontSize: 14))
                    //       ),
                    //       Text("\$2.00", style: TextStyle(fontSize: 14, color: Colors.grey)),
                    //     ],
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 15.0),
                    //   child: Row(
                    //     children: <Widget>[
                    //       Expanded(
                    //           child: Text("Tax",  style: TextStyle(fontSize: 14))
                    //       ),
                    //       Text("\$3.24", style: TextStyle(fontSize: 14, color: Colors.grey)),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 50, bottom: 10),
              child: ButtonTheme(
                buttonColor: Theme.of(context).primaryColor,
                minWidth: double.infinity,
                height: 40.0,
                child: RaisedButton(
                  onPressed: () {
                    try {
                      var options = {
                        'key': 'rzp_live_Gr62yIQq7GZDTL',
                        'amount': ""+mainx(photos),
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
                  child: Text(
                    "CHECKOUT",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        )
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

  remove(String cart_id) async {
    final response = await http
        .post("http://shopninja.in/e-relax/api2/public/index.php/removecart", body: {
      "cart":""+cart_id
    });

    final data = jsonDecode(response.body);
    int value = data['status'];

    if (value == 200) {


      loginToast("Removed Successfully");
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

}
