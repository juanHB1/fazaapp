import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClientesProvider extends ChangeNotifier {
  
  
  List<Map<String, dynamic>> clientes = [];


  Future<List<Map<String, dynamic>>> obtenerClientes() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance.collection('usuarios').get();
      
      List<Map<String, dynamic>> clientes = query.docs.map((doc) {
        return {
          "nombres": doc["nombre"], 
          "apellidos": doc["apellido"],
          "email": doc["email"],
          "password": doc["password"],
          "rol": doc["rol"],
          "telefono": doc["telefono"],
          "id": doc["uid"]
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