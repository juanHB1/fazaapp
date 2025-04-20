import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/Vehiculo/vehiculo.provider.dart';
import 'package:flutter_application_1/views/listadoclientes/listaclientes.dart';
import 'package:flutter_application_1/views/vehiculos/formularioVehiculo/formularioVehiculo.dart';
import 'package:flutter_application_1/views/vehiculos/vistaordendeservicio/ordenservicio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/views/drawer/drawe.dart';
import 'package:intl/intl.dart';


class Vehiculo extends StatefulWidget {
  final Map<String, dynamic> cliente;
  const Vehiculo({super.key, required this.cliente});

  @override
  State<Vehiculo> createState() => VehiculoState();
}

class VehiculoState extends State<Vehiculo> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<VehiculoProvider>(context, listen: false);
      provider.obtenerVehiculos(widget.cliente["uid"]);
      provider.loadUserRole();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehiculosProvider = Provider.of<VehiculoProvider>(context);
    final cliente = widget.cliente;
    // screenWidth is not strictly needed for responsiveness with flexible widgets

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Potentially show a confirmation dialog before popping if in admin view
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
               Icon(Icons.directions_car_filled_outlined, color: Colors.amber, size: 28), // Icon for vehicles list
               SizedBox(width: 8),
              Text(
                'Lista de vehículos',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white, fontSize: 22),
                 overflow: TextOverflow.ellipsis, // Handle potential overflow
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.blueGrey[900],
          elevation: 4,
          shadowColor: Colors.black45,
          leading: vehiculosProvider.rol == 'admin'
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                   tooltip: "Regresar a lista de clientes", // Added tooltip
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListaCliente()));
                  },
                )
              : const SizedBox.shrink(), // Use SizedBox.shrink for better practice
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                  tooltip: "Abrir menú",
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
          ],
        ),
        drawer: CustomDrawer(),
        bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 108, 112, 114),
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormularioVehiculo(cliente: cliente),
                      
                    ),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Agregar vehículo',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _clienteInfoSection(cliente), // Pass only client
              const SizedBox(height: 20),
              Expanded(
                child: vehiculosProvider.loading
                    ? const Center(child: CircularProgressIndicator()) // Use CircularProgressIndicator for loading
                    : vehiculosProvider.vehiculos.isEmpty
                        ? _sinVehiculosUI(vehiculosProvider)
                        : _listaVehiculosUI(vehiculosProvider, cliente),
              ),
            ],
          ),
        ),
        
      ),
    );
  }

  Widget _clienteInfoSection(Map<String, dynamic> cliente) {
    return Card( // Wrapped client info in a Card
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueGrey[700],
              radius: 30, // Adjusted size slightly
              child: Icon(Icons.person_outline, size: 30, color: Colors.white), // Icon for person
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(Icons.person_outline, "${cliente['nombre']} ${cliente['apellido']}", isBold: true), // Use outline icon
                  _infoRow(Icons.mail_outline, cliente['email'] ?? "email"), // Use outline icon
                  _infoRow(Icons.phone_outlined, cliente['telefono'] ?? "No registrado"), // Use outline icon
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

   // Helper for displaying a row of info with icon and text
   Widget _infoRow(IconData icon, String text, {bool isBold = false}) {
     return Padding(
       padding: const EdgeInsets.only(bottom: 4), // Adjusted padding
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.start, // Align text to top
         children: [
           Icon(icon, size: 18, color: Colors.blueGrey[700]), // Adjusted icon size
           const SizedBox(width: 8), // Consistent spacing
           Expanded(
             child: Text(
               text,
               style: TextStyle(
                 fontSize: 14,
                 fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                 color: isBold ? Colors.black87 : Colors.black54,
               ),
               overflow: TextOverflow.ellipsis, // Prevent overflow
                maxLines: 2, // Allow text to wrap
             ),
           ),
         ],
       ),
     );
   }


  Widget _sinVehiculosUI(VehiculoProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car_outlined, size: 80, color: Colors.blueGrey[400]), // Outline icon for empty state
            const SizedBox(height: 16),
            Text("¡Sin vehículos registrados!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
            const SizedBox(height: 8),
            if (provider.rol == 'admin')
              Text(
                "Este usuario aún no tiene vehículos registrados.\nAgrega uno ahora y empieza a gestionarlos fácilmente.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
              ),
            if (provider.rol == 'cliente') // Message for clients
              Text(
                "Aún no tienes vehículos registrados.\nContacta al administrador para agregar uno.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _listaVehiculosUI(VehiculoProvider provider, Map<String, dynamic> cliente) {
    return ListView.builder(
      itemCount: provider.vehiculos.length,
      itemBuilder: (context, index) {
        final vehiculo = provider.vehiculos[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4), // Adjusted horizontal margin
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 6,
          child: Padding( // Use Padding instead of ListTile for more control
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row( // Header row with avatar and title
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.blueGrey[700],
                       child: Icon(Icons.car_repair, size: 30, color: Colors.white), // Icon instead of letter
                    ),
                    const SizedBox(width: 12), // Adjusted spacing
                    Expanded(
                      child: Text(
                        "${vehiculo["marca"]} ${vehiculo["modelo"]}", // Combine make and model in title
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                        overflow: TextOverflow.ellipsis,
                         maxLines: 1,
                      ),
                    ),
                  ],
                ),
                 const Divider(height: 20, thickness: 1, color: Colors.blueGrey), // Separator
                // Vehicle details rows
                _infoRow(Icons.badge, "Placa: ${vehiculo["placa"] ?? 'Sin placa'}"),
                _infoRow(Icons.color_lens_outlined, "Color: ${vehiculo["color"] ?? 'Sin color'}"),
                 _infoRow(Icons.speed_outlined, "Kilometraje de entrada: ${vehiculo["kilometrajeEntrada"] ?? 'Sin kilometraje'}"), // Corrected label
                 _infoRow(Icons.local_gas_station_outlined, "Combustible: ${vehiculo["tipoCombustible"] ?? 'Sin información'}"), // Icon for fuel type
                 //_infoRow(Icons.vpn_key_outlined, "Chasis: ${vehiculo["numeroChasis"] ?? 'Sin número'}"), // Icon for chassis

                const SizedBox(height: 10),
                Align( // Align buttons to the right
                   alignment: Alignment.bottomRight,
                   child: Wrap( // Use Wrap for buttons
                     spacing: 8, // Spacing between buttons
                     runSpacing: 4, // Spacing between rows of buttons if they wrap
                     children: [
                       IconButton(
                         tooltip: "Ver órdenes de servicio", // Added tooltip
                         icon: Icon(Icons.list_alt_outlined, color: Colors.green[700]), // Outline icon
                         onPressed: () {
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => OrdenesServicio(vehiculo: vehiculo, cliente: cliente),
                             ),
                           );
                         },
                       ),
                       IconButton(
                         tooltip: "Ver detalles", // Added tooltip
                         icon: Icon(Icons.remove_red_eye_outlined, color: Colors.blue[700]), // Outline icon
                         onPressed: () => _mostrarDetallesVehiculo(context, vehiculo),
                       ),
                       if (provider.rol == 'admin')
                         IconButton(
                           tooltip: "Editar vehículo", // Added tooltip
                           icon: Icon(Icons.edit_outlined, color: Colors.amber[800]), // Outline icon
                           onPressed: () {
                             Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context) => FormularioVehiculo(cliente: cliente, vehiculo: vehiculo),
                               ),
                             );
                           },
                         ),
                     ],
                   ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

   // Helper for creating detail rows in the vehicle details dialog
  Widget _buildDialogDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey[600]),
          const SizedBox(width: 10),
          Text('$label: ', style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
            fontSize: 14,
          )),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.blueGrey[700], fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }


  void _mostrarDetallesVehiculo(BuildContext context, Map<String, dynamic> vehiculo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Detalles del Vehículo", textAlign: TextAlign.center),
          content: SingleChildScrollView( // Added SingleChildScrollView for content
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogDetailRow(Icons.directions_car_outlined, "Marca", vehiculo["marca"] ?? 'Sin información'),
                _buildDialogDetailRow(Icons.model_training_outlined, "Modelo", vehiculo["modelo"] ?? 'Sin información'), // Icon for model
                _buildDialogDetailRow(Icons.badge, "Placa", vehiculo["placa"] ?? 'Sin placa'),
                _buildDialogDetailRow(Icons.color_lens_outlined, "Color", vehiculo["color"] ?? 'Sin color'),
                _buildDialogDetailRow(Icons.speed_outlined, "Kilometraje de entrada",  vehiculo["kilometrajeEntrada"] ?? 'Sin kilometraje'),
                _buildDialogDetailRow(Icons.local_gas_station_outlined, "Tipo de Combustible", vehiculo["tipoCombustible"] ?? 'Sin información'),
                //_buildDialogDetailRow(Icons.vpn_key_outlined, "Número de Chasis", vehiculo["numeroChasis"] ?? 'Sin número'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

}