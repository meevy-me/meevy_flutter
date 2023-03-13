import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:soul_date/models/models.dart';
import 'package:soul_date/screens/invite_page.dart';
import 'package:soul_date/screens/send_spot_screen.dart';
import 'package:soul_date/screens/splash_screen.dart';
import 'package:soul_date/services/notifications.dart';
import 'package:soul_date/show_data_argument.dart';
import 'package:soul_date/theme/theme.dart';

import 'init_data.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  NotificationApi.showNotification(
      id: message.notification.hashCode,
      title: message.notification?.title,
      body: message.notification?.body);
}

const String homeRoute = "home";
const String shareData = "shareData";
const String inviteRoute = 'invite';
Future<InitData> init() async {
  String sharedText = "";
  String routeName = homeRoute;
  //This shared intent work when application is closed
  String? sharedValue = await ReceiveSharingIntent.getInitialText();
  if (sharedValue != null) {
    sharedText = sharedValue;
    routeName = routeName.contains("https://meevy.me/app/invite/")
        ? inviteRoute
        : shareData;
  }
  return InitData(sharedText, routeName);
}

late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InitData initData = await init();
  await Firebase.initializeApp();
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  await Hive.initFlutter();
  Hive.registerAdapter(ProfileAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProfileImagesAdapter());
  Hive.openBox<Profile>('profile');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationApi.showNotification(
        title: message.notification!.title, body: message.notification!.body);
  });

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // print(store);
    runApp(MyApp(
      initData: initData,
    ));
  }
}

bool isInviteLink(String? inviteLink) {
  if (inviteLink == null) {
    return false;
  }
  return inviteLink.contains("/app/invite");
}

bool isSpotifyLink(String? spotifyLink) {
  if (spotifyLink == null) {
    return false;
  }
  return spotifyLink.contains("https://open.spotify.com/");
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.initData}) : super(key: key);

  final InitData initData;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription _intentDataStreamSubscription;
  final _navKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((value) {
      if (isSpotifyLink(value)) {
        _navKey.currentState!.pushNamed(
          shareData,
          arguments: ShowDataArgument(value),
        );
      }
    });
  } // This widget is the root of your application.

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: _navKey,
      title: 'Meevy',
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.primary(),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == shareData) {
          if (settings.arguments != null) {
            final args = settings.arguments as ShowDataArgument;
            return MaterialPageRoute(
                builder: (_) => ShareDataScreen(
                      sharedText: args.sharedText,
                    ));
          } else {
            return MaterialPageRoute(
                builder: (_) => ShareDataScreen(
                      sharedText: widget.initData.sharedText,
                    ));
          }
        } else if (isInviteLink(settings.name)) {
          print("Hello");
          if (settings.arguments != null) {
            return MaterialPageRoute(
                builder: (_) => InvitePage(
                      sharedText: settings.name!,
                    ));
          } else {
            return MaterialPageRoute(
                builder: (_) => InvitePage(
                      sharedText: settings.name!,
                    ));
          }
        } else {
          return MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          );
        }
      },
      // initialRoute: widget.initData.routeName,
    );
  }
}
