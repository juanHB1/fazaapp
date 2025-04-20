import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/Clientes/cliente.provider.dart';
import 'package:flutter_application_1/views/RegistroClientes/registroClientes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/views/drawer/drawe.dart';

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

  @override
  Widget build(BuildContext context) {
    final clientesProvider = Provider.of<ClientesProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        elevation: 4,
        shadowColor: Colors.black45,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_alt_outlined, color: Colors.amber, size: 28),
            SizedBox(width: 8),
            Text(
              'Lista de Clientes',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        centerTitle: true,
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
                      builder: (context) => const RegistroClientes(cliente: null),
                    ),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Agregar Cliente',
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
        padding: const EdgeInsets.all(10),
        child: clientesProvider.clientes.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off_outlined,
                          size: 80,
                          color: Colors.blueGrey[400]),
                      const SizedBox(height: 16),
                      Text(
                        "¡Sin Usuarios registrados!",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Aún no tienes usuarios registrados.\nAgrega uno ahora y empieza a gestionarlos fácilmente.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                itemCount: clientesProvider.clientes.length,
                itemBuilder: (context, index) {
                  final cliente = clientesProvider.clientes[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.blueGrey[700],
                                child: Text(
                                  cliente["nombre"][0].toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "${cliente["nombre"]} ${cliente["apellido"]}",
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _infoRow(Icons.email_outlined, cliente["email"]),
                          _infoRow(Icons.phone_outlined, cliente["telefono"]),
                          _infoRow(Icons.assignment_ind_outlined, "Rol: ${cliente["rol"]}"),
                          const SizedBox(height: 10),
                          Align( // Align buttons to the right
                            alignment: Alignment.bottomRight,
                            child: Wrap( // Use Wrap for better responsiveness of buttons
                              spacing: 8, // Horizontal spacing between buttons
                              runSpacing: 4, // Vertical spacing if buttons wrap
                              children: [
                                IconButton(
                                  tooltip: "Llamar",
                                  icon: Icon(Icons.phone_outlined, color: Colors.black), // Outline icon for consistency
                                  onPressed: (){
                                    clientesProvider.hacerLlamada(cliente["telefono"], context);
                                  }
                                ),
                                IconButton(
                                  tooltip: "Ver vehículos",
                                  iconSize: 22,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(Icons.directions_car_outlined, color: Colors.green[800]), // Outline icon
                                  onPressed: () => clientesProvider.agregarCarros(context, cliente),
                                ),
                                IconButton(
                                  tooltip: "Previsualizar",
                                  icon: Icon(Icons.remove_red_eye_outlined, color: Colors.blue[700]), // Outline icon
                                  onPressed: () => clientesProvider.mostrarPrevisualizacion(context, cliente),
                                ),
                                IconButton(
                                  tooltip: "Editar",
                                  icon: Icon(Icons.edit_outlined, color: Colors.amber[800]), // Outline icon
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegistroClientes(cliente: cliente),
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
              ),
      ),
    );
  }

  // Helper for displaying a row of info with icon and text
  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4), // Adjusted padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to top
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey[500]),
          const SizedBox(width: 8), // Consistent spacing
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.blueGrey[700], fontSize: 14), // Consistent font size
              overflow: TextOverflow.ellipsis,
              maxLines: 2, // Allow text to wrap
            ),
          ),
        ],
      ),
    );
  }
}