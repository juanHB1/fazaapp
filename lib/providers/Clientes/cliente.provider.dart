import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/servicios/shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/views/vehiculos/listaVehiculos/vehiculo.dart';
import 'package:url_launcher/url_launcher.dart';


class ClientesProvider extends ChangeNotifier {

  List<Map<String, dynamic>> clientes = [];
  List<String> optionsDropDownList = ["cliente", "admin"];
  String credencialNombre = '';
  String credencialApellido ='';
  bool loading = false;

  Future<List<Map<String, dynamic>>> obtenerClientes() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance.collection('usuarios').get();

      if (query.docs.isEmpty) return [];

      List<Map<String, dynamic>> clientes = query.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return {
          "nombre": data["nombre"] ?? "Sin nombre",
          "apellido": data["apellido"] ?? "Sin apellido",
          "email": data["email"] ?? "Sin email",
          "password": data.containsKey("password") ? data["password"] : "Sin password",
          "rol": data["rol"] ?? "Sin rol",
          "telefono": data["telefono"] ?? "Sin telefono",
          "uid": data["uid"] ?? doc.id,
        };
        }).toList();

      return clientes;
    } catch (e) {
      return [];
    }
  }

  void cargarClientes() async {
    try {
      List<Map<String, dynamic>> datos = await obtenerClientes();
      clientes = datos;
      notifyListeners();
    } catch (e) {
      // Error handling
    }
  }

  Future<void> registrarCliente(nombres, apellidos, email, tel, rol, password, context, formkey) async {
    if (formkey.currentState!.validate()) {
      try {
        loading = true;
        notifyListeners();
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );

        String uid = userCredential.user!.uid;

        await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
          'nombre': nombres.text,
          'apellido': apellidos.text,
          'email': email.text,
          'telefono': tel.text,
          'uid': uid,
          'rol': rol.text,
          'password': password.text,
        });

        formkey.currentState?.reset();
        nombres.clear();
        apellidos.clear();
        email.clear();
        tel.clear();
        rol.clear();
        password.clear();
        loading = false;
        notifyListeners();
        Navigator.pushNamed(context, '/clientes');
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

  Future<void> editarCliente(
      String id,
      TextEditingController nombres,
      TextEditingController apellidos,
      TextEditingController email,
      TextEditingController tel,
      TextEditingController rol,
      TextEditingController password,
      BuildContext context,
      GlobalKey<FormState> formKey) async {

      if (!formKey.currentState!.validate()) return;

        try {
            loading = true;
            notifyListeners();
            await FirebaseFirestore.instance.collection('usuarios').doc(id).update({
              'nombre': nombres.text,
              'apellido': apellidos.text,
              'email': email.text,
              'telefono': tel.text,
              'rol': rol.text,
              'password': password.text,
            });

            Future.delayed(Duration(seconds: 1), () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Usuario actualizado con éxito')),
              );
              formKey.currentState?.reset();
              nombres.clear();
              apellidos.clear();
              email.clear();
              tel.clear();
              rol.clear();
              password.clear();
              loading = false;
              notifyListeners();
              Navigator.pushNamed(context, '/clientes');
            });

        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar: $e')),
          );

        }
  }

  void agregarCarros(BuildContext context, Map<String, dynamic> cliente) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Vehiculo(cliente: cliente),
      ),
    );
  }

  void mostrarPrevisualizacion(BuildContext context, Map<String, dynamic> cliente) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Detalles del Cliente",
        style: TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _infoDialogRow('Nombres:', cliente["nombre"]),
              _infoDialogRow('Apellidos:', cliente["apellido"]),
              _infoDialogRow('Email:', cliente["email"]),
              _infoDialogRow('Teléfono:', cliente["telefono"]),
              _infoDialogRow('Rol:', cliente["rol"]),
              if (cliente["direccion"] != null)
                _infoDialogRow('Dirección:', cliente["direccion"]),
              if (cliente["fechaRegistro"] != null)
                _infoDialogRow('Registro:', cliente["fechaRegistro"]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.blueGrey[900])),
          )
        ],
      ),
    );
  }

  Widget _infoDialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
            fontSize: 14
          )),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value,
                style: TextStyle(color: Colors.blueGrey[700], fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Future<void> hacerLlamada(String numTelefono, BuildContext context) async {
    if (numTelefono.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Número de teléfono vacío.')),
      );
      return;
    }

    final Uri url = Uri(scheme: 'tel', path: numTelefono);

    try {
      bool launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        throw 'No se pudo lanzar la URL';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo iniciar la llamada. Error: $e')),
      );
    }
  }

  Future<void> obtenerCredencialNombre(String key) async {
    credencialNombre = await Shared.getCredentials(key) ?? "";
    notifyListeners();
  }

  Future<void> obtenerCredencialApellido(String key) async {
    credencialApellido = await Shared.getCredentials(key) ?? "";
    notifyListeners();
  }
}