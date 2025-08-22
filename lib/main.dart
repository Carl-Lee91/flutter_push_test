import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('백그라운드 메시지 수신: $message');
}

Future<void> setupFcm() async {
  final fcm = FirebaseMessaging.instance;

  await fcm.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  try {
    final String? fcmToken = await fcm.getToken();

    if (fcmToken != null) {
      debugPrint("✅ FCM Token입니다!!! 이걸 넣으면 됩니다: $fcmToken");
    } else {
      debugPrint("🚨 토큰 없음");
    }

    fcm.onTokenRefresh.listen((newToken) {
      debugPrint("🔄 New FCM Token: $newToken");
    });
  } catch (e) {
    debugPrint("🔥 FCM Token Error: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //TODO: 파이어베이스 옵션 제작 후
    //options: DefaultFirebaseOptions.currentPlatform
  );

  await setupFcm();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('📱 포그라운드 메시지 수신!');
    if (message.notification != null) {
      debugPrint('제목: ${message.notification!.title}');
      debugPrint('본문: ${message.notification!.body}');
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('푸시테스트')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
