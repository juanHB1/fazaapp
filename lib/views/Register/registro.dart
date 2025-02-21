import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/providers/Register/registro.provider.dart';
import 'package:provider/provider.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => RegistroState();
}

class RegistroState extends State<Registro> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController _rolController = TextEditingController();

  String? selectedOption; //opcion seleccionada 
  
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    final registroProvider = Provider.of<RegisterProvider>(context);


    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text("Registro de usuarios"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Crea tu cuenta",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Campo de Correo
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Correo",
                          prefixIcon: const Icon(Icons.email, color: Colors.blueAccent),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor, ingresa tu correo";
                          } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(value)) {
                            return "Ingresa un correo válido";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      // Campo de Contraseña
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          prefixIcon: const Icon(Icons.lock, color: Colors.blueAccent),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor, ingresa tu contraseña";
                          } else if (value.length < 6) {
                            return "La contraseña debe tener al menos 6 caracteres";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      // Campo de Nombres
                      TextFormField(
                        controller: nombresController,
                        decoration: InputDecoration(
                          labelText: "Nombres",
                          prefixIcon: const Icon(Icons.person, color: Colors.blueAccent),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor, ingrese su nombre";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      // Campo de Apellidos
                      TextFormField(
                        controller: apellidoController,
                        decoration: InputDecoration(
                          labelText: "Apellidos",
                          prefixIcon: const Icon(Icons.person_outline, color: Colors.blueAccent),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor, ingrese sus apellidos";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      // Campo de Teléfono
                      TextFormField(
                        controller: telefonoController,
                        decoration: InputDecoration(
                          labelText: "Teléfono",
                          prefixIcon: const Icon(Icons.phone, color: Colors.blueAccent),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor, ingrese un número de teléfono";
                          } else if (value.length > 10) {
                            return "El número de teléfono no puede tener más de 10 dígitos";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      // Dropdown para seleccionar el rol
                      DropdownButtonFormField<String>(
                        value: selectedOption,
                        hint: const Text("Seleccione un rol"),
                        onChanged: (newValue) {
                          setState(() {
                            _rolController.text = newValue ?? "";
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Seleccione un rol";
                          }
                          return null;
                        },
                        items: registroProvider.optionsDropDownList.map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Botón de registro
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              registroProvider.registrarUsuario(
                                nombresController,
                                apellidoController,
                                _emailController,
                                telefonoController,
                                _rolController,
                                _passwordController,
                                context,
                                _formKey,
                              );
                              // Aquí iría la función de registrar usuario
                            }
                          },
                          child: const Text(
                            "Registrar",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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
      ),
    );
  }
}