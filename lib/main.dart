import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/selectup.dart';
import 'pages/gallery.dart';
import 'pages/select.dart';

void main() async{
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tinpic",
      initialRoute: '/' ,
      routes: {
        '/': (context) => const Homepage(),
        '/upload': (context) => const UploadPage(),
        '/gallery': (context) =>  const GalleryPage(),
        '/select': (context) => const SwipeMenu(),
      },
    );
  }
}
