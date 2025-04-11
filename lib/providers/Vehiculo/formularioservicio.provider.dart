import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/vehiculos/vistaordendeservicio/ordenservicio.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:intl/intl.dart';


class OrdenServicioFormProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String fecha = '';
  String descripcion = '';
  //String estado = 'Pendiente';
  List<String> optionsOrdenServicios = ["ingresado", "terminado"];
  bool isCheckedController = false;
  bool loading = false;
  bool volviendoDeWhatsApp = false;
    final DateFormat _dbFormat = DateFormat('dd/MM/yyyy'); // Asegúrate que este formato coincida con el usado en la UI


  //Guardar la orden de servicio en Firebase Firestore
  /* Future<void> guardarOrdenServicio(
    Map<String, dynamic> cliente,
    Map<String, dynamic> vehiculo,
    TextEditingController fechaController,
    TextEditingController descripcionController,
    TextEditingController estadoServicioController,
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
        String estadoServicio = estadoServicioController.text.trim();
        String fechaCambioAceite = fechaCambioAceiteController.text.trim(); // Nuevo valor
        String proximoCambioAceite = proximoCambioAceiteController.text.trim(); // Nuevo valor
        String estadoPago = estadoPagoController.text.trim(); // Nuevo valor

        // ✅ Guarda la orden en la subcolección correcta
        await ordenServicioRef.set({
          "fecha": fecha,
          "descripcion": descripcion,
          "estadoServicio": estadoServicio,
          "fechaCambioAceite": fechaCambioAceite, // Nuevo campo
          "proximoCambioAceite": proximoCambioAceite, // Nuevo campo
          "estadoPago": estadoPago, // Nuevo campo
          "uid": ordenServicioRef.id, // ID de la orden de servicio
          "estadoChecked": isCheckedController, // Nuevo campo para el checkbox
        });


        await Future.delayed(Duration(seconds: 3), () {
          formKey.currentState?.reset();
          fechaController.clear();
          descripcionController.clear();
          estadoServicioController.clear();
          fechaCambioAceiteController.clear(); // Limpiar nuevo controlador
          proximoCambioAceiteController.clear(); // Limpiar nuevo controlador
          estadoPagoController.clear(); // Limpiar nuevo controlador
          isCheckedController = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrdenesServicio(vehiculo: vehiculo, cliente: cliente),
            ),
          );

          
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Orden de servicio guardada correctamente.')),
          );
          loading = false;
          notifyListeners();
      } catch (e) {
        const SnackBar(content: Text("Error al guardar la orden."));
        loading = false;
        notifyListeners();
      }

      loading = false;
      notifyListeners();
    }
  }
 */
  
  // --- REEMPLAZAR MÉTODO COMPLETO ---
  // Guardar la orden de servicio en Firebase Firestore (Refactorizado)
  Future<bool> guardarOrdenServicio(
    Map<String, dynamic> cliente,
    Map<String, dynamic> vehiculo,
    TextEditingController fechaController,
    TextEditingController descripcionController,
    TextEditingController estadoServicioController,
    TextEditingController fechaCambioAceiteController,
    TextEditingController proximoCambioAceiteController,
    TextEditingController estadoPagoController,
    // No necesitas context ni formKey aquí si la validación se hizo antes
  ) async {
    // Asumiendo que formKey.currentState!.validate() se hizo ANTES de llamar

    loading = true;
    notifyListeners();

    try {
      String vehiculoId = vehiculo['uid'];
      final ordenServicioRef = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(cliente['uid'])
          .collection('vehiculos')
          .doc(vehiculoId)
          .collection('ordenServicio')
          .doc();

      // --- Conversión String a Timestamp ---
      Timestamp? fechaTS;
      Timestamp? fechaAceiteTS;
      Timestamp? proximoAceiteTS;
      try {
         // Intenta parsear solo si el texto no está vacío
         if (fechaController.text.trim().isNotEmpty) {
            fechaTS = Timestamp.fromDate(_dbFormat.parseStrict(fechaController.text.trim()));
         }
         // Parsea fechas de aceite solo si el checkbox está activo Y el texto no está vacío
         if (isCheckedController && fechaCambioAceiteController.text.trim().isNotEmpty) {
            fechaAceiteTS = Timestamp.fromDate(_dbFormat.parseStrict(fechaCambioAceiteController.text.trim()));
         }
         if (isCheckedController && proximoCambioAceiteController.text.trim().isNotEmpty) {
            proximoAceiteTS = Timestamp.fromDate(_dbFormat.parseStrict(proximoCambioAceiteController.text.trim()));
         }
      } catch (e) {
         debugPrint("Error parseando fechas antes de guardar: $e. Se guardarán como null.");
         // Los Timestamps que fallaron seguirán siendo null
      }
      // --- Fin conversión ---

      await ordenServicioRef.set({
        "fecha":fechaTS, // Guarda Timestamp o null
        "descripcion": descripcionController.text.trim(),
        "estadoServicio": estadoServicioController.text.trim(),
        // Guarda Timestamp o null. Si isCheckedController es false, serán null.
        "fechaCambioAceite": fechaAceiteTS, // Timestamp, null o FieldValue.delete()
        "proximoCambioAceite": proximoAceiteTS, // Timestamp, null o FieldValue.delete()
        "estadoPago": estadoPagoController.text.trim(),
        "uid": ordenServicioRef.id,
        "estadoChecked": isCheckedController,
      });

      loading = false;
      notifyListeners();
      return true; // Indica éxito

    } catch (e) {
      debugPrint("Error al guardar la orden: $e");
      loading = false;
      notifyListeners();
      // Podrías mostrar un SnackBar de error aquí si tienes acceso al context,
      // o manejarlo donde se llama a esta función.
      return false; // Indica fallo
    }
    // El loading = false y notifyListeners() al final del try/catch original
    // eran redundantes porque ya estaban dentro de ambos bloques.
  }
  // --- FIN REEMPLAZO guardarOrdenServicio ---
  
  /* void verificar(
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
 */

  // --- REEMPLAZAR MÉTODO COMPLETO ---
  // Verificar y decidir si mostrar diálogo o actuar directamente (Refactorizado)
  Future<void> verificar( // Ahora es async para poder usar await
    String accion, // "guardar" o "modificar"
    Map<String, dynamic> cliente,
    Map<String, dynamic> vehiculo,
    Map<String, dynamic> ordenServicio, // Vacío si es 'guardar'
    TextEditingController fechaController,
    TextEditingController descripcionController,
    TextEditingController estadoController, // Este es estadoServicioController
    BuildContext context, // Contexto necesario para UI (Dialog, SnackBar, Navegación)
    GlobalKey<FormState> formKey, // Necesario para validar y resetear
    TextEditingController fechaCambioAceiteController,
    TextEditingController proximoCambioAceiteController,
    TextEditingController estadoPagoController,
    // bool currentCheckboxValue, // No es necesario si isCheckedController se actualiza antes
  ) async {

     // 1. Validar el formulario ANTES de cualquier acción
     //    (La validación ya se hace en la UI antes de llamar a verificar)
     //    if (!formKey.currentState!.validate()) {
     //      return;
     //    }

     // Asegúrate que 'isCheckedController' tenga el valor actual del checkbox
     // Esto debería haberse actualizado en el onChanged del Checkbox en la UI

     bool showDialogAndNotify = false;
     String mensajeWhatsApp = "";

     // Decide si mostrar el diálogo basado en la acción y el estado
     if (accion == "guardar" && estadoController.text == "ingresado") {
       showDialogAndNotify = true;
       mensajeWhatsApp = "Hola ${cliente['nombre'] ?? 'Cliente'}, su vehículo ${vehiculo['marca'] ?? ''} ${vehiculo['modelo'] ?? ''} placa ${vehiculo['placa'] ?? ''} ha sido ingresado a la orden.";
     } else if (accion == "modificar" && estadoController.text == "terminado") {
        showDialogAndNotify = true;
        mensajeWhatsApp = "Hola ${cliente['nombre'] ?? 'Cliente'}, su vehículo ${vehiculo['marca'] ?? ''} ${vehiculo['modelo'] ?? ''} placa ${vehiculo['placa'] ?? ''} está listo para ser recogido.";
     }

     if (showDialogAndNotify) {
        // Muestra el diálogo y DELEGA la lógica (incluida navegación) a las acciones del diálogo
        await mostrarInfoDialog(
              accion,
              cliente,
              vehiculo,
              ordenServicio,
              fechaController,
              descripcionController,
              estadoController,
              fechaCambioAceiteController,
              proximoCambioAceiteController,
              estadoPagoController,
              mensajeWhatsApp,
              context, // Pasa el contexto de la UI
              formKey, // Pasa el formKey
            );
     } else {
        // Acción directa (sin diálogo) - Ej: modificar sin cambiar a "terminado" o guardar sin ser "ingresado"
        bool success = false;
        if (accion == "modificar") {
           success = await editarOrdenServicio( // Llama a la versión refactorizada
              cliente, vehiculo, ordenServicio,
              fechaController, descripcionController, estadoController,
              fechaCambioAceiteController, proximoCambioAceiteController, estadoPagoController
           );
        } else if (accion == "guardar") {
           success = await guardarOrdenServicio( // Llama a la versión refactorizada
              cliente, vehiculo,
              fechaController, descripcionController, estadoController,
              fechaCambioAceiteController, proximoCambioAceiteController, estadoPagoController
           );
        }

        // Navegar y mostrar SnackBar DESPUÉS de la operación (si no hubo diálogo)
        if (success && context.mounted) { // Verifica si el widget aún está montado
           _resetFormAndNavigate(formKey, fechaController, descripcionController, estadoController, fechaCambioAceiteController, proximoCambioAceiteController, estadoPagoController, context, vehiculo, cliente);
           ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Orden de servicio ${accion == 'guardar' ? 'guardada' : 'actualizada'} correctamente.')),
           );
        } else if (!success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al ${accion == 'guardar' ? 'guardar' : 'actualizar'} la orden.')),
           );
        }
     }
  }
  // --- FIN REEMPLAZO verificar ---

  //editar la orden de servicio
  /* Future<void> editarOrdenServicio(
    Map<String, dynamic> cliente,
    Map<String, dynamic> vehiculo,
    Map<String, dynamic> ordenServicio,
    TextEditingController fechaController,
    TextEditingController descripcionController,
    TextEditingController estadoServicioController,
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
            String estado = estadoServicioController.text.trim();
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
              "estadoServicio": estado,
              "fechaCambioAceite": fechaCambioAceite, // Nuevo campo
              "proximoCambioAceite": proximoCambioAceite, // Nuevo campo
              "estadoPago": estadoPago, // Nuevo campo
              "estadoChecked": isCheckedController, // Nuevo campo para el checkbox
            });

         
            await Future.delayed(Duration(seconds: 3), () {
              formKey.currentState?.reset();
              fechaController.clear();
              descripcionController.clear();
              estadoServicioController.clear();
              fechaCambioAceiteController.clear(); // Limpiar nuevo controlador
              proximoCambioAceiteController.clear(); // Limpiar nuevo controlador
              estadoPagoController.clear(); // Limpiar nuevo controlador
              isCheckedController = false; // Nuevo campo para el checkbox
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OrdenesServicio(vehiculo: vehiculo, cliente: cliente),
                ),
              );
              
            });
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Orden de servicio actualizada correctamente.')),
              );
              loading = false;
              notifyListeners();
            return;
        
      } catch (e) {
        const SnackBar(content: Text("Error al guardar la orden."));
      }

      loading = false;
      notifyListeners();
    }
  }
 */
  
  // --- REEMPLAZAR MÉTODO COMPLETO ---
  // Editar la orden de servicio (Refactorizado)
  Future<bool> editarOrdenServicio(
    Map<String, dynamic> cliente,
    Map<String, dynamic> vehiculo,
    Map<String, dynamic> ordenServicio,
    TextEditingController fechaController,
    TextEditingController descripcionController,
    TextEditingController estadoServicioController,
    TextEditingController fechaCambioAceiteController,
    TextEditingController proximoCambioAceiteController,
    TextEditingController estadoPagoController,
     // No necesitas context ni formKey aquí
  ) async {
     // Asumiendo que formKey.currentState!.validate() se hizo ANTES de llamar

    loading = true;
    notifyListeners();

    try {
      String vehiculoId = vehiculo['uid'];
      String ordenServicioId = ordenServicio['uid']; // Asegúrate de tener el ID de la orden

      // --- Conversión String a Timestamp ---
      Timestamp? fechaTS;
      dynamic fechaAceiteValor; // Puede ser Timestamp o FieldValue.delete()
      dynamic proximoAceiteValor; // Puede ser Timestamp o FieldValue.delete()
      try {
        if (fechaController.text.trim().isNotEmpty) {
          fechaTS = Timestamp.fromDate(_dbFormat.parseStrict(fechaController.text.trim()));
        }

        if (isCheckedController) {
           // Si está chequeado, intenta parsear o deja null si está vacío
           fechaAceiteValor = fechaCambioAceiteController.text.trim().isNotEmpty
              ? Timestamp.fromDate(_dbFormat.parseStrict(fechaCambioAceiteController.text.trim()))
              : ""; // O quizás quieras mantener el valor anterior si estaba vacío? Decide la lógica.
           proximoAceiteValor = proximoCambioAceiteController.text.trim().isNotEmpty
              ? Timestamp.fromDate(_dbFormat.parseStrict(proximoCambioAceiteController.text.trim()))
              : "";
        }

      } catch (e) {
        debugPrint("Error parseando fechas antes de actualizar: $e. Se intentará guardar null/delete.");
        // Los valores serán null o FieldValue.delete() según el caso anterior
      }
      // --- Fin conversión ---

      // Prepara los datos a actualizar
      Map<String, dynamic> dataToUpdate = {
            "fecha": fechaTS, // Actualiza con Timestamp o null
            "descripcion": descripcionController.text.trim(),
            "estadoServicio": estadoServicioController.text.trim(),
            "estadoPago": estadoPagoController.text.trim(),
            "estadoChecked": isCheckedController,
            "fechaCambioAceite": fechaAceiteValor, // Timestamp, null o FieldValue.delete()
            "proximoCambioAceite": proximoAceiteValor, // Timestamp, null o FieldValue.delete()
       };

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(cliente['uid'])
          .collection('vehiculos')
          .doc(vehiculoId)
          .collection('ordenServicio')
          .doc(ordenServicioId) // Usa el ID de la orden a editar
          .update(dataToUpdate);

      loading = false;
      notifyListeners();
      return true; // Indica éxito

    } catch (e) {
      debugPrint("Error al actualizar la orden: $e");
      loading = false;
      notifyListeners();
      return false; // Indica fallo
    }
  }
  // --- FIN REEMPLAZO editarOrdenServicio ---
  
  Future<void> verificarEstadoCheckSelector(
    value, 
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController fechaCambioAceiteController, // Nuevo controlador
    TextEditingController proximoCambioAceiteController, ) async {
    isCheckedController = value;
    if (isCheckedController) {
      fechaCambioAceiteController.text = fechaCambioAceiteController.text; //DateTime.now().toString().split(' ')[0];
      proximoCambioAceiteController.text = proximoCambioAceiteController.text; //DateTime.now().toString().split(' ')[0];
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


/* void mostrarInfoDialog (
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
 */
  // --- REEMPLAZAR MÉTODO COMPLETO ---
  // Mostrar diálogo de confirmación para WhatsApp (Refactorizado)
  
  Future<void> mostrarInfoDialog(
    String accion, // "guardar" o "modificar"
    Map<String, dynamic> cliente,
    Map<String, dynamic> vehiculo,
    Map<String, dynamic> ordenServicio,
    TextEditingController fechaController,
    TextEditingController descripcionController,
    TextEditingController estadoController,
    TextEditingController fechaCambioAceiteController,
    TextEditingController proximoCambioAceiteController,
    TextEditingController estadoPagoController,
    String mensaje,
    BuildContext originalContext, // El contexto de la pantalla AgregarOrden
    GlobalKey<FormState> formKey,
  ) async {
    // Usa showDialog con el contexto original
    await showDialog(
      context: originalContext,
      barrierDismissible: false, // Evita que se cierre al tocar fuera
      builder: (BuildContext dialogContext) { // Contexto específico para el diálogo
        // No uses Provider.of aquí si no necesitas escuchar cambios DENTRO del diálogo
        // final provider = Provider.of<OrdenServicioFormProvider>(dialogContext, listen: false);

        return AlertDialog(
          title: const Text(
            "¿Quieres notificar el vehículo vía WhatsApp?",
            style: TextStyle(fontWeight: FontWeight.w200, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          actions: [
            // --- Botón Aceptar (Notificar y Guardar/Editar) ---
            TextButton(
              onPressed: () async {
                // Mostrar indicador de carga si se desea (más complejo dentro del dialog)
                bool success = false;
                // 1. Realizar la acción principal (Guardar/Editar)
                if (accion == "guardar") {
                  success = await guardarOrdenServicio( // Llama al método refactorizado
                      cliente, vehiculo, fechaController, descripcionController, estadoController,
                      fechaCambioAceiteController, proximoCambioAceiteController, estadoPagoController);
                } else if (accion == "modificar") {
                  success = await editarOrdenServicio( // Llama al método refactorizado
                      cliente, vehiculo, ordenServicio, fechaController, descripcionController, estadoController,
                      fechaCambioAceiteController, proximoCambioAceiteController, estadoPagoController);
                }

                // 2. Si fue exitoso, intentar enviar mensaje
                if (success) {
                    // Usa el contexto original o el del diálogo para SnackBar/Navegación posterior
                    // Es mejor usar el originalContext si la navegación ocurre después de cerrar.
                   await enviarMensaje(cliente['telefono'], mensaje, originalContext, vehiculo, cliente);
                }

                // 3. Cerrar el diálogo SIN IMPORTAR si el mensaje se envió (pero SÍ si la orden se guardó/editó)
                 Navigator.pop(dialogContext); // Usa el contexto del DIÁLOGO para cerrarlo

                // 4. Navegar y Mostrar SnackBar (DESPUÉS de cerrar el diálogo)
                if (success && originalContext.mounted) {
                    // Llama al helper que resetea y navega
                   _resetFormAndNavigate(formKey, fechaController, descripcionController, estadoController, fechaCambioAceiteController, proximoCambioAceiteController, estadoPagoController, originalContext, vehiculo, cliente);
                   ScaffoldMessenger.of(originalContext).showSnackBar(
                     SnackBar(content: Text('Orden ${accion == 'guardar' ? 'guardada' : 'actualizada'}. Notificación enviada.')),
                   );
                } else if (!success && originalContext.mounted) {
                   ScaffoldMessenger.of(originalContext).showSnackBar(
                     SnackBar(content: Text('Error al ${accion == 'guardar' ? 'guardar' : 'actualizar'} la orden.')),
                   );
                }
              },
              child: const Text(
                "Aceptar",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // --- Botón Cerrar (Solo Guardar/Editar, sin notificar) ---
            TextButton(
              onPressed: () async {
                 bool success = false;
                 // 1. Realizar la acción principal (Guardar/Editar)
                 if (accion == "guardar") {
                    success = await guardarOrdenServicio(
                      cliente, vehiculo, fechaController, descripcionController, estadoController,
                      fechaCambioAceiteController, proximoCambioAceiteController, estadoPagoController);
                 } else if (accion == "modificar") {
                    success = await editarOrdenServicio(
                      cliente, vehiculo, ordenServicio, fechaController, descripcionController, estadoController,
                      fechaCambioAceiteController, proximoCambioAceiteController, estadoPagoController);
                 }

                 // 2. Cerrar el diálogo
                 Navigator.pop(dialogContext); // Usa el contexto del DIÁLOGO

                 // 3. Navegar y Mostrar SnackBar (DESPUÉS de cerrar el diálogo)
                 if (success && originalContext.mounted) {
                    _resetFormAndNavigate(formKey, fechaController, descripcionController, estadoController, fechaCambioAceiteController, proximoCambioAceiteController, estadoPagoController, originalContext, vehiculo, cliente);
                    ScaffoldMessenger.of(originalContext).showSnackBar(
                      SnackBar(content: Text('Orden de servicio ${accion == 'guardar' ? 'guardada' : 'actualizada'} correctamente.')),
                    );
                 } else if (!success && originalContext.mounted) {
                    ScaffoldMessenger.of(originalContext).showSnackBar(
                      SnackBar(content: Text('Error al ${accion == 'guardar' ? 'guardar' : 'actualizar'} la orden.')),
                    );
                 }
              },
              child: const Text(
                "Cerrar", // Cambiado de "Cancelar" a "Cerrar" como en tu código original
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
  // --- FIN REEMPLAZO mostrarInfoDialog ---

  // --- AÑADIR ESTE NUEVO MÉTODO HELPER ---
  void _resetFormAndNavigate(
      GlobalKey<FormState> formKey,
      TextEditingController fechaController,
      TextEditingController descripcionController,
      TextEditingController estadoServicioController,
      TextEditingController fechaCambioAceiteController,
      TextEditingController proximoCambioAceiteController,
      TextEditingController estadoPagoController,
      BuildContext context, // Contexto de la pantalla original para navegar
      Map<String, dynamic> vehiculo,
      Map<String, dynamic> cliente,
     ) {
        // Resetear controllers y estado
        // formKey.currentState?.reset(); // Resetear validación puede ser opcional aquí
        fechaController.clear();
        descripcionController.clear();
        estadoServicioController.clear(); // Quizás setear valor por defecto?
        fechaCambioAceiteController.clear();
        proximoCambioAceiteController.clear();
        estadoPagoController.clear(); // Quizás setear valor por defecto?
        isCheckedController = false; // Resetea el estado interno del checkbox
        // No necesitas notifyListeners aquí si la navegación es inmediata

        // Navegar usando pushReplacement para volver a la lista
        // Asegúrate que OrdenesServicio exista y reciba estos parámetros
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrdenesServicio(vehiculo: vehiculo, cliente: cliente),
          ),
        );
  }
  // --- FIN AÑADIR MÉTODO HELPER ---
  
}