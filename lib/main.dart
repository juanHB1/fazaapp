import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


// Importación de todos los providers usados globalmente
import 'package:flutter_application_1/providers/login/login.provider.dart';
import 'package:flutter_application_1/providers/Register/registro.provider.dart';
import 'package:flutter_application_1/providers/Vehiculo/vehiculo.provider.dart';
import 'package:flutter_application_1/providers/Vehiculo/orderservicio.provider.dart';
import 'package:flutter_application_1/providers/Vehiculo/formularioservicio.provider.dart';
import 'package:flutter_application_1/providers/Clientes/cliente.provider.dart';
import 'package:flutter_application_1/providers/notificacionCambioAceiteProximo/notificacionCambioAceiteProximoProvider.dart';

// Importación de vistas
import 'package:flutter_application_1/views/login/login.dart';
import 'package:flutter_application_1/views/home/home.dart';
import 'package:flutter_application_1/views/listadoclientes/listaclientes.dart';
import 'package:flutter_application_1/views/vehiculos/listaVehiculos/vehiculo.dart';
import 'package:flutter_application_1/views/notificacionCambioAceiteProximo/notificacionCambioAceiteProximo.dart';



// Instancia global para notificaciones locales
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura que Flutter esté completamente inicializado
  
  await Firebase.initializeApp(); // Inicializa Firebase

  await inicializarFirebaseMessaging();

  await Permission.notification.request();
  

  // Inicialización de la app con MultiProvider para usar Provider globalmente
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => VehiculoProvider()),
        ChangeNotifierProvider(create: (_) => ClientesProvider()),
        ChangeNotifierProvider(create: (_) => OrdenesServicioProvider()),
        ChangeNotifierProvider(create: (_) => OrdenServicioFormProvider()),
        ChangeNotifierProvider(create: (_) => NotificacionCambioAceiteProximoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Faza Ingeniería', // Título global de la app
      supportedLocales: const [
        Locale('es', 'ES'), // Soporte para español
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Tema base
        useMaterial3: true,
      ),
      initialRoute: '/', // Ruta inicial: Login
      routes: {
        '/': (context) => const Login(),
        '/home': (context) => BienvenidaScreen(),
        '/clientes': (context) => const ListaCliente(),
        '/vehiculos': (context) => const Vehiculo(cliente: {}),
        '/notificacionCambioAceiteProximo': (context) => const NotificacionCambioAceiteProximo(),
      },
    );
  }
}

Future<void> inicializarFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Solicita permiso para recibir notificaciones
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Permiso para notificaciones concedido');
  } else {
    print('Permiso para notificaciones denegado');
  }

  // Opcional: obtener token para enviar notificaciones a este dispositivo
  String? token = await messaging.getToken();
  print('Token FCM: $token');

  // Configurar handler para mensajes cuando la app está en primer plano
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Mensaje recibido en primer plano: ${message.messageId}');
    // Aquí puedes mostrar notificación local o hacer algo con el mensaje
  });
}
