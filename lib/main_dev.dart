import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import 'app.dart';

void main() {
  FlavorConfig(
    name: "STAGING",
    color: Colors.orange,
    variables: {
      "hostURL": 'dev.com',
    },
  );
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}
