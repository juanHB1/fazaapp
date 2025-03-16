import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdenesServicioProvider extends ChangeNotifier {


  List<Map<String, dynamic>> ordenes = [];
  bool loading = false;


  Future<void> obtenerOrdenesServicio(String idVehiculo, Map<String, dynamic> cliente) async {
    debugPrint(cliente.toString());
    try {
      
      loading = true;
      notifyListeners();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios') // 🔹 Empezamos desde la colección correcta
          .doc(cliente['uid']) // 🔹 ID del usuario
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

  void mostrarPrevisualizacion(BuildContext context, Map<String, dynamic> ordenServicio) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Detalles del Cliente", 
        style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Orden de servicio:", style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Colors.blueGrey[800],
                      fontSize: 14
                    )),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(ordenServicio["descripcion"],
                          style: TextStyle(color: Colors.blueGrey[700], fontSize: 20)),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estado del servicio:', style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Colors.blueGrey[800],
                      fontSize: 14
                    )),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(ordenServicio["estado"],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ordenServicio["estado"] == 'ingresado'
                                ? Colors.yellow[800]
                                : ordenServicio["estado"] == 'espera'
                                    ? Colors.red[800]
                                    : Colors.blue[800], // Mejor visibilidad del texto
                          ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fecha de ingreso:', style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Colors.blueGrey[800],
                      fontSize: 14
                    )),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(ordenServicio["fecha"],
                          style: TextStyle(color: Colors.blueGrey[700], fontSize: 14)),
                    ),
                  ],
                ),
              ),

              // //Fecha cambio de aceite

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Fecha cambio de aceite:', style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Colors.blueGrey[800],
                      fontSize: 14
                    )),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(ordenServicio["fechaCambioAceite"] ?? 'No tienes fecha de cambio de aceite',
                          style: TextStyle(color: Colors.blueGrey[700], fontSize: 14)),
                    ),
                  ],
                ),
              ),
              
              //Proximo cambio de aceite
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Próximo cambio de aceite:', style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Colors.blueGrey[800],
                      fontSize: 14
                    )),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(ordenServicio["proximoCambioAceite"] ?? 'No tienes fecha de cambio de aceite',
                          style: TextStyle(color: Colors.blueGrey[700], fontSize: 14)),
                    ),
                  ],
                ),
              ),

              


            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.blueGrey[900])),
          )
        ],
      ),
    );
  }

  Widget _infoDialogRow (String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(
            fontWeight: FontWeight.bold, 
            color: Colors.blueGrey[800],
            fontSize: 14
          )),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value,
                style: TextStyle(color: Colors.blueGrey[700], fontSize: 14)),
          ),
        ],
      ),
    );
  }

}
