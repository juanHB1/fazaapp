import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/Register/registro.provider.dart';
import 'package:flutter_application_1/providers/Vehiculo/vehiculo.provider.dart';
import 'package:flutter_application_1/providers/login/login.provider.dart';
import 'package:flutter_application_1/views/Register/registro.dart';
import 'package:flutter_application_1/views/login/login.dart';
import 'package:flutter_application_1/views/vehiculos/vehiculo.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create : (_)=>LoginProvider() ),
        ChangeNotifierProvider(create : (_)=>RegisterProvider() ),
        ChangeNotifierProvider(create : (_)=>VehiculoProvider() ),

      ],
      
      child: const MyApp(),
      )
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo juan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/registroUsuario': (context) => const Registro(),
        '/vehiculos': (context) => const Vehiculo(),
      },

    );
  }
}

