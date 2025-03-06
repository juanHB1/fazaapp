import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/vehiculos/vistaordendeservicio/ordenservicio.dart';

class OrdenServicioFormProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String fecha = '';
  String descripcion = '';
  String estado = 'Pendiente';
  List<String> optionsDropDownList = ["ingresado", "espera", "terminado"];


  bool loading = false;

  void setFecha(String value) {
    fecha = value;
    notifyListeners();
  }

  void setDescripcion(String value) {
    descripcion = value;
    notifyListeners();
  }

  void setEstado(String value) {
    estado = value;
    notifyListeners();
  }

  //Guardar la orden de servicio en Firebase Firestore
  Future<void> guardarOrdenServicio (
      String clienteId,
      Map<String, dynamic> vehiculo,
      TextEditingController fechaController,
      TextEditingController descripcionController,
      TextEditingController estadoController,
      BuildContext context,
      GlobalKey<FormState> formKey
    ) async {

    if (formKey.currentState!.validate()) {
      try {
      
      loading = true;
      notifyListeners();

      String vehiculoId = vehiculo['uid']; // ✅ Usa el ID del vehículo

      // ✅ Crea referencia a la subcolección "ordenServicio" dentro del vehículo
      final ordenServicioRef = FirebaseFirestore.instance
        .collection('usuarios') // 🔹 Empezamos desde la colección correcta
        .doc(clienteId) // 🔹 ID del usuario
        .collection('vehiculos')
        .doc(vehiculoId)
        .collection('ordenServicio')
        .doc(); // 🔹 Genera un ID único para la orden

        // ✅ Obtiene valores de los controladores
        String fecha = fechaController.text.trim();
        String descripcion = descripcionController.text.trim();
        String estado = estadoController.text.trim();

      // ✅ Guarda la orden en la subcolección correcta
      await ordenServicioRef.set({
        "fecha": fecha,
        "descripcion": descripcion,
        "estado": estado,
        "uid": ordenServicioRef.id, // ID de la orden de servicio
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orden de servicio guardada correctamente.')),
      );
      
      loading = false;
      notifyListeners();

      formKey.currentState?.reset();
      fechaController.clear();
      descripcionController.clear();
      estadoController.clear();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrdenesServicio(vehiculo: vehiculo, clienteId: clienteId),
        ),
      );

      

      } catch (e) {
        const SnackBar(content: Text("Error al guardar la orden."));
      }

      loading = false;
      notifyListeners();
    }
  }

  //editar la orden de servicio
  Future<void> editarOrdenServicio (
      String clienteId,
      Map<String, dynamic> vehiculo,
      Map<String, dynamic> ordenServicio,
      TextEditingController fechaController,
      TextEditingController descripcionController,
      TextEditingController estadoController,
      BuildContext context,
      GlobalKey<FormState> formKey
    ) async {

    if (formKey.currentState!.validate()) {
      try {
      
      loading = true;
      notifyListeners();

      String vehiculoId = vehiculo['uid']; // ✅ Usa el ID del vehículo

        // ✅ Obtiene valores de los controladores
        String fecha = fechaController.text.trim();
        String descripcion = descripcionController.text.trim();
        String estado = estadoController.text.trim();

      await FirebaseFirestore.instance
        .collection('usuarios') // 🔹 Empezamos desde la colección correcta
        .doc(clienteId) // 🔹 ID del usuario
        .collection('vehiculos')
        .doc(vehiculoId)
        .collection('ordenServicio')
        .doc(ordenServicio['uid'])
        .update({
          "fecha": fecha,
          "descripcion": descripcion,
          "estado": estado,
        });

      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orden de servicio actualizada correctamente.')),
      );

      Future.delayed(Duration(seconds: 1), () {
        formKey.currentState?.reset();
        fechaController.clear();
        descripcionController.clear();
        estadoController.clear();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrdenesServicio(vehiculo: vehiculo, clienteId: clienteId),
          ),
        );
      });

      

      

      } catch (e) {
        const SnackBar(content: Text("Error al guardar la orden."));
      }

      loading = false;
      notifyListeners();
    }
  }

}