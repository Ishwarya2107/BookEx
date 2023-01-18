//final project

import 'package:bookex/match.dart';

import 'package:bookex/profile.dart';
import 'package:bookex/register.dart';
import 'package:bookex/chat.dart';
import 'package:flutter/material.dart';
import 'package:bookex/photo.dart';
import 'package:bookex/welcome.dart';
import 'package:bookex/login.dart';
import 'package:bookex/add.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const Loginscreen(),

        '/photo': (context) => const MainFrontEnd(),
        '/register': (context) => const Registerscreen(),
        '/match': (context) => const Notifyscreen(),
        '/profile': (context) => Profile(),
        '/add': (context) => const Addpage(),
        '/chat': (context) => const Chatscreen(),
      },
    );
  }
}
