import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import 'app.dart';

void main() {
  FlavorConfig(
    variables: {
      "hostURL": 'prod.com',
    },
  );
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}
