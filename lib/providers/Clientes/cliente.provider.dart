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

  
  /// Método asíncrono para obtener clientes desde Firebase Firestore.
  /// Retorna una lista de mapas con los datos de los usuarios almacenados en la colección 'usuarios'.
  Future<List<Map<String, dynamic>>> obtenerClientes() async {
    try {
      // Realiza la consulta a Firestore y obtiene todos los documentos de la colección 'usuarios'.
      QuerySnapshot query = await FirebaseFirestore.instance.collection('usuarios').get();

      // Verifica si no hay documentos en la colección y retorna una lista vacía en ese caso.
      if (query.docs.isEmpty) return [];

      // Mapea los documentos obtenidos a una lista de mapas con valores predeterminados si los campos son nulos.
      List<Map<String, dynamic>> clientes = query.docs.map((doc) {
        // Obtiene los datos correctamente usando doc.data()
        final data = doc.data() as Map<String, dynamic>;

        return {
          "nombres": data["nombre"] ?? "Sin nombre",
          "apellidos": data["apellido"] ?? "Sin apellido",
          "email": data["email"] ?? "Sin email",
          "password": data.containsKey("password") ? data["password"] : "Sin password",
          "rol": data["rol"] ?? "Sin rol",
          "telefono": data["telefono"] ?? "Sin telefono",
          "id": data["uid"] ?? doc.id, // Usa doc.id si no hay UID en Firestore
        };
        }).toList();

      // Retorna la lista de clientes.
      return clientes;
    } catch (e) {
      // Captura errores en la consulta, los imprime en la consola y retorna una lista vacía.
      debugPrint("Error al obtener clientes: $e");
      return [];
    }
  }


  /// Método para cargar clientes en la lista local desde Firebase Firestore.
  /// Llama al método `obtenerClientes()` para obtener los datos y actualiza la lista `clientes`.
  /// Notifica a los listeners para actualizar la UI tras la carga de datos.
  void cargarClientes() async {
    try {
      // Obtiene la lista de clientes de la base de datos.
      List<Map<String, dynamic>> datos = await obtenerClientes();
      
      // Asigna los datos obtenidos a la lista local de clientes.
      clientes = datos;

      // Notifica a los widgets dependientes para que se reconstruyan con los nuevos datos.
      notifyListeners();
    } catch (e) {
      // Maneja errores y los muestra en la consola.
      debugPrint("Error al cargar clientes: $e");
    }
  }

  
  
  /// Registra un nuevo cliente en Firebase Authentication y almacena sus datos en Firestore.
  /// Parámetros:
  /// - [nombres], [apellidos], [email], [tel], [rol], [password]: Controladores de texto con la información del usuario.
  /// - [context]: Contexto de la aplicación para mostrar mensajes.
  /// - [formkey]: Clave del formulario para validar los campos antes del registro.
  /// 
  /// Flujo:
  /// 1. Valida el formulario.
  /// 2. Crea un usuario en Firebase Authentication.
  /// 3. Guarda la información del usuario en Firestore.
  /// 4. Limpia los campos del formulario.
  /// 5. Muestra una notificación de éxito o error.
  Future<void> registrarCliente(nombres, apellidos, email, tel, rol, password, context, formkey) async {
    if (formkey.currentState!.validate()) {
      try {
        loading = true; 
        notifyListeners();
        // Crea el usuario en Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text,
          password: password.text,
        );

        // Obtiene el UID del usuario recién creado
        String uid = userCredential.user!.uid;

        // Guarda la información del usuario en Firestore
        await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
          'nombre': nombres.text,
          'apellido': apellidos.text,
          'email': email.text,
          'telefono': tel.text,
          'uid': uid,
          'rol': rol.text,
          'password': password.text,
        });

        // Resetea el formulario y limpia los campos
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
        // Muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado con éxito')),
        );
      } on FirebaseAuthException catch (e) {
        // Maneja errores de autenticación
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }


  /// Edita la información de un cliente existente en Firebase Firestore.
  ///
  /// Parámetros:
  /// - [id]: ID del cliente en Firestore.
  /// - [nombres], [apellidos], [email], [tel], [rol], [password]: Controladores de texto con los valores editados.
  /// - [context]: Contexto para mostrar mensajes.
  /// - [formKey]: Clave del formulario para validación.
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
            // 🔹 Actualizar datos en Firestore
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
              // Resetea el formulario y limpia los campos
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
        // Manejo de errores
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e')),
        );
      
    }
  }


    // Método para navegar a la vista de vehículos
  void agregarCarros(BuildContext context, Map<String, dynamic> cliente) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Vehiculo(cliente: cliente), // Pasa el cliente
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
              _infoDialogRow('Nombres:', cliente["nombres"]),
              _infoDialogRow('Apellidos:', cliente["apellidos"]),
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

  //permite llevar al usuario a la funcionalidad de llamada
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