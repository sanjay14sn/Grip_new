import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:grip/backend/orientation_lock.dart';
import 'package:grip/backend/providers/Homerefreshprovider.dart';
import 'package:grip/backend/providers/location_provider.dart';
import 'package:grip/pages/navigator_key.dart';
import 'package:grip/backend/providers/chapter_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:grip/backend/gorouter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

// 🔔 Background FCM Handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
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

  // ✅ Load .env file
  await dotenv.load();
  await Firebase.initializeApp();
  await lockOrientationToPortrait(); // 🔐 Lock orientation
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

    // 🔗 Get FCM Token
    final fcmToken = await messaging.getToken();

    if (fcmToken != null) {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'fcm_token', value: fcmToken);
    }

    // 🔁 Handle token refresh (optional but recommended)
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'fcm_token', value: newToken);
    });

    // 📩 Foreground message listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
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
      if (message != null) {}
    });

    // 🔁 App resumed from background by tapping notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  }

  // 📶 Connectivity handling
  Future<void> _checkInitialConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _handleConnectivityChange(result);
  }

  Future<void> _handleConnectivityChange(ConnectivityResult result) async {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    final router = GoRouter.of(context);
    final currentUri =
        router.routerDelegate.currentConfiguration.uri.toString();

    final hasNetwork = result != ConnectivityResult.none;
    final hasInternet = await _checkInternet();

    if (!hasNetwork || !hasInternet) {
      if (!currentUri.contains('/networkerror')) {
        router.go('/networkerror');
      }
    } else {
      if (currentUri.contains('/networkerror')) {
        router.go('/homepage'); // Or your fallback screen
      }
    }
  }

  Future<bool> _checkInternet() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void _handleError(Object error) {}

  void _handleDone() {}

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
            ChangeNotifierProvider(create: (_) => ChapterProvider()),
            ChangeNotifierProvider(create: (_) => HomeRefreshNotifier()),
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
