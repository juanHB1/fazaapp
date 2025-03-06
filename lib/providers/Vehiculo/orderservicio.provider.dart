import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdenesServicioProvider extends ChangeNotifier {


  List<Map<String, dynamic>> ordenes = [];
  bool loading = false;


  Future<void> obtenerOrdenesServicio(String idVehiculo, String clienteId) async {

    try {
      
      loading = true;
      notifyListeners();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios') // 🔹 Empezamos desde la colección correcta
          .doc(clienteId) // 🔹 ID del usuario
          .collection('vehiculos')
          .doc(idVehiculo)
          .collection('ordenServicio')
          .get();

      ordenes = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      debugPrint(ordenes.toString());
      loading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error al obtener órdenes de servicio: $e");
    }
  }
}
