import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/notificacionCambioAceiteProximo/notificacionCambioAceiteProximoProvider.dart';
import 'package:url_launcher/url_launcher.dart'; // 👈 Importante

class NotificacionCambioAceiteProximo extends StatefulWidget {
  const NotificacionCambioAceiteProximo({super.key});

  @override
  State<NotificacionCambioAceiteProximo> createState() => _NotificacionCambioAceiteProximoState();
}

class _NotificacionCambioAceiteProximoState extends State<NotificacionCambioAceiteProximo> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NotificacionCambioAceiteProximoProvider>(context, listen: false).obtenerOrdenesProximas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificacionCambioAceiteProximoProvider>(context);
    final ordenes = provider.ordenesProximas;
    final estaCargando = provider.cargando;

    return Scaffold( 
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Consistent AppBar color
        elevation: 4,
        shadowColor: Colors.black45,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.access_time_outlined, color: const Color.fromARGB(255, 255, 7, 7), size: 28), // Icon for notifications
            SizedBox(width: 8),
            Text(
              "Próximos cambios de aceite",
              style: TextStyle(
                fontSize: 18, // Slightly smaller font for longer title
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
                letterSpacing: 1.2,
              ),
               overflow: TextOverflow.ellipsis, // Handle potential overflow
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: estaCargando
          ? const Center(child: CircularProgressIndicator())
          : ordenes.isEmpty
              ? const Center(child: Text("No hay órdenes próximas a cambio de aceite")) // More descriptive empty state
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: ordenes.length,
                  itemBuilder: (context, index) {
                    final orden = ordenes[index];
                    final nombre = orden['nombreUsuario'] ?? '';
                    final apellido = orden['apellidoUsuario'] ?? '';
                    final telefono = orden['telefonoUsuario'] ?? '';
                    final placa = orden['vehiculoPlaca'] ?? 'Sin placa';
                    final dataOrden = orden['data'] ?? {};
                    final proximoCambioAceite = dataOrden['proximoCambioAceite'] != null
                        ? (dataOrden['proximoCambioAceite'] as Timestamp).toDate()
                        : null;
                    final vehiculoNombre = orden['vehiculoNombre'] ?? 'Sin nombre';
                    final vehiculoModelo = orden['vehiculoModelo'] ?? 'Sin modelo';
                    final vehiculoKilometrajeActual = orden['vehiculoKilometrajeActual'] ?? 'Sin kilometraje';

                    // Format date
                    final formattedDate = proximoCambioAceite != null
                        ? "${proximoCambioAceite.day}/${proximoCambioAceite.month}/${proximoCambioAceite.year}"
                        : 'Fecha no disponible';

                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row( // Icon and Name
                              children: [
                                Icon(Icons.person_outline, color: const Color.fromARGB(255, 0, 0, 0)),
                                SizedBox(width: 8),
                                Expanded( // Use Expanded to prevent overflow
                                  child: Text(
                                    "$nombre $apellido",
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row( // Icon and Phone
                              children: [
                                Icon(Icons.phone_outlined, color: const Color.fromARGB(255, 0, 0, 0)),
                                SizedBox(width: 8),
                                Text("Teléfono: $telefono"),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row( // Icon and Plate
                              children: [
                                Icon(Icons.credit_card, color: const Color.fromARGB(255, 0, 0, 0)), // Using credit card icon for plate number
                                SizedBox(width: 8),
                                Text("Placa: $placa", style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row( // Icon and Vehicle Info
                              children: [
                                Icon(Icons.directions_car_outlined, color: const Color.fromARGB(255, 0, 0, 0)),
                                SizedBox(width: 8),
                                Expanded( // Use Expanded to prevent overflow
                                  child: Text("Vehículo: $vehiculoNombre $vehiculoModelo"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                             Row( // Icon and Mileage
                              children: [
                                Icon(Icons.speed_outlined, color: const Color.fromARGB(255, 0, 0, 0)),
                                SizedBox(width: 8),
                                Text("Kilometraje actual: $vehiculoKilometrajeActual"),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row( // Icon and Next Oil Change Date
                              children: [
                                Icon(Icons.oil_barrel, color: Colors.redAccent), // Red icon for importance
                                SizedBox(width: 8),
                                Text(
                                  "Próximo cambio de aceite: $formattedDate",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Align( // Align button to the right or center as desired
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final mensaje = Uri.encodeComponent(
                                    "Hola $nombre, le recordamos que su vehículo con placa $placa tiene un cambio de aceite programado próximamente para la fecha $formattedDate. Por favor acérquese al taller FAZA INGENIERIA.",
                                  );
                                  final numero = telefono.replaceAll(RegExp(r'\D'), '');
                                  final url = Uri.parse("https://wa.me/57$numero?text=$mensaje"); // Assuming country code 57 for Colombia
                                  launchUrl(url, mode: LaunchMode.externalApplication);
                                },
                                icon: const Icon(Icons.notifications, color: Colors.white, size: 30), // WhatsApp icon
                                label: const Text("Notificar WhatsApp", style: TextStyle(color: Colors.white)), // White text for better contrast
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF25D366), // WhatsApp green color
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Added padding
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}