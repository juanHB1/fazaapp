import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificacionCambioAceiteProximoProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _ordenesProximas = [];
  bool _cargando = false;

  List<Map<String, dynamic>> get ordenesProximas => _ordenesProximas;
  bool get cargando => _cargando;

  Future<void> obtenerOrdenesProximas() async {
    _cargando = true;
    notifyListeners();

    final FirebaseFirestore db = FirebaseFirestore.instance;
    final DateTime hoy = DateTime.now();
    final DateTime dentroDe7Dias = hoy.add(Duration(days: 7));

    final List<Map<String, dynamic>> resultados = [];

    final usuariosSnap = await db.collection('usuarios').get();

    for (var usuarioDoc in usuariosSnap.docs) {
      final usuarioId = usuarioDoc.id;
      final nombreUsuario = usuarioDoc.data()['nombre'];
      final apellidoUsuario = usuarioDoc.data()['apellido'];
      final telefonoUsuario = usuarioDoc.data()['telefono'];

      final vehiculosSnap = await db
          .collection('usuarios')
          .doc(usuarioId)
          .collection('vehiculos')
          .get();

      for (var vehiculoDoc in vehiculosSnap.docs) {
        final vehiculoId = vehiculoDoc.id;
        final vehiculoPlaca = vehiculoDoc.data()['placa'];
        final vehiculoNombre = vehiculoDoc.data()['marca'];
        final vehiculoModelo = vehiculoDoc.data()['modelo'];
        final vehiculoKilometrajeActual = vehiculoDoc.data()['kilometrajeEntrada'];
        
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
            'nombreUsuario': nombreUsuario,
            'apellidoUsuario': apellidoUsuario,
            'telefonoUsuario': telefonoUsuario,
            'vehiculoId': vehiculoId,
            'vehiculoPlaca': vehiculoPlaca,
            'vehiculoNombre': vehiculoNombre,
            'vehiculoModelo': vehiculoModelo,
            'vehiculoKilometrajeActual': vehiculoKilometrajeActual,
            'ordenId': orden.id,
            'data': orden.data(),
          });
        }
      }
    }

    _ordenesProximas = resultados;
    _cargando = false;
    notifyListeners();
  }
}
