import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/Clientes/cliente.provider.dart';
import 'package:flutter_application_1/views/RegistroClientes/registroClientes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/views/drawer/drawe.dart';
import 'package:flutter_application_1/views/vehiculos/vehiculo.dart';

class ListaCliente extends StatefulWidget {
  const ListaCliente({super.key});

  @override
  State<ListaCliente> createState() => _ListaClienteState();
}

class _ListaClienteState extends State<ListaCliente> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ClientesProvider>(context, listen: false).cargarClientes();
    });
  }

  // Método para navegar a la vista de vehículos
  void _agregarCarros(BuildContext context, Map<String, dynamic> cliente) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Vehiculo(cliente: cliente), // Pasa el cliente
      ),
    );
  }

  void _mostrarPrevisualizacion(BuildContext context, Map<String, dynamic> cliente) {
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
              _infoDialogRow('Nombres:', cliente["nombres"]),
              _infoDialogRow('Apellidos:', cliente["apellidos"]),
              _infoDialogRow('Email:', cliente["email"]),
              _infoDialogRow('Teléfono:', cliente["telefono"]),
              _infoDialogRow('Rol:', cliente["rol"]),
              if (cliente["direccion"] != null) 
                _infoDialogRow('Dirección:', cliente["direccion"]),
              if (cliente["fechaRegistro"] != null)
                _infoDialogRow('Registro:', cliente["fechaRegistro"]),
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

  Widget _infoDialogRow(String label, String value) {
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

  @override
  Widget build(BuildContext context) {
    final clientesProvider = Provider.of<ClientesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Lista de Clientes',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        elevation: 4,
        shadowColor: Colors.black45,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white, size: 28),
              tooltip: "Abrir menú",
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: clientesProvider.clientes.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: clientesProvider.clientes.length,
                itemBuilder: (context, index) {
                  final cliente = clientesProvider.clientes[index];

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
                          cliente["nombres"][0],
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      title: Text(
                        "${cliente["nombres"]} ${cliente["apellidos"]}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          _infoRow(Icons.email, cliente["email"]),
                          _infoRow(Icons.phone, cliente["telefono"]),
                          _infoRow(Icons.person, "Rol: ${cliente["rol"]}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            iconSize: 22,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(Icons.directions_car, color: Colors.green[800]), // Icono de carro
                            onPressed: () => _agregarCarros(context, cliente), // Navegación a Vehiculo
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_red_eye, color: Colors.blue[700]),
                            onPressed: () => _mostrarPrevisualizacion(context, cliente),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.amber[800]),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegistroClientes(cliente: cliente),
                                ));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
                builder: (context) => const RegistroClientes(cliente: null),
              ),
            );
          },
          backgroundColor: Colors.blueGrey[700],
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: Colors.white),
        ),
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