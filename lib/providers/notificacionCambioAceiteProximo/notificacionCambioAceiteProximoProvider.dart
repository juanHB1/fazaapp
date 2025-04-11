import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class NotificacionCambioAceiteProximoProvider extends ChangeNotifier {

Future<void> obtenerOrdenesProximas() async {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final DateTime hoy = DateTime.now();
  final DateTime dentroDe7Dias = hoy.add(Duration(days: 7)); // o cualquier rango que quieras

  final List<Map<String, dynamic>> resultados = [];

  // 1. Obtener todos los usuarios
  final usuariosSnap = await db.collection('usuarios').get();

  for (var usuarioDoc in usuariosSnap.docs) {
    final usuarioId = usuarioDoc.id;

    // 2. Obtener vehículos de cada usuario
    final vehiculosSnap = await db
        .collection('usuarios')
        .doc(usuarioId)
        .collection('vehiculos')
        .get();

    for (var vehiculoDoc in vehiculosSnap.docs) {
      final vehiculoId = vehiculoDoc.id;

      // 3. Obtener órdenes de servicio con filtros
      final ordenesSnap = await db
          .collection('usuarios')
          .doc(usuarioId)
          .collection('vehiculos')
          .doc(vehiculoId)
          .collection('ordenServicio')
          .where('estadoPago', isEqualTo: 'Pagado')
          .where('estadoServicio', isEqualTo: 'terminado')
          .where('proximoCambioAceite', isLessThanOrEqualTo: Timestamp.fromDate(dentroDe7Dias))
          .get();

      for (var orden in ordenesSnap.docs) {
        resultados.add({
          'usuarioId': usuarioId,
          'vehiculoId': vehiculoId,
          'ordenId': orden.id,
          'data': orden.data(),
        });
      }
    }
  }

  debugPrint("Órdenes encontradas: ${resultados}");
  // Aquí puedes usar `resultados` como necesites
}

  
}