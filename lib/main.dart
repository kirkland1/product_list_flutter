import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:product_list/widgets/login_page.dart';

import 'models/user_model.dart';

void main() {
  runApp(
      ChangeNotifierProvider(
          create: (context) => UserModel(),
          child: const MyApp()
      ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays:[]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Acme',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(title: 'SignIn Page'),
    );
  }
}

