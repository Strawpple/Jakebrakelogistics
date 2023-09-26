import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jb1/components/utils.dart';
import 'package:jb1/pages/formalUpdate.dart';
import 'package:jb1/pages/home.dart';
import 'package:jb1/pages/home2.dart';
import 'package:jb1/pages/information.dart';
import 'package:jb1/pages/login.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:jb1/pages/map.dart';
import 'package:jb1/pages/otp.dart';
import 'package:jb1/pages/password.dart';
import 'package:jb1/pages/trackers.dart';
import 'package:jb1/pages/tracking.dart';
import 'firebase_options.dart';

final FlutterLocalNotificationsPlugin flutterLocalPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel notificationChannel =
    AndroidNotificationChannel("coding is life", "code service",
        description: "Thanks");
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initservice();
  runApp(const MyApp());
}

Future<void> initservice() async {
  //set for IOS
  if (Platform.isIOS) {
    await flutterLocalPlugin.initialize(
        const InitializationSettings(iOS: DarwinInitializationSettings()));
  }
  await flutterLocalPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(notificationChannel);
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jakebrake Logistics Tracker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      scaffoldMessengerKey: Utils.messengerKey,
      // home: otp(),

      home: MyHomePage(title: ''),
      // home: googleMap(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder<User?>(
          initialData: null,
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong!'),
              );
            } else if (snapshot.hasData) {
              return homepage2();
            } else {
              return login();
            }
          },
        ),
      ),
    );
  }
}
