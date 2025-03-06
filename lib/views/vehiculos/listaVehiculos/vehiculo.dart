import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/Vehiculo/vehiculo.provider.dart';
import 'package:flutter_application_1/views/vehiculos/formularioVehiculo/formularioVehiculo.dart';
import 'package:flutter_application_1/views/vehiculos/vistaordendeservicio/ordenservicio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/views/drawer/drawe.dart';

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
      Provider.of<VehiculoProvider>(context, listen: false).obtenerVehiculos(widget.cliente["id"]);
    });
  }


  @override
  Widget build(BuildContext context) {
    final vehiculosProvider = Provider.of<VehiculoProvider>(context);
    final cliente = widget.cliente;

    return PopScope(
        canPop: false, // Bloquea el botón "Atrás"
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
        },
      child: Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Lista de vehículos',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        elevation: 4,
        shadowColor: Colors.black45,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // 🔙 Botón de atrás
          onPressed: () {
            Navigator.pop(context);
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
                      child: Icon(Icons.person, size: 30, color: const Color.fromARGB(255, 212, 209, 209)), // Ícono dentro // Imagen del cliente
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.blueGrey[700], size: 20),
                        SizedBox(width: 6),
                        Text(
                          "${cliente['nombres']} ${cliente['apellidos']}" ,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.mail, color: Colors.blueGrey[700], size: 20),
                        SizedBox(width: 6),
                        Text(
                          cliente['email'] ?? "email",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.blueGrey[700], size: 18),
                        SizedBox(width: 6),
                        Text(
                          cliente['telefono'] ?? "No registrado",
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
            child: vehiculosProvider.loading ? 
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
            vehiculosProvider.vehiculos.isEmpty
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
                          "¡Sin vehículos registrados!",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Este usuario aún no tiene vehículos registrados.\nAgrega uno ahora y empieza a gestionarlos fácilmente.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
                        ),
                      ],
                    ),
                  ),
                )
                : ListView.builder(
                    itemCount: vehiculosProvider.vehiculos.length,
                    itemBuilder: (context, index) {
                      final vehiculo = vehiculosProvider.vehiculos[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 6,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.blueGrey[700],
                            child: Text(
                              vehiculo["marca"][0],
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          title: Text(
                            "${vehiculo["marca"]}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              _infoRow(Icons.car_rental, vehiculo["modelo"]),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //envia a la vista del listado orden de servicio
                              IconButton(
                                icon: Icon(Icons.list_alt, color: Colors.green[700]),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                     builder: (context) => OrdenesServicio(
                                        vehiculo: vehiculo, 
                                        clienteId: widget.cliente["id"]
                                    ),
                                  )
                                  
                                  );
                                  
                                },
                              ),

                              IconButton(
                                icon: Icon(Icons.remove_red_eye, color: Colors.blue[700]),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Detalles del Vehículo", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Text("Marca: ${vehiculo["marca"]}"),
                                                Text("Modelo: ${vehiculo["modelo"]}"),
                                                Text("Placa: ${vehiculo["placa"]}"),
                                                Text("Color: ${vehiculo["color"]}"),
                                                Text("Kilometraje: ${vehiculo["kilometrajeEntrada"]}"),
                                                Text("Tipo de Combustible: ${vehiculo["tipoCombustible"]}"),
                                                Text("Número de Chasis: ${vehiculo["numeroChasis"]}"), // Añadir año
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text("Cerrar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },

                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.amber[800]),
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
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          tooltip: "Agregar nuevo cliente",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormularioVehiculo(cliente: cliente, vehiculo: null,),
              ),
            );
          },
          backgroundColor: Colors.blueGrey[700],
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    )
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
