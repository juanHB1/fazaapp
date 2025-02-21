import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/login/login.provider.dart';
import 'package:provider/provider.dart';


class Login extends StatefulWidget {
  
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectedOption; //opcion seleccionada  
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    final loginProvider = Provider.of<LoginProvider>(context);


    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Fondo suave
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
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
                      Icon(Icons.lock, size: 60, color: Colors.blueGrey),
                      SizedBox(height: 10),
                      Text(
                        "Bienvenido",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                      SizedBox(height: 20),

                      // Dropdown para tipo de usuario
                      DropdownButtonFormField<String>(
                        value: selectedOption,
                        hint: Text("Seleccione su rol"),
                        onChanged: (newValue) {
                          setState(() {
                            selectedOption = newValue;
                          });
                        },
                        validator: (value) => value == null ? "Seleccione un rol" : null,
                        items: loginProvider.optionsDropDownList.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),

                      SizedBox(height: 15),

                      // Campo de correo
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Correo",
                          prefixIcon: Icon(Icons.email),
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

                      SizedBox(height: 15),

                      // Campo de contraseña
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor, ingresa tu contraseña";
                          } else if (value.length < 6) {
                            return "Debe tener al menos 6 caracteres";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 20),

                      // Botón de inicio de sesión
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Lógica de inicio de sesión
                              loginProvider.iniciarSesion(_emailController, _passwordController, selectedOption, context, _formKey);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.blueGrey,
                          ),
                          child: Text("Iniciar Sesión", style: TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),

                      SizedBox(height: 15),

                      // Mensaje informativo sobre la creación de cuenta
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Estimado usuario, su cuenta será creada y gestionada por el administrador de la aplicación. "
                          "Una vez registrada, recibirá las credenciales de acceso correspondientes.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
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