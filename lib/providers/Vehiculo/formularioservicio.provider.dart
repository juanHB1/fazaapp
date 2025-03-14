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

  //Guardar la orden de servicio en Firebase Firestore
  Future<void> guardarOrdenServicio (
      Map<String, dynamic> cliente,
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
        .doc(cliente['uid']) // 🔹 ID del usuario
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
      
      

      await Future.delayed(Duration(seconds: 2), () {
        
        formKey.currentState?.reset();
        fechaController.clear();
        descripcionController.clear();
        estadoController.clear();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrdenesServicio(vehiculo: vehiculo, cliente: cliente),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Orden de servicio guardada correctamente.')),
        );
        loading = false;
        notifyListeners();
      });

      

      } catch (e) {
        const SnackBar(content: Text("Error al guardar la orden."));
        loading = false;
        notifyListeners();
      }

      loading = false;
      notifyListeners();
    }
  }

  //editar la orden de servicio
  Future<void> editarOrdenServicio (
      Map<String, dynamic> cliente,
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
        .doc(cliente['uid']) // 🔹 ID del usuario
        .collection('vehiculos')
        .doc(vehiculoId)
        .collection('ordenServicio')
        .doc(ordenServicio['uid'])
        .update({
          "fecha": fecha,
          "descripcion": descripcion,
          "estado": estado,
        });

      await Future.delayed(Duration(seconds: 3), (){
        formKey.currentState?.reset();
        fechaController.clear();
        descripcionController.clear();
        estadoController.clear();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrdenesServicio(vehiculo: vehiculo, cliente: cliente),
          ),
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Orden de servicio actualizada correctamente.')),
        );
        loading = false;
        notifyListeners();
      });

        

      } catch (e) {
        const SnackBar(content: Text("Error al guardar la orden."));
      }

      loading = false;
      notifyListeners();
    }
  }

  



}