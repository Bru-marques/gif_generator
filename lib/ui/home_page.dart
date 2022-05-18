import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gif_generator/ui/gif_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search = "";
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == "") {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=IxKR8YnGKf75yZ4l9rzeyB0l3YkIeyX8&limit=25&rating=g"));
    } else {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=IxKR8YnGKf75yZ4l9rzeyB0l3YkIeyX8&q=$_search&limit=25&offset=$_offset&rating=g&lang=en"));
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getGifs().then((map) {
      // print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif",
            width: 180),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: _body(),
      backgroundColor: const Color.fromARGB(255, 32, 38, 46),
    );
  }

  _body() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 20, 23, 27),
                  Color.fromARGB(255, 16, 17, 19)
                ],
                stops: [0.0, 0.8],
              ),
            ),
            height: 160,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Search",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Color.fromARGB(182, 234, 234, 234),
                  ),
                ),
                _searchBar(),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                switch (snapshot.connectionState) {
                  case (ConnectionState.waiting):
                  case (ConnectionState.none):
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGifTable(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return TextField(
      onSubmitted: (text) {
        setState(() {
          _search = text;
        });
      },
      style: const TextStyle(color: Color.fromARGB(255, 234, 234, 234)),
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.search_rounded,
          color: Color.fromARGB(182, 234, 234, 234),
        ),
        hintText: "cute dog",
        hintStyle: TextStyle(
          color: Color.fromARGB(182, 234, 234, 234),
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
        labelStyle: TextStyle(color: const Color.fromARGB(255, 234, 234, 234)),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Color.fromARGB(95, 41, 44, 48),
        // focusedBorder: InputBorder(),
      ),
    );
  }

  Widget _createGifTable(BuildContext, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 30),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: snapshot.data["data"].length,
      itemBuilder: (context, int index) {
        return GestureDetector(
            child: Image.network(
              snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          GifPage(snapshot.data["data"][index])));
            });
      },
    );
  }
}
