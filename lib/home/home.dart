import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_relax_hybrid/AppUrl.dart';
import 'package:e_relax_hybrid/ProductDetails.dart';
import 'package:e_relax_hybrid/Services.dart';
import 'package:e_relax_hybrid/design/EcommerceDetail4.dart';
import 'package:e_relax_hybrid/design/ProductDetailsScreen.dart';
import 'package:e_relax_hybrid/home/TopPromoSlider.dart';
import 'package:e_relax_hybrid/test/AppSignIn.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../LocationSearch.dart';
import '../Products.dart';
import '../Search.dart';
import '../cart.dart';
import '../getAllServices.dart';
import '../main.dart';
import 'drawer.dart';
import 'slider.dart';

String xx_id;
class Home extends StatefulWidget {
  @override
  HomeApi createState() => HomeApi();
}

Future<Mys> fetchPhotos(http.Client client) async {
  final response = await client
      .post(AppUrl.HOME_URL);

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
Mys parsePhotos(String responseBody) {
  final parsed1 = jsonDecode(responseBody);
  final parsed = parsed1["msg"].cast<Map<String, dynamic>>();
  final parsed2 = parsed1["msg1"].cast<Map<String, dynamic>>();

  List<Photo> photo =
      parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
  List<Category> category =
      parsed2.map<Category>((json) => Category.fromJson(json)).toList();

  //loginToast(parsed1["msg2"]);
  return Mys(photo, category, "");
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

class Mys {
  List<Photo> photo;
  List<Category> category;
  String cart;

  Mys(photo, category, cart) {
    this.photo = photo;
    this.category = category;
    this.cart = cart;
  }

  List<Photo> getphoto() {
    return photo;
  }

  List<Category> getCategory() {
    return category;
  }

  String getCart() {
    return cart;
  }
}

class Category {
  final String id;
  final String category_name;
  final String images;
  final String status;
  final String created_at;

  Category(
      {this.id, this.category_name, this.images, this.status, this.created_at});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      category_name: json['name'] as String,
      id: json['id'] as String,
      images: json['image'] as String,
      status: json['long_desc'] as String,
      created_at: json['sale_price'] as String,


      // name: json['name'] as String,
      // id: json['id'] as String,
      // long_desc: json['long_desc'] as String,
      // profile_pic: json['image'] as String,
      // sale_price: json['sale_price'] as String,
    );
  }
}

class Photo {
  final String name;
  final String id;
  final String long_desc;
  final String price;
  final String filepath;

  Photo({this.name, this.id, this.price, this.long_desc, this.filepath});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      name: json['product_title'] as String,
      id: json['id'] as String,
      price: json['product_sale_price'] as String,
      long_desc: json['long_description'] as String,
      filepath: json['image'] as String,
    );
  }
}

class HomeApi extends State<Home> {

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
      xx_id = preferences.getString("id");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Mys>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? _HomeState(
                  photos: snapshot.data.getphoto(),
                  category: snapshot.data.getCategory(),
                  cart: snapshot.data.getCart())
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class Cats
{
   String name;
   String image;

   Cats(this.image, this.name);


}

class _HomeState extends StatelessWidget {
  final List<Photo> photos;
  final List<Category> category;
  final String cart;
  List<Cats> imgList= [
    Cats('https://www.erelaxindia.com/assets2/car-wash.jpg','Electricity Controller'),
    Cats('https://res.cloudinary.com/urbanclap/image/upload/q_auto,f_auto,fl_progressive:steep,w_64/t_high_res_template/categories/category_v2/category_72d18950.png','Door Automation'),
    Cats('https://res.cloudinary.com/urbanclap/image/upload/q_auto,f_auto,fl_progressive:steep,w_64/t_high_res_template/categories/category_v2/category_72d18950.png','Motion Sensor'),
    Cats('https://res.cloudinary.com/urbanclap/image/upload/q_auto,f_auto,fl_progressive:steep,w_64/t_high_res_template/categories/category_v2/category_72d18950.png','Gas and Smoking Detector')
  ];


