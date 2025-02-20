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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    final loginProvider = Provider.of<LoginProvider>(context);


    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Correo"),
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
                decoration: InputDecoration(labelText: "Contraseña"),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (){
                  loginProvider.iniciarSesion(_emailController, _passwordController, context, _formKey);
                }, 
                child: Text("Iniciar Sesión"),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/registroUsuario');
                },
                child: Text("Registrarse"),
              ),
            ],
          ),
        ),
      ),
    );
    
  }
}