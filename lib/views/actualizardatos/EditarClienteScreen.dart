import 'package:flutter/material.dart';
// Importa tu ClientesProvider

class EditarClienteScreen extends StatefulWidget {
  final Map<String, dynamic> cliente; // Datos del cliente a editar

  const EditarClienteScreen({super.key, required this.cliente});

  @override
  State<EditarClienteScreen> createState() => _EditarClienteScreenState();
}

class _EditarClienteScreenState extends State<EditarClienteScreen> {

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();


  @override
  void initState() {
    super.initState();
    print(widget.cliente);
    // Inicializa los controladores con los datos actuales del cliente
    _nombreController.text = widget.cliente['nombres'] ?? '';
    _apellidoController.text = widget.cliente['apellidos'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text('Editar Cliente')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _apellidoController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("Hola");
                // Recoge los nuevos datos del formulario
                /* Map<String, dynamic> nuevosDatos = {
                  'nombre': _nombreController.text,
                  'apellido': _apellidoController.text,
                }; */

                /* try {
                  // Llama al método actualizarCliente
                  await Provider.of<ClientesProvider>(context, listen: false)
                      .actualizarCliente(widget.cliente['id'], nuevosDatos);
                  Navigator.pop(context); // Regresa a la pantalla anterior
                } catch (e) {
                  // Muestra un mensaje de error si falla
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('No se pudo guardar los cambios.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } */
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    super.dispose();
  }
}