import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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

  Future<void> agregarVehiculo(
    String uid, 
    TextEditingController marca, 
    TextEditingController modelo, 
    TextEditingController anio, 
    TextEditingController color,
    TextEditingController placa,
    TextEditingController vin,
    context,
    formkey
     ) async {
     
        if (formkey.currentState!.validate()) {
          try {
              
              final vehiculoRef = FirebaseFirestore.instance
                  .collection('usuarios')
                  .doc('fOeCSB7f60aNKfjNSqIPAby5mYy1')
                  .collection('vehiculos')
                  .doc(); // 🔹 Genera un ID manualmente

              String vehiculoId = vehiculoRef.id; // 🔹 Obtiene el ID generado

              await vehiculoRef.set({ // 🔹 Guarda los datos con el ID
                'id': vehiculoId, // 🔹 Guarda el ID dentro del documento
                'marca': marca.text,
                'modelo': modelo.text,
                'anio': anio.text,
                'color': color.text,
                'placa': placa.text,
                'vin': vin.text,
              });

              const SnackBar(content: Text('Vehvuículo agregado con éxito'));
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${e.message}')),
            );
          }
      } 
  }
}