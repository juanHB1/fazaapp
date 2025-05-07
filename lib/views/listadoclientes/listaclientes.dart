import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/Clientes/cliente.provider.dart';
import 'package:flutter_application_1/views/RegistroClientes/registroClientes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/views/drawer/drawe.dart';
import 'package:url_launcher/url_launcher.dart';

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
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 4,
        shadowColor: Colors.black45,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_alt_outlined, color: const Color.fromARGB(255, 255, 7, 7), size: 28),
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
        color: const Color.fromARGB(255, 17, 17, 17),
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
                icon: const Icon(Icons.add, color: Color.fromARGB(255, 0, 0, 0)),
                label: const Text('Agregar Cliente',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 238, 0, 0),
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
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    shadowColor: Colors.grey.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
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
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${cliente["nombre"]} ${cliente["apellido"]}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    _infoRow(Icons.email_outlined, cliente["email"]),
                                    _infoRow(Icons.phone_outlined, cliente["telefono"]),
                                    _infoRow(Icons.assignment_ind_outlined, "Rol: ${cliente["rol"]}"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24, thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _actionIcon(context, Icons.phone_outlined, "Llamar", const Color.fromARGB(255, 0, 0, 0), () {
                                clientesProvider.hacerLlamada(cliente["telefono"], context);
                              }),
                              _actionIcon(context, Icons.directions_car_outlined, "Vehículos", const Color.fromARGB(255, 255, 0, 0), () {
                                clientesProvider.agregarCarros(context, cliente);
                              }),
                              _actionIcon(context, Icons.remove_red_eye_outlined, "Ver", const Color.fromARGB(255, 0, 0, 0), () {
                                clientesProvider.mostrarPrevisualizacion(context, cliente);
                              }),
                              _actionIcon(context, Icons.edit_outlined, "Editar", const Color.fromARGB(255, 255, 0, 0), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegistroClientes(cliente: cliente),
                                  ),
                                );
                              }),
                              _actionIcon(context, Icons.message_sharp, "WhatsApp", const Color.fromARGB(255, 73, 255, 1), () {
                                final phoneNumber = cliente["telefono"];
                                if (phoneNumber.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("El cliente no tiene un número de teléfono registrado.")),
                                  );
                                  return;
                                }
                                final message = Uri.encodeComponent(
                                    "Hola ${cliente['nombre']} ${cliente['apellido']}, Te escribimos desde Faza Ingenieria.");
                                final url = "https://wa.me/$phoneNumber?text=$message";
                                launchUrl(Uri.parse(url));
                              }),
                            ],
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

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey[500]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.blueGrey[700], fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionIcon(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
