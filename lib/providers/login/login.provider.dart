import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginProvider extends ChangeNotifier {

  List<String> optionsDropDownList = ["cliente", "admin"];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> iniciarSesion(email, password, option, context, formkey) async {
    if (formkey.currentState!.validate()) {
      try {

        switch (option) {
          case "cliente":
            
            break;
          
          case "admin":
            Navigator.pushNamed(context, '/registroUsuario');
            break;
        }

        /* UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );

        print(userCredential.user);
        if(userCredential.user != null){

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login exitoso!")),
          );

          Navigator.pushNamed(context, '/vehiculos');
        } */
        

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Usuario o contraseña incorrecto")),
          //SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

 

}

