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
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    final registroProvider = Provider.of<RegisterProvider>(context);


    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Correo"),
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
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Contraseña"),
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
              TextFormField(
                controller: nombresController,
                decoration: const InputDecoration(labelText: "Nombres"),
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese su nombre";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: apellidoController,
                decoration: const InputDecoration(labelText: "Apellidos completos"),
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese sus apellidos";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: telefonoController,
                decoration: const InputDecoration(labelText: "Teléfono"),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese un numero de teléfono";
                  }
                  else if (value.length > 10) {
                    return "El número de teléfono no puede tener más de 10 dígitos";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (){
                  registroProvider.registrarUsuario(
                    _emailController, 
                    _passwordController, 
                    nombresController,
                    apellidoController,
                    telefonoController,
                    context, 
                    _formKey);
                    
                },
                child: const Text("Registrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}