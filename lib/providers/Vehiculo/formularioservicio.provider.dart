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
   
  ) async {
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
      loading = false;
      notifyListeners();
      return false; // Indica fallo
    }
  }

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
  ) async {

     bool showDialogAndNotify = false;
     String mensajeWhatsApp = "";

     if (accion == "guardar" && estadoController.text == "ingresado") {
       showDialogAndNotify = true;
       mensajeWhatsApp = "Hola ${cliente['nombre'] ?? 'Cliente'}, su vehículo ${vehiculo['marca'] ?? ''} ${vehiculo['modelo'] ?? ''} placa ${vehiculo['placa'] ?? ''} ha sido ingresado a la orden.";
     } else if (accion == "modificar" && estadoController.text == "terminado") {
        showDialogAndNotify = true;
        mensajeWhatsApp = "Hola ${cliente['nombre'] ?? 'Cliente'}, su vehículo ${vehiculo['marca'] ?? ''} ${vehiculo['modelo'] ?? ''} placa ${vehiculo['placa'] ?? ''} está listo para ser recogido.";
     }

     if (showDialogAndNotify) {
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
  ) async {
    loading = true;
    notifyListeners();

    try {
      String vehiculoId = vehiculo['uid'];
      String ordenServicioId = ordenServicio['uid'];

      Timestamp? fechaTS;
      dynamic fechaAceiteValor;
      dynamic proximoAceiteValor;
      try {
        if (fechaController.text.trim().isNotEmpty) {
          fechaTS = Timestamp.fromDate(_dbFormat.parseStrict(fechaController.text.trim()));
        }

        if (isCheckedController) {
           fechaAceiteValor = fechaCambioAceiteController.text.trim().isNotEmpty
               ? Timestamp.fromDate(_dbFormat.parseStrict(fechaCambioAceiteController.text.trim()))
               : "";
           proximoAceiteValor = proximoCambioAceiteController.text.trim().isNotEmpty
               ? Timestamp.fromDate(_dbFormat.parseStrict(proximoCambioAceiteController.text.trim()))
               : "";
        }

      } catch (e) {
        // Error parsing dates, will attempt to save null/empty
      }

      // Prepara los datos a actualizar
      Map<String, dynamic> dataToUpdate = {
            "fecha": fechaTS,
            "descripcion": descripcionController.text.trim(),
            "estadoServicio": estadoServicioController.text.trim(),
            "estadoPago": estadoPagoController.text.trim(),
            "estadoChecked": isCheckedController,
            "fechaCambioAceite": fechaAceiteValor,
            "proximoCambioAceite": proximoAceiteValor,
       };

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(cliente['uid'])
          .collection('vehiculos')
          .doc(vehiculoId)
          .collection('ordenServicio')
          .doc(ordenServicioId)
          .update(dataToUpdate);

      loading = false;
      notifyListeners();
      return true;

    } catch (e) {
      loading = false;
      notifyListeners();
      return false;
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
      package: "com.whatsapp",
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );

    volviendoDeWhatsApp = true;
    await intent.launch();

  } catch (e) {
    // Error handling can be added here if needed, but user requested to remove debug prints
  }
}
  
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
  
}