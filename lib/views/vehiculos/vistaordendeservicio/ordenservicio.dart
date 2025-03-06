import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/vehiculos/formularioordenservicio/formularioservicio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/Vehiculo/orderservicio.provider.dart';

class OrdenesServicio extends StatefulWidget {
  final String idVehiculo;
  final Map<String, dynamic> vehiculo; // ✅ Recibir el vehículo completo

  const OrdenesServicio({
    super.key,
    required this.idVehiculo,
    required this.vehiculo,
  });

  @override
  State<OrdenesServicio> createState() => _OrdenesServicioState();
}

class _OrdenesServicioState extends State<OrdenesServicio> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OrdenesServicioProvider>(context, listen: false)
          .obtenerOrdenesServicio(widget.idVehiculo);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordenesProvider = Provider.of<OrdenesServicioProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Órdenes de Servicio'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 155, 150, 150),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 **Aquí mostramos la información del vehículo**
            Card(
              margin: const EdgeInsets.all(8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🚗 Vehículo",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text("Marca: ${widget.vehiculo['marca']}"),
                    Text("Modelo: ${widget.vehiculo['modelo']}"),
                    Text("Placa: ${widget.vehiculo['placa']}"),
                    Text("Color: ${widget.vehiculo['color']}"),
                    Text("Kilometraje: ${widget.vehiculo['kilometrajeEntrada']}"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),
            Text(
              "📋 Órdenes de Servicio",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            /// 🔹 **Aquí va la lista de órdenes de servicio**
            Expanded(
              child: ordenesProvider.loading
                  ? Center(child: CircularProgressIndicator())
                  : ordenesProvider.ordenes.isEmpty
                      ? Center(child: Text("No hay órdenes registradas."))
                      : ListView.builder(
                          itemCount: ordenesProvider.ordenes.length,
                          itemBuilder: (context, index) {
                            final orden = ordenesProvider.ordenes[index];

                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              child: ListTile(
                                title: Text(
                                  "Orden #${orden["id"]}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text("Fecha: ${orden["fecha"]}"),
                                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueGrey),
                                onTap: () {
                                  // Lógica para abrir detalles de la orden
                                },
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
                builder: (context) => AgregarOrden(vehiculo:  widget.vehiculo),
              ),
            );
          },
          backgroundColor: Colors.blueGrey[700],
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
    //Boton Flotante para agregar una nueva orden de servicio
    




  }
}
