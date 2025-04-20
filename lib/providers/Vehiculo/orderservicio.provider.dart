import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrdenesServicioProvider extends ChangeNotifier {
  List<Map<String, dynamic>> ordenes = [];
  bool loading = false;

  Future<void> obtenerOrdenesServicio(String idVehiculo, Map<String, dynamic> cliente) async {
    try {
      loading = true;
      notifyListeners();

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(cliente['uid'])
          .collection('vehiculos')
          .doc(idVehiculo)
          .collection('ordenServicio')
          .get();

      ordenes = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      loading = false;
      notifyListeners();
    } catch (e) {
      // Error handling can be added here if needed, but user requested to remove debug prints
    }
  }

  void mostrarPrevisualizacion(BuildContext context, Map<String, dynamic> ordenServicio) {
    // Determine status colors and icons for the dialog
    final estadoServicio = ordenServicio["estadoServicio"] ?? 'Desconocido';
    final estadoPago = ordenServicio["estadoPago"] ?? 'Desconocido';

    IconData estadoServicioIcon;
    Color estadoServicioColorText;

    if (estadoServicio == 'ingresado') {
      estadoServicioIcon = Icons.playlist_add_check_outlined;
      estadoServicioColorText = Colors.yellow[800]!;
    } else if (estadoServicio == 'espera') {
      estadoServicioIcon = Icons.hourglass_empty_outlined;
      estadoServicioColorText = Colors.red[800]!;
    } else if (estadoServicio == 'finalizado') {
       estadoServicioIcon = Icons.check_circle_outline;
       estadoServicioColorText = Colors.green[800]!;
    }
     else { // Default or 'proceso' etc
      estadoServicioIcon = Icons.settings_outlined;
      estadoServicioColorText = Colors.blue[800]!;
    }


    IconData estadoPagoIcon = estadoPago == 'Pagado' ? Icons.payment_outlined : Icons.money_off_csred_outlined;
    Color estadoPagoColorText = estadoPago == 'Pagado' ? Colors.green[800]! : Colors.orange[800]!;


    // Format dates for display
     final fechaIngresoFormatted = ordenServicio["fecha"] is Timestamp
         ? DateFormat('dd/MM/yyyy').format(ordenServicio["fecha"].toDate())
         : "sin fecha";
     final fechaCambioAceiteFormatted = ordenServicio["fechaCambioAceite"] is Timestamp
         ? DateFormat('dd/MM/yyyy').format(ordenServicio["fechaCambioAceite"].toDate())
         : "sin fecha";
     final proximoCambioAceiteFormatted = ordenServicio["proximoCambioAceite"] is Timestamp
         ? DateFormat('dd/MM/yyyy').format(ordenServicio["proximoCambioAceite"].toDate())
         : "sin fecha";


    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Detalles de la Orden de Servicio", // Changed title
          style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(
                Icons.description_outlined, // Icon for description
                'Descripción:',
                ordenServicio["descripcion"],
              ),
              _buildDetailRow(
                 estadoServicioIcon, // Dynamic icon for service status
                'Estado del servicio:',
                 estadoServicio,
                 valueColor: estadoServicioColorText // Apply color to the value text
              ),
              _buildDetailRow(
                Icons.calendar_today_outlined, // Icon for date
                'Fecha de ingreso:',
                fechaIngresoFormatted,
              ),
              // Conditionally show oil change dates if they exist
              if (ordenServicio["fechaCambioAceite"] != null)
                 _buildDetailRow(
                   Icons.oil_barrel_outlined, // Icon for oil change date
                   'Fecha cambio de aceite:',
                   fechaCambioAceiteFormatted,
                 ),
              if (ordenServicio["proximoCambioAceite"] != null)
                _buildDetailRow(
                   Icons.access_time_outlined, // Icon for next oil change
                   'Próximo cambio de aceite:',
                   proximoCambioAceiteFormatted,
                 ),
               _buildDetailRow(
                  estadoPagoIcon, // Dynamic icon for payment status
                 'Estado de pago:',
                 estadoPago,
                 valueColor: estadoPagoColorText // Apply color to the value text
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

  // Helper widget for creating detail rows in the dialog
  Widget _buildDetailRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey[600]), // Slightly darker icon
          const SizedBox(width: 10), // Consistent spacing
          Text('$label ', style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
            fontSize: 14,
          )),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.blueGrey[700], // Use provided color or default
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis, // Prevent overflow
              maxLines: 100, // Allow value text to wrap
            ),
          ),
        ],
      ),
    );
  }

  // Mini helper for the vehicle header section (reused from previous refactor)
  Widget _infoRowVehicle(IconData icon, String value) {
      return Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey[500]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      );
    }
 
  
}