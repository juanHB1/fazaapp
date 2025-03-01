import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/Register/registro.provider.dart';
import 'package:flutter_application_1/providers/login/login.provider.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final registroProvider = Provider.of<RegisterProvider>(context, listen: true);
    registroProvider.obtenerCredencialNombre("nombre");
    registroProvider.obtenerCredencialApellido("apellido");


    return Drawer(
      child: Column(
        children: [
          // Encabezado del Drawer
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey[900],
            ),
            child: Row(
              children: [
                Icon(Icons.person, size: 50, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${registroProvider.credencialNombre} ${registroProvider.credencialApellido}",
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Opciones del menú
          _buildDrawerItem(
            icon: Icons.home,
            text: "Clientes",
            onTap: () {
              Navigator.pushReplacementNamed(context, '/clientes');
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: "Configuración",
            onTap: () {
              return ;
            },
          ),

          // Separador
          Divider(),

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

  // Método para construir elementos del Drawer
  Widget _buildDrawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(text, style: TextStyle(fontSize: 16, color: Colors.blueGrey[900])),
      onTap: onTap,
    );
  }
}
