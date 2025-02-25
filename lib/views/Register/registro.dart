import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/providers/Register/registro.provider.dart';
import 'package:flutter_application_1/providers/login/login.provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/views/drawer/drawe.dart'; // Importa el Drawer reutilizable

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

    final registroProvider = Provider.of<RegisterProvider>(context, listen: true);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        //barra de navegacion superior
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey[900], // Color oscuro elegante
          elevation: 4,
          shadowColor: Colors.black45,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.car_repair, color: Colors.amber, size: 28), // Ícono llamativo
              SizedBox(width: 8),
              //texto con el nombre de la empresa e icono
              Text(
                "Faza Ingeniería", 
                style: TextStyle(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.white,
                  letterSpacing: 1.2, // Espaciado para mejor estética
                ),
              ),
            ],
          ),
          centerTitle: true,
          //icono para abrir el drawer( panel izquierdo )
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
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
      
                // 🔹 Mensaje de Bienvenida
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    children: [
                      Icon(Icons.waving_hand, size: 40, color: Colors.amber), // Icono llamativo
                      SizedBox(height: 8),
                      Text(
                        "Bienvenido a nuestra plataforma. Esperamos que tengas una excelente experiencia 🎉",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
      
                  const SizedBox(height: 20),
      
                  // Tarjeta con el formulario
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icono y título
                            Icon(Icons.person, size: 60, color: Colors.blueGrey),
                            const SizedBox(height: 10),
                            const Text(
                              "Crea tu cuenta",
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                            ),
                            const SizedBox(height: 20),
                  
                            // Campo de Nombres
                            TextFormField(
                              controller: nombresController,
                              decoration: InputDecoration(
                                labelText: "Nombres",
                                prefixIcon: Icon(Icons.person, color: Colors.blueGrey),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Por favor, ingresa tu correo";
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
                                prefixIcon: Icon(Icons.person_outline, color: Colors.blueGrey),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Por favor, ingrese sus apellidos";
                                }
                                return null;
                              },
                            ),
                  
                            const SizedBox(height: 10),
                  
                            // Campo de Correo
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: "Correo",
                                prefixIcon: Icon(Icons.email, color: Colors.blueGrey),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                  
                            // Campo de Teléfono
                           TextFormField(
                              controller: telefonoController,
                              decoration: InputDecoration(
                                labelText: "Teléfono",
                                prefixIcon: Icon(Icons.phone, color: Colors.blueGrey),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                  
                            // Campo de Contraseña
                           TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: "Contraseña",
                                prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
                  
                            // Dropdown para seleccionar el rol
                            DropdownButtonFormField<String>(
                              value: selectedOption,
                              hint: const Text("Seleccione un rol"),
                              onChanged: (newValue) {
                                setState(() {
                                  _rolController.text = newValue ?? "";
                                });
                              },
                              validator: (value) => value == null || value.isEmpty ? "Seleccione un rol" : null,
                              items: registroProvider.optionsDropDownList.map((String role) {
                                return DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              ),
                            ),
                  
                            const SizedBox(height: 20),
                  
                            // Botón de registro
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
                                  }
                                },
                                child: const Text("Registrar", style: TextStyle(fontSize: 18, color: Colors.white)),
                              ),
                            ),
                  
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  }
}