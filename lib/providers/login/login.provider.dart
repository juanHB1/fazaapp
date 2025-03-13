import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/views/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginProvider extends ChangeNotifier {

  List<String> optionsDropDownList = ["cliente", "admin"];
  bool loading = false;
  
  /// Método para iniciar sesión en la aplicación.
  ///
  /// Parámetros:
  /// - `email`: Controlador de texto que contiene el correo ingresado por el usuario.
  /// - `password`: Controlador de texto que contiene la contraseña ingresada.
  /// - `rol`: Controlador de texto que indica el rol del usuario (ejemplo: "cliente" o "admin").
  /// - `context`: Contexto de la aplicación, necesario para navegación y mostrar mensajes.
  /// - `formkey`: Llave del formulario para validar los campos antes de proceder.
  ///
  /// Funcionamiento:
  /// - Verifica si los campos del formulario son válidos.
  /// - Dependiendo del rol ingresado, ejecuta diferentes acciones:
  ///   - Si el rol es "cliente", actualmente solo imprime un mensaje en la consola.
  ///   - Si el rol es "admin":
  ///     1. Autentica al usuario con Firebase Authentication.
  ///     2. Obtiene su UID y consulta los datos en Firestore.
  ///     3. Guarda los datos en `SharedPreferences` para persistencia.
  ///     4. Muestra un mensaje de éxito con `SnackBar`.
  ///     5. Limpia los campos del formulario.
  ///     6. Redirige a la pantalla de registro de usuario (`/registroUsuario`).
  /// - Si ocurre un error (por ejemplo, credenciales incorrectas), muestra un mensaje de error.
  ///
  /// Excepciones:
  /// - Captura errores en la autenticación y muestra un `SnackBar` con el mensaje "Email o contraseña incorrectos".
  /* Future<void> iniciarSesion(email, password, context, formkey) async {
    if (formkey.currentState!.validate()) {
      try {

        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );

        // 🔹 Obtener usuario autenticado
        User? user = userCredential.user;
        if(user != userCredential.user){
            // Obtener ID del usuario
            String uid = userCredential.user!.uid;

            // Traer datos del usuario desde Firestore
            DocumentSnapshot usuario = await FirebaseFirestore.instance.collection('usuarios').doc(uid).get();
            // Retornar los datos del usuario en un mapa
            Map<String, dynamic> datosUsuario = usuario.data() as Map<String, dynamic>;
            final prefs = await SharedPreferences.getInstance();
              
            await prefs.setString('uid', datosUsuario['uid']);
            await prefs.setString('nombre', datosUsuario['nombre']);
            await prefs.setString('apellido', datosUsuario['apellido']);
            await prefs.setString('email', datosUsuario['email']);
            await prefs.setString('rol', datosUsuario['rol']);
            await prefs.setString('telefono', datosUsuario['telefono']);

            switch (datosUsuario['rol']) {
              case "cliente":
                debugPrint("👉 cliente");
                break;
              
              case "admin":
                debugPrint("👉 admin");
                formkey.currentState?.reset();
                email.clear();
                password.clear();                  
                Navigator.pushNamed(context, '/home');
                break;
            }
        }

        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email o contraseña incorrectos")),
        );
      }
    }
  }
 */

  Future<void> iniciarSesion(
    TextEditingController email, 
    TextEditingController password, 
    BuildContext context, 
    GlobalKey<FormState> formKey) async {

  if (!formKey.currentState!.validate()) return; // Verifica si el formulario es válido

  try {
    loading = true;
    notifyListeners();


    // 🔹 Iniciar sesión con Firebase Authentication
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text.trim(),
      password: password.text.trim(),
    );

    User? user = userCredential.user;

    if (user == null) {
      throw FirebaseAuthException(code: "user-not-found", message: "No se pudo autenticar el usuario.");
    }

    // 🔹 Obtener datos del usuario desde Firestore
    DocumentSnapshot usuarioDoc = await FirebaseFirestore.instance.collection('usuarios').doc(user.uid).get();

    if (!usuarioDoc.exists) {
      throw FirebaseAuthException(code: "user-not-found", message: "No se encontraron datos en Firestore.");
    }

    Map<String, dynamic> datosUsuario = usuarioDoc.data() as Map<String, dynamic>;

    // Guardar en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', datosUsuario['uid']);
    await prefs.setString('nombre', datosUsuario['nombre']);
    await prefs.setString('apellido', datosUsuario['apellido']);
    await prefs.setString('email', datosUsuario['email']);
    await prefs.setString('rol', datosUsuario['rol']);
    await prefs.setString('telefono', datosUsuario['telefono']);
    await prefs.setString('password', datosUsuario['password']);

    // 🔹 Navegar según el rol del usuario
    switch (datosUsuario['rol']) {
      case "cliente":
      debugPrint("👉 cliente");
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
      default:
        mensajeError = e.message ?? mensajeError;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensajeError)),
    );
  }
}


  /// Método para cerrar sesión en la aplicación.
///
/// Parámetros:
/// - `context`: Contexto de la aplicación, necesario para la navegación.
///
/// Funcionamiento:
/// - Obtiene una instancia de `SharedPreferences` y borra todos los datos almacenados (credenciales, sesión, etc.).
/// - Cierra la sesión del usuario en Firebase Authentication.
/// - Elimina todas las pantallas anteriores de la pila de navegación.
/// - Redirige al usuario a la pantalla de inicio de sesión (`Login`).
///
/// Consideraciones:
/// - Se usa `pushAndRemoveUntil` para asegurarse de que el usuario no pueda volver atrás a la sesión cerrada.
/// - Es recomendable mostrar una alerta de confirmación antes de ejecutar este método para evitar cierres accidentales.
/// - Si se desea realizar acciones adicionales al cerrar sesión, se pueden agregar en este método.
  void cerrarSesion(BuildContext context) async {

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    notifyListeners();
    // Elimina las pantallas anteriores y lleva al usuario al login
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Login()), // Reemplaza con tu pantalla de login
      (Route<dynamic> route) => false,
    );
  }
 
  /// Muestra un cuadro de diálogo de confirmación antes de cerrar sesión.
///
/// Parámetros:
/// - `context`: Contexto de la aplicación necesario para mostrar el diálogo.
///
/// Retorno:
/// - `true` si el usuario confirma cerrar sesión.
/// - `false` si el usuario cancela la acción o cierra el cuadro de diálogo.
///
/// Funcionamiento:
/// - Se muestra un `AlertDialog` con el título "Cerrar sesión".
/// - Contiene dos botones:
///   - "Cancelar" (cierra el diálogo sin hacer nada).
///   - "Cerrar sesión" (confirma la acción devolviendo `true`).
/// - El `barrierDismissible: false` evita que el usuario cierre el cuadro tocando fuera de él.
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
            onPressed: () async { // Borra TODOS los datos antes de salir
              Navigator.of(context).pop(true);
              cerrarSesion(context);
            }, //=> Navigator.of(context).pop(true),
            child: Text("Cerrar sesión", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      );
    },
  );
  }
}

