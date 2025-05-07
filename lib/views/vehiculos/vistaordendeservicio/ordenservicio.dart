// Importaciones necesarias
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// Providers
import 'package:flutter_application_1/providers/Vehiculo/vehiculo.provider.dart';
import 'package:flutter_application_1/providers/Vehiculo/orderservicio.provider.dart'; // Assuming this is the correct provider for orders

// Vistas
import 'package:flutter_application_1/views/vehiculos/formularioordenservicio/formularioservicio.dart';
import 'package:flutter_application_1/views/vehiculos/listaVehiculos/vehiculo.dart';
import 'package:flutter_application_1/views/drawer/drawe.dart';

// Pantalla que muestra las órdenes de servicio asociadas a un vehículo
class OrdenesServicio extends StatefulWidget {
  final Map<String, dynamic>? vehiculo;
  final Map<String, dynamic>? cliente;

  const OrdenesServicio({super.key, this.vehiculo, this.cliente});

  @override
  State<OrdenesServicio> createState() => _OrdenesServicioState();
}

class _OrdenesServicioState extends State<OrdenesServicio> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OrdenesServicioProvider>(context, listen: false)
          .obtenerOrdenesServicio(widget.vehiculo?['uid'], widget.cliente!);
      Provider.of<VehiculoProvider>(context, listen: false).loadUserRole();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordenesProvider = Provider.of<OrdenesServicioProvider>(context);
    final vehiculo = widget.vehiculo;
    final vehiculoProvider = Provider.of<VehiculoProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Potentially show a confirmation dialog if needed before popping
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.assignment_turned_in_outlined, color: const Color.fromARGB(255, 255, 0, 0), size: 28), // Icon for service orders
              SizedBox(width: 8),
              Text(
                'Ordenes de servicio',
                style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255), fontSize: 22),
                overflow: TextOverflow.ellipsis, // Handle potential overflow
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          elevation: 4,
          shadowColor: Colors.black45,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            tooltip: "Regresar", // Added tooltip
            onPressed: () {
              // Regresar a la vista de vehículos
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Vehiculo(cliente: widget.cliente!)),
              );
            },
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                tooltip: "Abrir menú",
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ],
        ),
        drawer: CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con datos del vehículo
              Card( // Wrapped vehicle header in a Card for better structure
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                       CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Darker blue-grey for avatar background
                        radius: 35,
                        child: Icon(Icons.car_repair, size: 30, color: const Color.fromARGB(255, 255, 0, 0)), // Vehicle icon in avatar
                      ),
                      const SizedBox(width: 16),
                      Expanded( // Use Expanded to take available space
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow(Icons.directions_car_filled_outlined, "${vehiculo!['marca']} ${vehiculo['modelo']}", ""), // Car icon
                            _infoRow(Icons.badge, vehiculo['placa'] ?? "Placa no disponible",""), // Plate icon
                            _infoRow(Icons.color_lens_outlined, vehiculo['color'] ?? "Color no disponible",""), // Color icon
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Lista de órdenes o mensaje vacío
              Expanded(
                child: ordenesProvider.loading
                    ? const Center(child: CircularProgressIndicator()) // Use CircularProgressIndicator for loading
                    : ordenesProvider.ordenes.isEmpty
                        ? _sinOrdenesUI()
                        : _listaOrdenesUI(ordenesProvider, vehiculo, vehiculoProvider),
              ),
            ],
          ),
        ),
        // Botón para agregar nueva orden (solo si es admin)
        floatingActionButton: vehiculoProvider.rol == 'admin'
            ? FloatingActionButton(
                tooltip: "Agregar nueva orden de servicio",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AgregarOrden(
                        vehiculo: vehiculo,
                        ordenServicio: null,
                        cliente: widget.cliente,
                      ),
                    ),
                  );
                },
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                child: const Icon(Icons.add, color: Colors.white),
              )
            : null,
      ),
    );
  }

  // Muestra las órdenes en tarjetas mejoradas
  Widget _listaOrdenesUI(OrdenesServicioProvider provider, Map<String, dynamic>? vehiculo, VehiculoProvider vehiculoProvider) {
    return ListView.builder(
      itemCount: provider.ordenes.length,
      itemBuilder: (context, index) {
        final orden = provider.ordenes[index];
        final fecha = orden["fecha"] is Timestamp
            ? DateFormat('dd/MM/yyyy').format(orden["fecha"].toDate())
            : 'Sin fecha';

        // Determine status colors and icons
        final estadoServicio = orden["estadoServicio"] ?? 'Desconocido';
        final estadoPago = orden["estadoPago"] ?? 'Desconocido';

        IconData estadoServicioIcon;
        Color estadoServicioColorText;
        Color estadoServicioColorBg;

        if (estadoServicio == 'ingresado') {
          estadoServicioIcon = Icons.playlist_add_check_outlined;
          estadoServicioColorText = Colors.yellow[800]!;
          estadoServicioColorBg = Colors.yellow[100]!;
        } else if (estadoServicio == 'espera') {
          estadoServicioIcon = Icons.hourglass_empty_outlined;
          estadoServicioColorText = Colors.red[800]!;
          estadoServicioColorBg = Colors.red[100]!;
        } else if (estadoServicio == 'finalizado') {
           estadoServicioIcon = Icons.check_circle_outline;
           estadoServicioColorText = Colors.green[800]!;
           estadoServicioColorBg = Colors.green[100]!;
        }
         else { // Default or 'proceso' etc
          estadoServicioIcon = Icons.settings_outlined;
          estadoServicioColorText = Colors.blue[800]!;
          estadoServicioColorBg = Colors.blue[100]!;
        }


        IconData estadoPagoIcon = estadoPago == 'Pagado' ? Icons.payment_outlined : Icons.money_off_csred_outlined;
        Color estadoPagoColorText = estadoPago == 'Pagado' ? Colors.green[800]! : Colors.orange[800]!;
        Color estadoPagoColorBg = estadoPago == 'Pagado' ? Colors.green[100]! : Colors.orange[100]!;


        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row( // Icon and Title
                      children: [
                         Icon(Icons.assignment_outlined, size: 24, color: const Color.fromARGB(255, 255, 0, 0)), // Icon for order title
                         SizedBox(width: 8),
                        Text("Orden de Servicio #${index + 1}",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 0, 0))), // Larger title
                      ],
                    ),
                    Row( // Action buttons
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: "Ver detalles", // Added tooltip
                          icon: Icon(Icons.remove_red_eye, color: Colors.blue[700]),
                          onPressed: () => provider.mostrarPrevisualizacion(context, orden),
                        ),
                        if (vehiculoProvider.rol == 'admin')
                          IconButton(
                            tooltip: "Editar orden", // Added tooltip
                            icon: Icon(Icons.edit, color: Colors.amber[800]),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AgregarOrden(
                                    vehiculo: vehiculo,
                                    ordenServicio: orden,
                                    cliente: widget.cliente,
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 20, thickness: 1, color: Colors.blueGrey), // Separator
                _infoRow(Icons.calendar_today_outlined, "Fecha de ingreso:", fecha), // Date with label
                const SizedBox(height: 8),
                // Use Rows with icons and colored containers for status and payment
                Row(
                  children: [
                    Icon(estadoServicioIcon, size: 20, color: estadoServicioColorText),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      decoration: BoxDecoration(
                        color: estadoServicioColorBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text("Estado del servicio: $estadoServicio",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15, color: estadoServicioColorText)), // Adjusted font size
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                   children: [
                    Icon(estadoPagoIcon, size: 20, color: estadoPagoColorText),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      decoration: BoxDecoration(
                        color: estadoPagoColorBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text("Estado de pago: $estadoPago",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15, color: estadoPagoColorText)), // Adjusted font size
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // UI si no hay órdenes
  Widget _sinOrdenesUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_turned_in_outlined, size: 80, color: const Color.fromARGB(255, 0, 0, 0)),
            const SizedBox(height: 16),
            const Text ("¡Sin órdenes de servicio registradas!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0))),
            const SizedBox(height: 8),
            const Text("Este vehículo aún no tiene órdenes de servicio. Agrega una para comenzar.",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0))),
          ],
        ),
      ),
    );
  }

   // Mini helper para los datos del vehículo y dentro de las tarjetas de orden
  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the top if it wraps
      children: [
        Icon(icon, size: 18, color: const Color.fromARGB(255, 0, 0, 0)),
        const SizedBox(width: 8), // Increased spacing slightly
        Text("$label ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15)), // Label bold
        Expanded( // Use Expanded for the value text
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87, fontSize: 15), // Consistent font size
            overflow: TextOverflow.ellipsis, // Prevent overflow
            maxLines: 2, // Allow text to wrap to two lines
          ),
        ),
      ],
    );
  }
}