  _HomeState({Key key, this.photos, this.category, this.cart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: AppDrawer(),
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: CustomScrollView(
            // Add the app bar and list of items as slivers in the next steps.
            slivers: <Widget>[
              SliverAppBar(
                // Provide a standard title.
                backgroundColor: Colors.white,
                iconTheme: new IconThemeData(color: Colors.blue),
                title: Text('Home',
                    style: TextStyle(
                        color: Colors.blue, fontFamily: 'Roboto-Light.ttf')),
                pinned: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                            return new LocationSearch();
                          }));
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute<Null>(
                          builder: (BuildContext context) {
                        return new Search();
                      }));
                    },
                  ),
                  IconButton(
                    icon: Badge(
                      badgeContent: Text("" + cart),
                      child: Icon(Icons.shopping_cart, color: Colors.blue),
                    ),
                    //,
                    onPressed: () {
                      if (xx_id == null || xx_id.isEmpty) {
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          return new AppSignIn();
                        }));
                      } else if(xx_id.isNotEmpty){
                        Navigator.of(context).push(MaterialPageRoute<Null>(
                            builder: (BuildContext context) {
                          return new CartList();
                        }));
                      }
                    },
                  )
                ],
                // Allows the user to reveal the app bar if they begin scrolling
                // back up the list of items.
                // floating: true,
                // Display a placeholder widget to visualize the shrinking size.

//                : HomeSlider(),
//                // Make the initial height of the SliverAppBar larger than normal.
//                expandedHeight: 300,
              ),
              SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      HomeSlider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0),
                            child: Text('Top Categories',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 17,
                                    fontFamily: 'Roboto-Light.ttf',
                                    fontWeight: FontWeight.w700)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, top: 8.0, left: 8.0),
                            child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text('View All',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
//                                  Navigator.pushNamed(context, '/categorise');

//                                  Navigator.of(context).push(
//                                      MaterialPageRoute<Null>(
//                                          builder: (BuildContext context) {
//                                            return new Products();
//                                          }));
                                }),
                          )
                        ],
                      ),

                      Container(
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          padding: EdgeInsets.only(
                              top: 8, left: 6, right: 6, bottom: 12),
                          children: List.generate(imgList.length, (index) {
                            return Container(
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () {
                                   Navigator.of(context).push(
                                       MaterialPageRoute<Null>(
                                           builder: (BuildContext context) {
                                             return new ProductDetailsScreen(
                                                 photos[index].id);
                                           }));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height:
                                        (MediaQuery.of(context).size.width /
                                            2) -
                                            70,
                                        width: double.infinity,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.contain,
                                          imageUrl: imgList[index].image,
                                          placeholder: (context, url) => Center(
                                              child:
                                              CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                          new Icon(Icons.error),
                                        ),
                                      ),
                                      ListTile(
                                          title: Text(
                                            imgList[index].name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0),
                            child: Text('Top Products',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 17,
                                    fontFamily: 'Roboto-Light.ttf',
                                    fontWeight: FontWeight.w700)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, top: 8.0, left: 8.0),
                            child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text('View All',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
//                                  Navigator.pushNamed(context, '/categorise');

                                  Navigator.of(context).push(
                                      MaterialPageRoute<Null>(
                                          builder: (BuildContext context) {
                                    return new Products();
                                  }));
                                }),
                          )
                        ],
                      ),

                      Container(
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          padding: EdgeInsets.only(
                              top: 8, left: 6, right: 6, bottom: 12),
                          children: List.generate(photos.length, (index) {
                            return Container(
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute<Null>(
                                            builder: (BuildContext context) {
                                      return new ProductDetailsScreen(
                                          photos[index].id);
                                    }));
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height:
                                            (MediaQuery.of(context).size.width /
                                                    2) -
                                                70,
                                        width: double.infinity,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: photos[index].filepath,
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                        ),
                                      ),
                                      ListTile(
                                          title: Text(
                                        photos[index].name,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0),
                            child: Text('Top Services',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 17,
                                    fontFamily: 'Roboto-Light.ttf',
                                    fontWeight: FontWeight.w700)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, top: 8.0, left: 8.0),
                            child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text('View All',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
//                                  Navigator.pushNamed(context, '/categorise');

                                  Navigator.of(context).push(
                                      MaterialPageRoute<Null>(
                                          builder: (BuildContext context) {
                                            return new getAllServices();
                                          }));
                                }),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        height: 240.0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: category.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: 140.0,
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute<Null>(builder:
                                                (BuildContext context) {
                                              return new ServiceDetailScreen(i.id);
                                            }));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 160,
                                            child: Hero(
                                              tag: i.id.toString(),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: i.images,
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                        CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                new Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              i.category_name,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  // Builds 1000 ListTiles
                  childCount: 1,
                ),
              )
            ]),
      ),
    );
  }
}
