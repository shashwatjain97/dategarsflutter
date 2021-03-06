import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';

void main() => runApp(PetSection());

class PetSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GalleryDemo(),
    );
  }
}

class GalleryDemo extends StatelessWidget {
  GalleryDemo({Key? key}) : super(key: key);
  String url = "https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/data.json";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: FutureBuilder<List<String>>(
            future: fetchGalleryData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    itemCount: snapshot.data!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                              decoration: new BoxDecoration(
                                  image: new DecorationImage(
                                      image: new NetworkImage(
                                          snapshot.data![index]),
                                      fit: BoxFit.cover))));
                    });
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}

Future<List<String>> fetchGalleryData() async {
  try {
    String uri = "https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/data.json";
    final response = await http
        .get(Uri.parse(uri),headers: {'Accept': 'application/json'}
        )
        .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      return compute(parseGalleryData, response.body);
    } else {
      throw Exception('Failed to load');
    }
  } on SocketException catch (e) {
    throw Exception('Failed to load');
  }
}

List<String> parseGalleryData(String responseBody) {
  final parsed = List<String>.from(json.decode(responseBody));
  return parsed;
}