import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/Register/registro.provider.dart';
import 'package:flutter_application_1/providers/Vehiculo/vehiculo.provider.dart';
import 'package:flutter_application_1/providers/login/login.provider.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    super.initState();
    
    // Lógica para cargar datos solo una vez
    Future.microtask(() {
      final registroProvider = Provider.of<RegisterProvider>(context, listen: false);
      final vehiculoProvider = Provider.of<VehiculoProvider>(context, listen: false);

      vehiculoProvider.loadUserRole();
      registroProvider.obtenerCredencialNombre("nombre");
      registroProvider.obtenerCredencialApellido("apellido");
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final registroProvider = Provider.of<RegisterProvider>(context);
    final vehiculoProvider = Provider.of<VehiculoProvider>(context);

    return Drawer(
      child: Column(
        children: [
          // Encabezado del Drawer
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey[900]),
            child: Row(
              children: [
                const Icon(Icons.person, size: 50, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${registroProvider.credencialNombre} ${registroProvider.credencialApellido}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Menú según el rol
          if (vehiculoProvider.rol == 'admin') ...[
            _buildDrawerItem(
              icon: Icons.home,
              text: "Clientes",
              onTap: () {
                Navigator.pushReplacementNamed(context, '/clientes');
              },
            ),
            _buildDrawerItem(
              icon: Icons.oil_barrel_outlined,
              text: "Próximos cambios de aceite",
              onTap: () {
                Navigator.pushReplacementNamed(context, '/notificacionCambioAceiteProximo');
              },
            ),
          ],

          const Divider(),

          _buildDrawerItem(
            icon: Icons.exit_to_app,
            text: "Cerrar Sesión",
            onTap: () {
              loginProvider.cerrarSesion(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.blueGrey[900]),
      ),
      onTap: onTap,
    );
  }
}
