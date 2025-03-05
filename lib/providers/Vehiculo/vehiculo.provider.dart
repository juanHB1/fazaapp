import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/views/vehiculos/vehiculo.dart';


class VehiculoProvider extends ChangeNotifier {

  List<Map<String, dynamic>> vehiculos = [];
  bool loading = false;

  /// Método asíncrono para obtener clientes desde Firebase Firestore.
  /// Retorna una lista de mapas con los datos de los vehiculos que estan asociados con usuarios almacenados en la colección 'vehiculos'.
  Future<void> obtenerVehiculos(String idCliente) async {
    try {
      loading = true;
      notifyListeners();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios') // Colección principal
          .doc(idCliente) // Documento del usuario específico
          .collection('vehiculos') // Subcolección
          .get(); // Obtener datos

      vehiculos = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      Future.delayed(Duration(seconds: 2), () {
        loading = false;
        notifyListeners();
      });

      
      debugPrint(vehiculos.toString());
    }
    catch (e) {
      // Captura errores en la consulta, los imprime en la consola y retorna una lista vacía.
      debugPrint("Error al obtener clientes: $e");
    }
  }

//Mostrar previsualización de los vehiculos

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
    TextEditingController numeroChasisController,
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
                  .doc(clienteTemp['id'])
                  .collection('vehiculos')
                  .doc(); // 🔹 Genera un ID manualmente

              String vehiculoId = vehiculoRef.id; // 🔹 Obtiene el ID generado

              await vehiculoRef.set({ // 🔹 Guarda los datos con el ID
              'uid': vehiculoId,
              'marca': marcaController.text,
              'modelo': modeloController.text,
              'placa': placaController.text,
              'color': colorController.text,
              'kilometrajeEntrada': kilometrajeEntradaController.text,
              'tipoCombustible': tipoCombustibleController.text,
              'numeroChasis': numeroChasisController.text
              });

              Future.delayed(Duration(seconds: 2), () {
                loading = false;
                notifyListeners();
              });

              // Resetea el formulario y limpia los campos
              formKey.currentState?.reset();
              marcaController.clear();
              modeloController.clear();
              placaController.clear();
              colorController.clear();
              kilometrajeEntradaController.clear();
              tipoCombustibleController.clear();
              numeroChasisController.clear();
              
              Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Vehiculo(cliente: clienteTemp),
                ),
              );
              //notifyListeners();
              //Navigator.pushNamed(context, '/vehiculos');

              const SnackBar(content: Text('Vehvuículo agregado con éxito'));

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
    TextEditingController numeroChasisController,
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
              .doc(clienteTemp['id'])
              .collection('vehiculos')
              .doc(idVehiculo)
              .update({
            'marca': marcaController.text,
            'modelo': modeloController.text,
            'placa': placaController.text,
            'color': colorController.text,
            'kilometrajeEntrada': kilometrajeEntradaController.text,
            'tipoCombustible': tipoCombustibleController.text,
            'numeroChasis': numeroChasisController.text
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
          numeroChasisController.clear();

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
    
  }
