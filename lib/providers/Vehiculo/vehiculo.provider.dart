import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/servicios/shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/views/vehiculos/listaVehiculos/vehiculo.dart';


class VehiculoProvider extends ChangeNotifier {

  List<Map<String, dynamic>> vehiculos = [];
  bool loading = false;
  String? rol;
    Set<String> _placasExistentes = Set<String>(); // Lista para las placas existentes


  Future<void> obtenerVehiculos(String idCliente) async {
    try {
      loading = true;
      notifyListeners();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(idCliente)
          .collection('vehiculos')
          .get();

      vehiculos = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      Future.delayed(Duration(seconds: 2), () {
        loading = false;
        notifyListeners();
      });

    }
    catch (e) {
      // Error handling
    }
  }

  Stream<List<Map<String, dynamic>>> obtenerVehiculosStream(String idCliente) {
    return FirebaseFirestore.instance
        .collection('usuarios')
        .doc(idCliente)
        .collection('vehiculos')
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return {...doc.data() as Map<String, dynamic>, 'id': doc.id};
      }).toList();
    });
  }

  Future<void> guardarVehiculo(
    Map<String, dynamic> cliente,
    TextEditingController marcaController,
    TextEditingController modeloController,
    TextEditingController placaController,
    TextEditingController colorController,
    TextEditingController kilometrajeEntradaController,
    TextEditingController tipoCombustibleController,
    //TextEditingController numeroChasisController,
    BuildContext context,
    GlobalKey<FormState> formKey
    ) async {

        if (formKey.currentState!.validate()) {
          try {
             loading = true;
             notifyListeners();
             Map<String, dynamic> clienteTemp = cliente ;

             final vehiculoRef = FirebaseFirestore.instance
                 .collection('usuarios')
                 .doc(clienteTemp['uid'])
                 .collection('vehiculos')
                 .doc();

             String vehiculoId = vehiculoRef.id;

             await vehiculoRef.set({
             'uid': vehiculoId,
             'marca': marcaController.text,
             'modelo': modeloController.text,
             'placa': placaController.text,
             'color': colorController.text,
             'kilometrajeEntrada': kilometrajeEntradaController.text,
             'tipoCombustible': tipoCombustibleController.text,
             //'numeroChasis': numeroChasisController.text
             });

             Future.delayed(Duration(seconds: 2), () {
               loading = false;
               notifyListeners();
             });

             formKey.currentState?.reset();
             marcaController.clear();
             modeloController.clear();
             placaController.clear();
             colorController.clear();
             kilometrajeEntradaController.clear();
             tipoCombustibleController.clear();
             //numeroChasisController.clear();

             Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (context) => Vehiculo(cliente: clienteTemp),
               ),
             );

             const SnackBar(content: Text('Vehículo agregado con éxito'));

          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${e.message}')),
            );
          }
      }
  }

  Future<void> editarVehiculo(

  Map<String, dynamic> cliente,
    String idVehiculo,
    TextEditingController marcaController,
    TextEditingController modeloController,
    TextEditingController placaController,
    TextEditingController colorController,
    TextEditingController kilometrajeEntradaController,
    TextEditingController tipoCombustibleController,
    //TextEditingController numeroChasisController,
    BuildContext context,
    GlobalKey <FormState> formkey
    ) async {
      if (formkey.currentState!.validate()) {
        try {
          Map<String, dynamic> clienteTemp = cliente ;

          loading = true;
          notifyListeners();
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(clienteTemp['uid'])
              .collection('vehiculos')
              .doc(idVehiculo)
              .update({
            'marca': marcaController.text,
            'modelo': modeloController.text,
            'placa': placaController.text,
            'color': colorController.text,
            'kilometrajeEntrada': kilometrajeEntradaController.text,
            'tipoCombustible': tipoCombustibleController.text,
            //'numeroChasis': numeroChasisController.text
          });

          Future.delayed(Duration(seconds: 2), () {
            loading = false;
            notifyListeners();
          });

          formkey.currentState?.reset();
          marcaController.clear();
          modeloController.clear();
          placaController.clear();
          colorController.clear();
          kilometrajeEntradaController.clear();
          tipoCombustibleController.clear();
          //numeroChasisController.clear();

        Navigator.push(context,
          MaterialPageRoute
          (builder:(context) => Vehiculo(cliente: clienteTemp),),
        );

        const SnackBar(content:Text('Vehículo actualizado con éxito'));
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        }
      }
    }


  Future<void> loadUserRole() async {
    rol = await Shared.getCredentials('rol');
    notifyListeners();
  }
  


  Future<void> obtenerPlacasExistentes() async {

    final FirebaseFirestore db = FirebaseFirestore.instance;

    final Set<String> placasExistentes = Set<String>();

    final usuariosSnap = await db.collection('usuarios').get();

    for (var usuarioDoc in usuariosSnap.docs) {
      final usuarioId = usuarioDoc.id;

      final vehiculosSnap = await db
          .collection('usuarios')
          .doc(usuarioId)
          .collection('vehiculos')
          .get();

      for (var vehiculoDoc in vehiculosSnap.docs) {
        final vehiculoPlaca = vehiculoDoc.data()['placa'];
        placasExistentes.add(vehiculoPlaca);
      }
    }

    _placasExistentes = placasExistentes;
    notifyListeners();
  }

  Future<bool> verificarPlacaExistente(String placa) async {
    return _placasExistentes.contains(placa);
  }
}