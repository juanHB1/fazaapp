import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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

  // Configuración para notificaciones locales en Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Inicialización del plugin de notificaciones
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Solicita permisos de notificación al usuario
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
