import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClientesProvider extends ChangeNotifier {
  
  
  List<Map<String, dynamic>> clientes = [];


  Future<List<Map<String, dynamic>>> obtenerClientes() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance.collection('usuarios').get();

      if (query.docs.isEmpty) {
        return [];
      }


      List<Map<String, dynamic>> clientes = query.docs.map((doc) {
        return {
          "nombres": doc["nombre"] ?? "Sin nombre", 
          "apellidos": doc["apellido"] ?? "Sin apellido",
          "email": doc["email"] ?? "Sin email",
          "password": doc["password"] ?? "Sin password",
          "rol": doc["rol"] ?? "Sin rol",
          "telefono": doc["telefono"] ?? "Sin telefono",
          "id": doc["uid"] ?? "Sin uid"
        };
      }).toList();
      return clientes;
      
    } catch (e) {
      print("Error al obtener clientes: $e");
      return [];
    }
  }

  void cargarClientes() async {
    List<Map<String, dynamic>> datos = await obtenerClientes();
    clientes = datos;
    notifyListeners();
  }
    
}