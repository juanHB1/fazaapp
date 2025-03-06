import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/Register/registro.provider.dart';
import 'package:flutter_application_1/providers/Vehiculo/formularioservicio.provider.dart';
import 'package:flutter_application_1/providers/Vehiculo/orderservicio.provider.dart';
import 'package:flutter_application_1/providers/Vehiculo/vehiculo.provider.dart';
import 'package:flutter_application_1/providers/Clientes/cliente.provider.dart';
import 'package:flutter_application_1/providers/login/login.provider.dart';
//import 'package:flutter_application_1/views/RegistroClientes/registroClientes.dart';
import 'package:flutter_application_1/views/home/home.dart';
import 'package:flutter_application_1/views/listadoclientes/listaclientes.dart';
import 'package:flutter_application_1/views/login/login.dart';
import 'package:flutter_application_1/views/vehiculos/homevehiculos/vehiculo.dart';
import 'package:flutter_application_1/views/vehiculos/vistaordendeservicio/ordenservicio.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';




Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create : (_)=>LoginProvider() ),
        ChangeNotifierProvider(create : (_)=>RegisterProvider() ),
        ChangeNotifierProvider(create : (_)=>VehiculoProvider() ),
        ChangeNotifierProvider(create: (_)=>ClientesProvider()),
        ChangeNotifierProvider(create: (_)=>OrdenesServicioProvider()),
        ChangeNotifierProvider(create: (_)=>OrdenServicioFormProvider()),

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
        '/home': (context) => BienvenidaScreen(),
        '/clientes': (context) => const ListaCliente(),
        '/vehiculos': (context) => const Vehiculo(cliente: {}),
        '/ordenes': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

          if (args == null || args['idVehiculo'] == null) {
            return Scaffold(
              appBar: AppBar(title: Text("Órdenes de Servicio")),
              body: Center(child: Text("Error: No se encontró información del vehículo.")),
            );
          }

          return OrdenesServicio(idVehiculo: args['idVehiculo'], vehiculo: args['vehiculo']);
        },
},


    );
  }
}

