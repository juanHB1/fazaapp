import 'package:flutter/material.dart';
// Importa tu ClientesProvider

class ClienteScreen extends StatefulWidget {
  final Map<String, dynamic>? cliente; // Datos del cliente a editar

  const ClienteScreen({super.key, this.cliente});

  @override
  State<ClienteScreen> createState() => _EditarClienteScreenState();
}

class _EditarClienteScreenState extends State<ClienteScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();


  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos actuales del cliente
    _nombreController.text = widget.cliente?['nombres'] ?? '';
    _apellidoController.text = widget.cliente?['apellidos'] ?? '';
  }

  @override
  Widget build(BuildContext context) {

    bool esEdicion = widget.cliente != null;
    
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        elevation: 4,
        shadowColor: Colors.black45,
        title: Text(
          esEdicion ? "Editar Cliente" : "Agregar Cliente",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(Icons.person, size: 60, color: Colors.blueGrey),
                    const SizedBox(height: 10),
                    Text(
                      esEdicion ? "Editar Cliente" : "Agregar Cliente",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(_nombreController, "Nombres", Icons.person),
                    _buildTextField(_apellidoController, "Apellidos", Icons.person_outline),
                    /* _buildTextField(_emailController, "Correo", Icons.email, keyboardType: TextInputType.emailAddress),
                    _buildTextField(_telefonoController, "Teléfono", Icons.phone, keyboardType: TextInputType.phone),
                    _buildTextField(_rolController, "Rol", Icons.work), */
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.blueGrey,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final nuevoCliente = {
                              "nombres": _nombreController.text,
                              "apellidos": _apellidoController.text,
                              /* "email": _emailController.text,
                              "telefono": _telefonoController.text,
                              "rol": _rolController.text, */
                            };
                            Navigator.pop(context, nuevoCliente);
                          }
                        },
                        child: Text(
                          esEdicion ? "Guardar Cambios" : "Agregar Cliente",
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueGrey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        keyboardType: keyboardType,
        validator: (value) => value == null || value.isEmpty ? "Por favor, ingrese $label" : null,
      ),
    );
  }
}