import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      location: BannerLocation.bottomStart,
      child: MaterialApp(
        title: 'Hudas 3D Buddy',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
