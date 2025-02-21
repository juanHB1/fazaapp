import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RegisterProvider extends ChangeNotifier {

  List<String> optionsDropDownList = ["cliente", "admin"];



  Future<void> registrarUsuario(nombres, apellidos, email, tel, rol, password, context, formkey) async {
    if (formkey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );

        // Obtener ID del usuario
        String uid = userCredential.user!.uid;

        // Crear documento en la colección "usuarios"
        await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
          'nombre': nombres.text,
          'apellido': apellidos.text,
          'email': email.text,
          'telefono': tel.text,
          'uid': uid,
          'rol': rol.text,
          'password':password.text
        });
        
        formkey.currentState?.reset();
        nombres.clear();
        apellidos.clear();
        email.clear();
        tel.clear();
        rol.clear();
        password.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado con éxito')),
        );
        

      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }


}