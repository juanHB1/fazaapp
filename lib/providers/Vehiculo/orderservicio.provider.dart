import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdenesServicioProvider extends ChangeNotifier {
  List<Map<String, dynamic>> ordenes = [];
  bool loading = false;

  Future<void> obtenerOrdenesServicio(String idVehiculo) async {
    try {
      loading = true;
      notifyListeners();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('vehiculos')
          .doc(idVehiculo)
          .collection('ordenes_servicio')
          .get();

      ordenes = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      loading = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error al obtener órdenes de servicio: $e");
      loading = false;
      notifyListeners();
    }
  }
}
