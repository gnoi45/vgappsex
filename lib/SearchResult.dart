import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_relax_hybrid/AppBar/AppBarWidget.dart';
import 'package:e_relax_hybrid/design/ProductDetailsScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
  await client.post('http://shopninja.in/e-relax/api2/public/index.php/getSearchProduct',body: {"product_name":""+searchx});

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
  final String profile_pic;
  final String title;
  final String filepath;

  Photo({this.name, this.id, this.title, this.profile_pic, this.filepath});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      name: json['product_title'] as String,
      id: json['id'] as String,
      title: json['product_sale_price'] as String,
      profile_pic: json['product_regular_price'] as String,
      filepath: json['image'] as String,
    );
  }
}

String searchx;
class SearchResult extends StatelessWidget {

  SearchResult(String search)
  {
    searchx=search;
  }

  @override
  Widget build(BuildContext context) {
    final appTitle = 'Search Results';

    return MaterialApp(
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context, "Search Results"),
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Photo> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        crossAxisCount: 2,
        padding: EdgeInsets.only(
            top: 8, left: 6, right: 6, bottom: 12),
        children: List.generate(photos.length, (index) {
          return Container(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                    return new ProductDetailsScreen(photos[index].id);
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
    );

  }
}
