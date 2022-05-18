import 'package:flutter/material.dart';

class GifPage extends StatelessWidget {
  final Map _gifData;

  const GifPage(this._gifData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            _gifData["title"],
          ),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: _body());
  }

  _body() {
    return Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"]));
  }
}
