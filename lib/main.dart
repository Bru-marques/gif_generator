// https://api.giphy.com/v1/gifs/trending?api_key=IxKR8YnGKf75yZ4l9rzeyB0l3YkIeyX8&limit=25&rating=g

// https://api.giphy.com/v1/gifs/search?api_key=IxKR8YnGKf75yZ4l9rzeyB0l3YkIeyX8&q=pug&limit=25&offset=25&rating=g&lang=en

import 'package:flutter/material.dart';
import 'package:gif_generator/ui/home_page.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}
