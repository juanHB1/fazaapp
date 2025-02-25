import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/clientes/crudclientes.dart';
import 'package:flutter_application_1/views/clientes/clientes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/views/drawer/drawe.dart'; // Importa el Drawer reutilizable


class ListaCliente extends StatefulWidget {
  const ListaCliente({super.key});

  @override
  State<ListaCliente> createState() => _ListaClienteState();
}

class _ListaClienteState extends State<ListaCliente> {
  @override
  Widget build(BuildContext context) {

    final clientesProvider = Provider.of<ClientesProvider>(context);
    clientesProvider.cargarClientes();
    

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
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Abre el Drawer correctamente
                },
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
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.amber[800]),
                        onPressed: () {
                          // Navegar a edición de cliente
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClienteScreen(cliente: cliente),
                            )
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ClienteScreen(cliente: null),
            ),
          ).then((_) => setState(() {})); // Recarga la lista al volver
        },
        backgroundColor: Colors.blueGrey[700],
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Agregar Cliente",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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