import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_ppb/services/api_service.dart';

// Handler untuk notifikasi saat app di background/terminated
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance =
      NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel =
      AndroidNotificationChannel(
    'tubes_ppb_channel',
    'Tubes PPB Notifications',
    description: 'Notifikasi reminder latihan harian',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    await _requestPermission();
    await _setupLocalNotifications();
    _setupFCMHandlers();
    await _getFCMToken();
  }

  Future<void> _requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    print('Notification permission: ${settings.authorizationStatus}');
  }

  Future<void> _setupLocalNotifications() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation;
            AndroidFlutterLocalNotificationsPlugin>()
        .createNotificationChannel(_channel);

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        print('Notification tapped: ${details.payload}');
      },
    );
  }

  void _setupFCMHandlers() {
    // Saat app di foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message: ${message.messageId}');
      _showLocalNotification(message);
    });

    // Saat app di background dan notifikasi diklik
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened app: ${message.messageId}');
      _handleNotificationTap(message);
    });

    // Background handler
    FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler);
  }

  Future<void> _getFCMToken() async {
    try {
      final token = await _fcm.getToken();
      print('=== FCM TOKEN ===');
      print(token);

      // Refresh token otomatis
      _fcm.onTokenRefresh.listen((newToken) async {
        print('FCM Token refreshed: $newToken');
        await _saveTokenToServer(newToken);
      });
    } catch (e) {
      print('Error get FCM token: $e');
    }
  }

  // Dipanggil setelah login berhasil
  Future<void> saveTokenAfterLogin() async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenToServer(token);
      }
    } catch (e) {
      print('Error saveTokenAfterLogin: $e');
    }
  }

  Future<void> _saveTokenToServer(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('api_user_id');

      if (userId == null || userId <= 0) {
        print('userId null, skip save token');
        return;
      }

      // Cek apakah token sudah pernah disimpan
      final savedToken = prefs.getString('saved_fcm_token');
      if (savedToken == token) {
        print('FCM token sama, skip save');
        return;
      }

      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/save_token.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'fcm_token': token,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        await prefs.setString('saved_fcm_token', token);
        print('FCM token berhasil disimpan ke server');
      } else {
        print('Gagal simpan FCM token: ${data['message']}');
      }
    } catch (e) {
      print('Error save FCM token: $e');
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    print('Notification data: $data');
  }

  // Notifikasi Lokal

  Future<void> showReminderLatihan() async {
    await _localNotifications.show(
      1,
      '💪 Waktunya Latihan!',
      'Jangan lupa latihan hari ini. Yuk mulai sekarang!',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFFCF0F0F),
        ),
      ),
      payload: 'reminder_latihan',
    );
  }

  Future<void> showLatihanSelesai(String hariKe) async {
    await _localNotifications.show(
      2,
      '🎉 Latihan Selesai!',
      'Keren! Kamu berhasil menyelesaikan $hariKe. Terus semangat!',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Colors.green,
        ),
      ),
      payload: 'latihan_selesai',
    );
  }

  Future<void> showMilestone(int hariSelesai) async {
    String judul = '';
    String pesan = '';

    switch (hariSelesai) {
      case 3:
        judul = '⭐ Milestone 3 Hari!';
        pesan = 'Luar biasa! Kamu sudah latihan 3 hari berturut-turut!';
        break;
      case 6:
        judul = '🌟 Milestone 6 Hari!';
        pesan =
            'Setengah jalan! Kamu sudah selesai 6 dari 12 hari latihan!';
        break;
      case 9:
        judul = '💫 Milestone 9 Hari!';
        pesan = 'Hampir sampai! Tinggal 3 hari lagi menuju finish!';
        break;
      case 12:
        judul = '🏆 Tantangan Selesai!';
        pesan =
            'LUAR BIASA! Kamu telah menyelesaikan semua 12 hari tantangan!';
        break;
      default:
        return;
    }

    await _localNotifications.show(
      3,
      judul,
      pesan,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: Colors.amber,
        ),
      ),
      payload: 'milestone_$hariSelesai',
    );
  }

  Future<void> showWelcomeNotification(String nama) async {
    await _localNotifications.show(
      4,
      '👋 Selamat Datang, $nama!',
      'Mulai perjalanan sehatmu hari ini. Semangat!',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFFCF0F0F),
        ),
      ),
      payload: 'welcome',
    );
  }
}

extension on Type {
  void operator >(other) {}
}

extension on () {
  createNotificationChannel(AndroidNotificationChannel channel) {}
}