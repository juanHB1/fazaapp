import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/views/login/login.dart';
import 'package:flutter_application_1/views/vehiculos/listaVehiculos/vehiculo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class LoginProvider extends ChangeNotifier {

  List<String> optionsDropDownList = ["cliente", "admin"];
  bool loading = false;


  Future<void> iniciarSesion(
    TextEditingController email,
    TextEditingController password,
    BuildContext context,
    GlobalKey<FormState> formKey) async {

  if (!formKey.currentState!.validate()) return;

  try {
    loading = true;
    notifyListeners();

    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text.trim(),
      password: password.text.trim(),
    );

    User? user = userCredential.user;

    if (user == null) {
      throw FirebaseAuthException(code: "user-not-found", message: "No se pudo autenticar el usuario.");
    }

    DocumentSnapshot usuarioDoc = await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).get();


      // Obtener token FCM
    String? tokenFCM = await FirebaseMessaging.instance.getToken();

    if (tokenFCM != null) {
      // Guardar token en Firestore para este usuario
      await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).update({
        'tokenNotificacion': tokenFCM,
      });
    }

    if (!usuarioDoc.exists) {
      throw FirebaseAuthException(code: "user-not-found", message: "No se encontraron datos en Firestore.");
    }

    Map<String, dynamic> datosUsuario = usuarioDoc.data() as Map<String, dynamic>;    

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', datosUsuario['uid']);
    await prefs.setString('nombre', datosUsuario['nombre']);
    await prefs.setString('apellido', datosUsuario['apellido']);
    await prefs.setString('email', datosUsuario['email']);
    await prefs.setString('rol', datosUsuario['rol']);
    await prefs.setString('telefono', datosUsuario['telefono']);
    await prefs.setString('password', datosUsuario['password']);


 



    switch (datosUsuario['rol']) {
      case "cliente":
      Future.delayed(Duration(seconds: 1), () {
        formKey.currentState?.reset();
        email.clear();
        password.clear();
        loading = false;
        notifyListeners();
        Navigator.push(context, MaterialPageRoute(builder: (context) => Vehiculo(cliente: datosUsuario,)));
      });
      break;

      case "admin":

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión exitoso. Accediendo a tu cuenta...')),
      );

      Future.delayed(Duration(seconds: 1), () {
        formKey.currentState?.reset();
        email.clear();
        password.clear();
        loading = false;
        notifyListeners();
        Navigator.pushNamed(context, '/home');
      });
      break;
    }

  } on FirebaseAuthException catch (e) {
    loading = false;
    notifyListeners();
    String mensajeError = "Error al iniciar sesión";
switch (e.code) {
  case "user-not-found":
    mensajeError = "No existe una cuenta con este correo";
    break;
  case "wrong-password":
    mensajeError = "Contraseña incorrecta";
    break;
  case "invalid-email":
    mensajeError = "Formato de correo inválido";
    break;
  case "user-disabled":
    mensajeError = "Esta cuenta ha sido deshabilitada";
    break;
  case "too-many-requests":
    mensajeError = "Demasiados intentos fallidos. Intenta más tarde.";
    break;
  default:
    mensajeError = "Usuario o contraseña incorrectos por favor verifica tus datos";
}


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensajeError)),
    );
  }
}

  void cerrarSesion(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    notifyListeners();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Login()),
      (Route<dynamic> route) => false,
    );
  }

  Future<bool> mostrarAlertaCerrarSesion(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Cerrar sesión"),
          content: Text("¿Estás seguro de que quieres cerrar sesión?"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancelar", style: TextStyle(color: Colors.blueGrey[700])),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
                cerrarSesion(context);
              },
              child: Text("Cerrar sesión", style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }
}