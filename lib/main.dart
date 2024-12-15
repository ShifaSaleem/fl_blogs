import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:fl_blogs/providers/auth_provider.dart';
import 'package:fl_blogs/screens/blog_detail_screen.dart';
import 'package:fl_blogs/screens/blogs_feed.dart';
import 'package:fl_blogs/screens/login_screen.dart';
import 'package:fl_blogs/screens/signup_screen.dart';
import 'package:fl_blogs/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'models/blog_post.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  late final BlogPost blogData;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/blogDetail' : (context) => BlogDetailScreen(blogData: blogData),
        '/feed': (context) => BlogsFeedScreen(),
      },
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final AuthProviders _authProvider = AuthProviders();
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(milliseconds: 5000),
            () => _authProvider.checkUserAuthentication(
                  () => Navigator.pushReplacementNamed(context, '/feed'),
                  () => Navigator.pushReplacementNamed(context, '/login'),
    ));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff217DA1), Color(0xffAAD238)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Center(
            child: Image.asset('assets/images/logo_white.svg'
              //image: AssetImage('assets/images/logo_white.svg'),
            )),
      ),
    );
  }
}
