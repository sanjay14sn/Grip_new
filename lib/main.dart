import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/providers/location_provider.dart';
import 'package:grip/pages/navigator_key.dart';
import 'package:grip/providers/person_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:grip/backend/gorouter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 🔔 Background FCM Handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 Handling a background message: ${message.messageId}");
}

// 🔔 Local Notifications Plugin and Channel
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // name
  importance: Importance.high,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  print("✅ Firebase initialized successfully");

  // 🔧 Local Notifications Initialization
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidInitSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initFCM(); // ✅ Init FCM
    _checkInitialConnectivity();

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
          _handleConnectivityChange,
          onError: _handleError,
          onDone: _handleDone,
        );
  }

  Future<void> _initFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 🔐 Request permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('📲 User granted permission: ${settings.authorizationStatus}');

    // 🔗 Get FCM Token
    final fcmToken = await messaging.getToken();
    print("🎯 FCM Token: $fcmToken");

    // 📩 Foreground message listener with local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Received foreground message: ${message.notification?.title}');

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: '@mipmap/ic_launcher',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    // 📲 App launched by tapping notification
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(
            '🚀 App launched by tapping notification: ${message.notification?.title}');
      }
    });

    // 🔁 App resumed from background by tapping notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔄 App resumed from background: ${message.notification?.title}');
    });
  }

  // 📶 Connectivity handling
  Future<void> _checkInitialConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _handleConnectivityChange(result);
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    final currentUri =
        GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();

    if (result == ConnectivityResult.none) {
      if (!currentUri.contains('/networkerror')) {
        context.push('/networkerror');
      }
    } else {
      if (currentUri.contains('/networkerror')) {
        context.pop();
      }
    }
  }

  void _handleError(Object error) {
    print('Connectivity error: $error');
  }

  void _handleDone() {
    print('Connectivity stream closed.');
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LocationProvider()),
            ChangeNotifierProvider(create: (_) => PersonProvider()),
            // Add other providers here if needed
          ],
          child: MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue),
            builder: (context, child) => child!,
          ),
        );
      },
    );
  }
}
