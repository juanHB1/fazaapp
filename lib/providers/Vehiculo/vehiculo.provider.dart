import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class VehiculoProvider extends ChangeNotifier {

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