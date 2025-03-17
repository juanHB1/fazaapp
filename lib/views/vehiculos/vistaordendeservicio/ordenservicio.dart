import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/Vehiculo/vehiculo.provider.dart';
import 'package:flutter_application_1/views/vehiculos/formularioordenservicio/formularioservicio.dart';
import 'package:flutter_application_1/views/vehiculos/listaVehiculos/vehiculo.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/Vehiculo/orderservicio.provider.dart';
import 'package:flutter_application_1/views/drawer/drawe.dart';

class OrdenesServicio extends StatefulWidget {
  final Map<String, dynamic>? vehiculo; // ✅ Recibir el vehículo completo
  final Map<String, dynamic>? cliente;

  const OrdenesServicio({
    super.key,
    this.vehiculo,
    this.cliente
  });

  @override
  State<OrdenesServicio> createState() => _OrdenesServicioState();
}

class _OrdenesServicioState extends State<OrdenesServicio> {
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OrdenesServicioProvider>(context, listen: false).obtenerOrdenesServicio(widget.vehiculo?['uid'], widget.cliente as Map<String, dynamic>);
      Provider.of<VehiculoProvider>(context, listen: false).loadUserRole();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordenesProvider = Provider.of<OrdenesServicioProvider>(context);
    final vehiculo = widget.vehiculo;
    final vehiculoProvider = Provider.of<VehiculoProvider>(context);

    return PopScope(
        canPop: false, // Bloquea el botón "Atrás"
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
        },
      child: Scaffold(
        backgroundColor: Colors.blueGrey[50],

        appBar: AppBar(
        title: const Text(
          'Ordenes de servicio',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        elevation: 4,
        shadowColor: Colors.black45,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // 🔙 Botón de atrás
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Vehiculo(cliente: widget.cliente as Map<String, dynamic>)
              ),
            );
          },
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 28), // ☰ Menú
                tooltip: "Abrir menú",
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blueGrey[700],
                      radius: 35,
                      child: Icon(Icons.edit_document, size: 30, color: const Color.fromARGB(255, 212, 209, 209)), // Ícono dentro // Imagen del cliente
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.directions_car, color: Colors.blueGrey[700], size: 20),
                        SizedBox(width: 6),
                        Text(
                          "${vehiculo!['marca']} ${vehiculo['modelo']}" ,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.confirmation_number, color: Colors.blueGrey[700], size: 20),
                        SizedBox(width: 6),
                        Text(
                          vehiculo['placa'] ?? "placa",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.color_lens, color: Colors.blueGrey[700], size: 18),
                        SizedBox(width: 6),
                        Text(
                          vehiculo['color'] ?? "Color",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
            child: ordenesProvider.loading ?
            Center(
              child: Text(
                "LOADING...",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                  letterSpacing: 2,
                  fontFamily: 'RobotoMono',
                ),
              ),
            ) :
            ordenesProvider.ordenes.isEmpty
                ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_car_filled_outlined, 
                            size: 80, 
                            color: Colors.blueGrey[400]), // Ícono de auto
                        const SizedBox(height: 16),
                        Text(
                          "¡Sin ordenes de servicio registrados!",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Este vehiculo aún no tiene ordenes de servicio registrados.\nAgrega uno ahora y empieza a gestionarlos fácilmente.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
                        ),
                      ],
                    ),
                  ),
                )
                : ListView.builder(
                    itemCount: ordenesProvider.ordenes.length,
                    itemBuilder: (context, index) {

                      final ordenServicio = ordenesProvider.ordenes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 6,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),

                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Orden de Servicio #${index+1}", // ✅ Título
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Fecha de ingreso: ${ordenServicio["fecha"]}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(
                                    ordenServicio["estado"] == 'ingresado'
                                        ? Icons.playlist_add_check
                                        : ordenServicio["estado"] == 'espera'
                                            ? Icons.hourglass_bottom
                                            : Icons.check_circle,
                                    color: ordenServicio["estado"] == 'ingresado'
                                        ? Colors.yellow[800]
                                        : ordenServicio["estado"] == 'espera'
                                            ? Colors.red[800]
                                            : Colors.blue[800],
                                    size: 24,
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // 📌 Espaciado interno
                                    decoration: BoxDecoration(
                                      color: (ordenServicio["estado"] == 'ingresado'
                                          ? Colors.yellow
                                          : ordenServicio["estado"] == 'espera'
                                              ? Colors.red
                                              : Colors.blue
                                      ).withAlpha(50), // 📌 Fondo con opacidad (valor entre 0 y 255)
                                      borderRadius: BorderRadius.circular(10), // 📌 Bordes redondeados
                                    ),
                                    child: Text(
                                      ordenServicio["estado"],
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
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Nuevo campo: Estado de pago
                              Row(
                                children: [
                                  Icon(
                                    ordenServicio["estadoPago"] == 'Pagado'
                                        ? Icons.check_circle
                                        : Icons.hourglass_bottom,
                                    color: ordenServicio["estadoPago"] == 'Pagado'
                                        ? Colors.green[800]
                                        : Colors.orange[800],
                                    size: 24,
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // 📌 Espaciado interno
                                    decoration: BoxDecoration(
                                      color: (ordenServicio["estadoPago"] == 'Pagado'
                                          ? Colors.green
                                          : Colors.orange
                                      ).withAlpha(50), // 📌 Fondo con opacidad (valor entre 0 y 255)
                                      borderRadius: BorderRadius.circular(10), // 📌 Bordes redondeados
                                    ),
                                    child: Text(
                                      ordenServicio["estadoPago"] ?? "No especificado",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: ordenServicio["estadoPago"] == 'Pagado'
                                            ? Colors.green[800]
                                            : Colors.orange[800], // Mejor visibilidad del texto
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_red_eye, color: Colors.blue[700]),
                                onPressed: () => ordenesProvider.mostrarPrevisualizacion(context, ordenServicio),
                              ),
                               
                               if (vehiculoProvider.rol == 'admin')
                               IconButton( icon: Icon(Icons.edit, color: Colors.amber[800]),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AgregarOrden(
                                        vehiculo: vehiculo,
                                        ordenServicio: ordenServicio,
                                        cliente: widget.cliente,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
      floatingActionButton: vehiculoProvider.rol == 'admin' ? Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            tooltip: "Agregar nueva orde de servicio",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgregarOrden(vehiculo: vehiculo, ordenServicio: null, cliente: widget.cliente ),
                ),
              );
            },
            backgroundColor: Colors.blueGrey[700],
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ): null,
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey[500]),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: Colors.blueGrey[700])),
      ],
    );
  }
}