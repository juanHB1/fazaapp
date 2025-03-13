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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Puedes cambiar esto si necesitas manejar la navegación
        selectedItemColor: Colors.blueGrey[800],
        unselectedItemColor: Colors.blueGrey[400],
        onTap: (index) {
          if (index == 1) {
            // Navegar a la pantalla de registro de clientes
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegistroClientes(cliente: null),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'teléfono',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 30, color: Colors.green),
            label: 'Agregar Cliente',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger_sharp),
            label: 'whatsapp',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: clientesProvider.clientes.isEmpty
            ? 
            Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.person, 
                            size: 80, 
                            color: Colors.blueGrey[400]), // Ícono de auto
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
                                  cliente["nombres"][0],
                                  style: const TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "${cliente["nombres"]} ${cliente["apellidos"]}",
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                  overflow: TextOverflow.ellipsis, // Evita desbordamiento
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _infoRow(Icons.email, cliente["email"]),
                          _infoRow(Icons.phone, cliente["telefono"]),
                          _infoRow(Icons.person, "Rol: ${cliente["rol"]}"),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                iconSize: 22,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: Icon(Icons.directions_car, color: Colors.green[800]),
                                onPressed: () => clientesProvider.agregarCarros(context, cliente),
                              ),
                              IconButton(
                                icon: Icon(Icons.remove_red_eye, color: Colors.blue[700]),
                                onPressed: () => clientesProvider.mostrarPrevisualizacion(context, cliente),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.amber[800]),
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
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blueGrey[500]),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: Colors.blueGrey[700])),
      ],
    );
  }
}