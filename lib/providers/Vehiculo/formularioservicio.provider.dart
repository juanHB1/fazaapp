import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/vehiculos/vistaordendeservicio/ordenservicio.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class OrdenServicioFormProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String fecha = '';
  String descripcion = '';
  String estado = 'Pendiente';
  List<String> optionsDropDownList = ["ingresado", "espera", "terminado"];
  bool isCheckedController = false;
  bool loading = false;
  bool volviendoDeWhatsApp = false;

  //Guardar la orden de servicio en Firebase Firestore
  Future<void> guardarOrdenServicio(
    Map<String, dynamic> cliente,
    Map<String, dynamic> vehiculo,
    TextEditingController fechaController,
    TextEditingController descripcionController,
    TextEditingController estadoController,
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController fechaCambioAceiteController, // Nuevo controlador
    TextEditingController proximoCambioAceiteController, // Nuevo controlador
    TextEditingController estadoPagoController, // Nuevo controlador
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
        String fechaCambioAceite = fechaCambioAceiteController.text.trim(); // Nuevo valor
        String proximoCambioAceite = proximoCambioAceiteController.text.trim(); // Nuevo valor
        String estadoPago = estadoPagoController.text.trim(); // Nuevo valor

        // ✅ Guarda la orden en la subcolección correcta
        await ordenServicioRef.set({
          "fecha": fecha,
          "descripcion": descripcion,
          "estado": estado,
          "fechaCambioAceite": fechaCambioAceite, // Nuevo campo
          "proximoCambioAceite": proximoCambioAceite, // Nuevo campo
          "estadoPago": estadoPago, // Nuevo campo
          "uid": ordenServicioRef.id, // ID de la orden de servicio
        });
          
        await Future.delayed(Duration(seconds: 3), () {
          formKey.currentState?.reset();
          fechaController.clear();
          descripcionController.clear();
          estadoController.clear();
          fechaCambioAceiteController.clear(); // Limpiar nuevo controlador
          proximoCambioAceiteController.clear(); // Limpiar nuevo controlador
          estadoPagoController.clear(); // Limpiar nuevo controlador
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

  void verificar(
    String estado,
    Map<String, dynamic> cliente,
    Map<String, dynamic> vehiculo,
    Map<String, dynamic> ordenServicio,
    TextEditingController fechaController,
    TextEditingController descripcionController,
    TextEditingController estadoController,
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController fechaCambioAceiteController, // Nuevo controlador
    TextEditingController proximoCambioAceiteController, // Nuevo controlador
    TextEditingController estadoPagoController,
    ){

    switch (estado) {
        case "guardar":
        if(estadoController.text =="ingresado"){
          mostrarInfoDialog(
              estado,
              cliente,
              vehiculo,
              ordenServicio,
              fechaController,
              descripcionController,
              estadoController,
              context,
              formKey,
              fechaCambioAceiteController, // Nuevo controlador
              proximoCambioAceiteController, // Nuevo controlador
              estadoPagoController,      
              "Hola, su vehículo ha sido ingresado a la orden."
              );
          }
          break;
        case "modificar":
          if(estadoController.text =="terminado"){
          mostrarInfoDialog(
                estado,
                cliente,
                vehiculo,
                ordenServicio,
                fechaController,
                descripcionController,
                estadoController,
                context,
                formKey,
                fechaCambioAceiteController, // Nuevo controlador
                proximoCambioAceiteController, // Nuevo controlador
                estadoPagoController,      
                "Hola, su vehículo está listo para ser recogido."
                );
          }else{
            editarOrdenServicio(cliente, vehiculo, ordenServicio, fechaController, descripcionController, estadoController, context, formKey, fechaCambioAceiteController, proximoCambioAceiteController, estadoPagoController);
          }
        break;
        default:
      }
  }


  //editar la orden de servicio
  Future<void> editarOrdenServicio(
    Map<String, dynamic> cliente,
    Map<String, dynamic> vehiculo,
    Map<String, dynamic> ordenServicio,
    TextEditingController fechaController,
    TextEditingController descripcionController,
    TextEditingController estadoController,
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController fechaCambioAceiteController, // Nuevo controlador
    TextEditingController proximoCambioAceiteController, // Nuevo controlador
    TextEditingController estadoPagoController, // Nuevo controlador

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
            String fechaCambioAceite = fechaCambioAceiteController.text.trim(); // Nuevo valor
            String proximoCambioAceite = proximoCambioAceiteController.text.trim(); // Nuevo valor
            String estadoPago = estadoPagoController.text.trim(); // Nuevo valor

        

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
              "fechaCambioAceite": fechaCambioAceite, // Nuevo campo
              "proximoCambioAceite": proximoCambioAceite, // Nuevo campo
              "estadoPago": estadoPago, // Nuevo campo
            });

            await Future.delayed(Duration(seconds: 3), () {
              formKey.currentState?.reset();
              fechaController.clear();
              descripcionController.clear();
              estadoController.clear();
              fechaCambioAceiteController.clear(); // Limpiar nuevo controlador
              proximoCambioAceiteController.clear(); // Limpiar nuevo controlador
              estadoPagoController.clear(); // Limpiar nuevo controlador
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
            return;
        
      } catch (e) {
        const SnackBar(content: Text("Error al guardar la orden."));
      }

      loading = false;
      notifyListeners();
    }
  }

  Future<void> verificarEstadoCheckSelector(
    value, 
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController fechaCambioAceiteController, // Nuevo controlador
    TextEditingController proximoCambioAceiteController, ) async {
    isCheckedController = value;
    if (isCheckedController) {
      fechaCambioAceiteController.text = DateTime.now().toString().split(' ')[0];
      proximoCambioAceiteController.text = DateTime.now().toString().split(' ')[0];
    } else {
      fechaCambioAceiteController.clear();
      proximoCambioAceiteController.clear();
    }
    notifyListeners();
  }




  Future<void> enviarMensaje( String phoneNumber, String message, BuildContext context, Map<String, dynamic> vehiculo, Map<String, dynamic> cliente) async {
  try {
    final intent = AndroidIntent(
      action: "android.intent.action.VIEW",
      data: "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}",
      package: "com.whatsapp", // Asegura que se abra en WhatsApp
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );

    volviendoDeWhatsApp = true; // 🔹 Marca que salimos a WhatsApp
    await intent.launch();

  } catch (e) {
    print("Error al abrir WhatsApp: $e");
  }
}


void mostrarInfoDialog (
  String estado,
  Map<String, dynamic> cliente,
    Map<String, dynamic> vehiculo,
    Map<String, dynamic> ordenServicio,
    TextEditingController fechaController,
    TextEditingController descripcionController,
    TextEditingController estadoController,
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController fechaCambioAceiteController, // Nuevo controlador
    TextEditingController proximoCambioAceiteController, // Nuevo controlador
    TextEditingController estadoPagoController,
    String mensaje,
  )  {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "¿Quieres notificar el vehículo vía WhatsApp?",
          style: TextStyle(fontWeight: FontWeight.w200, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        
        actions: [
          //opcion cuando el usuario da en el modal aceptar
          TextButton(
            onPressed: ()async{
              Navigator.pop(context);
              switch (estado) {
                case "guardar":
                  await guardarOrdenServicio(cliente, vehiculo, fechaController, descripcionController, estadoController, context, formKey, fechaCambioAceiteController, proximoCambioAceiteController, estadoPagoController);
                  //await Future.delayed(Duration(seconds: 3));
                  await enviarMensaje( cliente['telefono'], mensaje, context, vehiculo, cliente);
                  break;
                case "modificar":
                  editarOrdenServicio(
                    cliente,
                    vehiculo,
                    ordenServicio,
                    fechaController,
                    descripcionController,
                    estadoController,
                    context,
                    formKey,
                    fechaCambioAceiteController, // Nuevo controlador
                    proximoCambioAceiteController, // Nuevo controlador
                    estadoPagoController
                  );
                  await Future.delayed(Duration(seconds: 3));
                  await enviarMensaje(cliente['telefono'], mensaje, context, vehiculo, cliente);
                  break;
                default:
              }
             
              /* ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mensaje enviado por WhatsApp.')),
              ); */
            },
            child: const Text(
              "Aceptar",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          //opcion cuando el usuario da en el modal cancelar
          TextButton(
            onPressed: (){
              Navigator.pop(context);
              switch (estado) {
                
                case "guardar":
                  guardarOrdenServicio(cliente, vehiculo, fechaController, descripcionController, estadoController, context, formKey, fechaCambioAceiteController, proximoCambioAceiteController, estadoPagoController);
                  break;
                case "modificar":
                  editarOrdenServicio(
                    cliente,
                    vehiculo,
                    ordenServicio,
                    fechaController,
                    descripcionController,
                    estadoController,
                    context,
                    formKey,
                    fechaCambioAceiteController, // Nuevo controlador
                    proximoCambioAceiteController, // Nuevo controlador
                    estadoPagoController
                  );

                  break;
                default:
              }
            },
            child: const Text(
              "Cerrar",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

  

  
}