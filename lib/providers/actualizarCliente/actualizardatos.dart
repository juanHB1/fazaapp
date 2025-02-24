import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClientesProvider extends ChangeNotifier {
  List<Map<String, dynamic>> clientes = []; // Lista local de clientes

  // Método para actualizar un cliente en Firestore
  Future<void> actualizarCliente(String id, Map<String, dynamic> nuevosDatos) async {
    try {
      // Actualiza el documento en Firestore
      await FirebaseFirestore.instance.collection('usuarios').doc(id).update(nuevosDatos);
      
      // Opcional: Actualiza la lista local de clientes
      int index = clientes.indexWhere((cliente) => cliente['id'] == id);
      if (index != -1) {
        clientes[index] = {
          ...clientes[index], // Conserva los datos antiguos
          ...nuevosDatos,     // Sobrescribe con los nuevos datos
        };
      }
      
      notifyListeners(); // Notifica a la UI para que se actualice
    } catch (e) {
      print("Error al actualizar cliente: $e");
      throw Exception("No se pudo actualizar el cliente: $e");
    }
  }

  // Método para cargar clientes (solo como referencia)
  Future<void> cargarClientes() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('usuarios').get();
    clientes = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
    notifyListeners();
  }
}