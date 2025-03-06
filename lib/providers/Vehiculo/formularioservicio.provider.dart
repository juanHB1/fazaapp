import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdenServicioFormProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String fecha = '';
  String descripcion = '';
  String estado = 'Pendiente';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setFecha(String value) {
    fecha = value;
    notifyListeners();
  }

  void setDescripcion(String value) {
    descripcion = value;
    notifyListeners();
  }

  void setEstado(String value) {
    estado = value;
    notifyListeners();
  }

  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  // 📌 Guardar la orden de servicio en Firebase Firestore
  Future<void> saveOrdenServicio(String idVehiculo) async {
    if (!validateForm()) return;

    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('ordenes_servicio').add({
        "fecha": fecha,
        "descripcion": descripcion,
        "estado": estado,
        "idVehiculo": idVehiculo, // Relación con el vehículo
        "timestamp": FieldValue.serverTimestamp(), // Para ordenar por fecha
      });

      debugPrint("Orden de servicio guardada en Firebase.");
    } catch (e) {
      debugPrint("Error al guardar la orden: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}