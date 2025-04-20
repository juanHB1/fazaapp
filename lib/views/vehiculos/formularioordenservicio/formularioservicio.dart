import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/vehiculos/vistaordendeservicio/ordenservicio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/Vehiculo/formularioservicio.provider.dart';
import 'package:flutter_application_1/views/drawer/drawe.dart';
import 'package:intl/intl.dart';

class AgregarOrden extends StatefulWidget {
  final Map<String, dynamic>? vehiculo;
  final Map<String, dynamic>? ordenServicio;
  final Map<String, dynamic>? cliente;

  const AgregarOrden({super.key, this.vehiculo, this.ordenServicio, this.cliente});

  @override
  State<AgregarOrden> createState() => _AgregarOrdenState();
}

class _AgregarOrdenState extends State<AgregarOrden> with WidgetsBindingObserver {
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController estadoServicioController = TextEditingController();
  final TextEditingController fechaCambioAceiteController = TextEditingController();
  final TextEditingController proximoCambioAceiteController = TextEditingController();
  final TextEditingController estadoPagoController = TextEditingController();
  final ValueNotifier<bool> checkboxController = ValueNotifier(false);

  final formKey = GlobalKey<FormState>();
  final DateFormat _displayFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Registrar el observer
    // Inicializa los controladores con los datos actuales del cliente
    final format = DateFormat('dd/MM/yyyy');

    fechaController.text = widget.ordenServicio?['fecha'] is Timestamp
        ? format.format(widget.ordenServicio!['fecha'].toDate())
        : widget.ordenServicio?['fecha'] ?? '';

    descripcionController.text = widget.ordenServicio?['descripcion'] ?? '';
    estadoServicioController.text = widget.ordenServicio?['estadoServicio'] ?? '';
    fechaCambioAceiteController.text = widget.ordenServicio?['fechaCambioAceite'] is Timestamp
        ? format.format(widget.ordenServicio!['fechaCambioAceite'].toDate())
        : widget.ordenServicio?['fechaCambioAceite'] ?? '';

    proximoCambioAceiteController.text = widget.ordenServicio?['proximoCambioAceite'] is Timestamp
        ? format.format(widget.ordenServicio!['proximoCambioAceite'].toDate())
        : widget.ordenServicio?['proximoCambioAceite'] ?? '';

    estadoPagoController.text = widget.ordenServicio?['estadoPago'] ?? '';
    checkboxController.value = widget.ordenServicio?['estadoChecked'] ?? false;

    Future.microtask(() {
      Provider.of<OrdenServicioFormProvider>(context, listen: false).verificarEstadoCheckSelector(
        checkboxController.value,
        context,
        formKey,
        fechaCambioAceiteController,
        proximoCambioAceiteController,
      );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Desregistrar el observer
    fechaController.dispose();
    descripcionController.dispose();
    estadoServicioController.dispose();
    fechaCambioAceiteController.dispose();
    proximoCambioAceiteController.dispose();
    estadoPagoController.dispose();
    checkboxController.dispose(); // Dispose the ValueNotifier
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        final provider = Provider.of<OrdenServicioFormProvider>(context, listen: false);
        if (provider.volviendoDeWhatsApp) {
          // Acción específica al volver de WhatsApp
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrdenesServicio(vehiculo: widget.vehiculo, cliente: widget.cliente),
            ),
          );
          provider.volviendoDeWhatsApp = false; // Resetea la bandera
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // Handle other states if necessary
        break;
    }
  }

  // Método para mostrar el selector de fecha
  Future<void> _seleccionarFecha(
      BuildContext context, TextEditingController controller) async {
    DateTime initialDate = DateTime.now(); // Por defecto, la fecha actual

    // Intenta parsear la fecha actual del controlador si existe y tiene el formato esperado
    if (controller.text.isNotEmpty) {
      try {
        // Usa parseStrict para asegurar que el formato sea exactamente dd/MM/yyyy
        initialDate = _displayFormat.parseStrict(controller.text);
      } on FormatException {
        // Si el formato no es correcto, usa la fecha actual
        initialDate = DateTime.now();
      } catch (e) {
        // Otro error inesperado durante el parseo
        initialDate = DateTime.now();
      }
    }

    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: initialDate, // Usa la fecha parseada o la actual
      firstDate: DateTime(1900), // Rango de fechas permitido
      lastDate: DateTime(2101), // Rango de fechas permitido (ajusta si es necesario)
      locale: const Locale('es', 'ES'), // Asegura la localización en español
    );

    if (fechaSeleccionada != null) {
      // Formatea la fecha seleccionada usando el formato consistente y actualiza el controlador
      controller.text = _displayFormat.format(fechaSeleccionada.toLocal());
      // No se necesita setState aquí, el TextFormField se actualiza automáticamente por el controller
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordenServicioProvider = Provider.of<OrdenServicioFormProvider>(context);

    bool esEdicion = widget.ordenServicio != null;

    return PopScope(
      canPop: false, // Bloquea el botón "Atrás"
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Aquí podrías añadir una confirmación antes de salir si el formulario tiene cambios
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey[50],
        //barra de navegacion superior
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey[900], // Color oscuro elegante
          elevation: 4,
          shadowColor: Colors.black45,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Added to center the row content
            children: [
              Icon(Icons.car_repair, color: Colors.amber, size: 28), // Ícono llamativo
              SizedBox(width: 8),
              //texto con el nombre de la empresa e icono
              Flexible( // Wrap Text in Flexible to prevent overflow
                child: Text(
                  "Faza Ingeniería",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2, // Espaciado para mejor estética
                  ),
                  overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                ),
              ),
            ],
          ),
          centerTitle: true,
          //icono para abrir el drawer( panel izquierdo )
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white), // 🔙 Botón de atrás
            tooltip: "Volver", // Added tooltip
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrdenesServicio(
                      vehiculo: widget.vehiculo,
                      cliente: widget.cliente as Map<String, dynamic>),
                ),
              );
            },
          ),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 28), // ☰ Menú
                  tooltip: "Abrir menú",
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
          ],
        ),
        drawer: CustomDrawer(),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center column content vertically
                crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch column children horizontally
                children: [
                  // Tarjeta con el formulario
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icono y título
                            Icon(Icons.description_outlined, size: 60, color: Colors.blueGrey), // Changed icon to reflect "service order"
                            const SizedBox(height: 10),
                            Text(
                              esEdicion
                                  ? "Editar orden servicio"
                                  : "Registrar orden servicio",
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 45, 43, 43)),
                            ),
                            const SizedBox(height: 20),

                            // Campo de fecha
                            TextFormField(
                              controller: fechaController,
                              decoration: InputDecoration(
                                labelText: "Fecha del servicio",
                                prefixIcon: Icon(Icons.calendar_today,
                                    color: Colors.blueGrey),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: 'DD/MM/YYYY', // Added hint
                              ),
                              readOnly: true,
                              onTap: () =>
                                  _seleccionarFecha(context, fechaController),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Por favor, seleccione una fecha";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 10),

                            // Campo de descripción
                            TextFormField(
                              controller: descripcionController,
                              decoration: InputDecoration(
                                labelText: "Descripción del servicio", // Improved label text
                                prefixIcon: Icon(Icons.notes, // Changed icon
                                    color: Colors.blueGrey),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                alignLabelWithHint: true,
                                hintText: 'Detalles del servicio realizado', // Added hint
                              ),
                              maxLines: 5, // Permite varias líneas de texto
                              keyboardType: TextInputType.multiline, // Teclado adecuado para texto largo
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Por favor, ingrese la descripción del reporte.";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 10),

                            SizedBox(
                              child: ValueListenableBuilder<bool>(
                                valueListenable: checkboxController,
                                builder: (context, value, _) {
                                  return CheckboxListTile(
                                    title: const Text(
                                      "¿Cambio de aceite realizado?",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    value: value,
                                    activeColor: Colors.green, // Color cuando está marcado
                                    checkColor: Colors.white, // Color del ✔
                                    contentPadding: EdgeInsets.zero,
                                    onChanged: (nuevoValor) {
                                      ordenServicioProvider.verificarEstadoCheckSelector(
                                          nuevoValor,
                                          context,
                                          formKey,
                                          fechaCambioAceiteController,
                                          proximoCambioAceiteController);
                                      checkboxController.value = nuevoValor!;
                                    },
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Campos de fecha de cambio de aceite y próximo cambio de aceite
                            ValueListenableBuilder<bool>( // Use ValueListenableBuilder to rebuild when checkbox changes
                              valueListenable: checkboxController,
                              builder: (context, isOilChangeChecked, child) {
                                if (!isOilChangeChecked) {
                                  // Clear the date fields if the checkbox is unchecked
                                  fechaCambioAceiteController.clear();
                                  proximoCambioAceiteController.clear();
                                  return const SizedBox.shrink(); // Hide the fields
                                }
                                return Column(
                                  children: [
                                    TextFormField(
                                      controller: fechaCambioAceiteController,
                                      decoration: InputDecoration(
                                        labelText: "Fecha de cambio de aceite",
                                        prefixIcon: Icon(Icons.oil_barrel, // Changed icon
                                            color: Colors.blueGrey),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        hintText: 'DD/MM/YYYY', // Added hint
                                      ),
                                      readOnly: true,
                                      onTap: () => _seleccionarFecha(
                                          context, fechaCambioAceiteController),
                                      validator: (value) {
                                        if (checkboxController.value && (value == null || value.isEmpty)) {
                                          return "Por favor, seleccione una fecha";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: proximoCambioAceiteController,
                                      decoration: InputDecoration(
                                        labelText: "Próximo cambio de aceite",
                                        prefixIcon: Icon(Icons.access_time, // Changed icon
                                            color: Colors.blueGrey),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        hintText: 'DD/MM/YYYY', // Added hint
                                      ),
                                      readOnly: true,
                                      onTap: () => _seleccionarFecha(
                                          context, proximoCambioAceiteController),
                                      validator: (value) {
                                         if (checkboxController.value && (value == null || value.isEmpty)) {
                                          return "Por favor, seleccione una fecha";
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),


                            const SizedBox(height: 10),

                            //Campo de estado de pago
                            DropdownButtonFormField<String>(
                              value: estadoPagoController.text.isNotEmpty
                                  ? estadoPagoController.text
                                  : null,
                              hint: const Text("Estado de pago"),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                prefixIcon: Icon(Icons.payment, color: Colors.blueGrey), // Added icon
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  estadoPagoController.text = newValue ?? "";
                                });
                              },
                              validator: (value) => value == null || value.isEmpty
                                  ? "Seleccione un estado de pago"
                                  : null,
                              items: ["Pagado", "Pendiente"].map((String estado) {
                                return DropdownMenuItem<String>(
                                  value: estado,
                                  child: Text(estado),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 10),

                             // Dropdown para seleccionar el estado del servicio
                            DropdownButtonFormField<String>(
                              value: estadoServicioController.text.isNotEmpty
                                  ? estadoServicioController.text
                                  : null,
                              hint: const Text("Estado del servicio"),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                prefixIcon: Icon(Icons.build_circle_outlined, color: Colors.blueGrey), // Added icon
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  estadoServicioController.text = newValue ?? "";
                                });
                              },
                              validator: (value) => value == null || value.isEmpty
                                  ? "Seleccione un estado del servicio"
                                  : null,
                              items: ordenServicioProvider.optionsOrdenServicios
                                  .map((String role) {
                                return DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 20),

                            // Botón de registro
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Colors.blueGrey,
                                  foregroundColor: Colors.white, // Text color
                                ),
                                onPressed: ordenServicioProvider.loading
                                    ? null // Disable button while loading
                                    : () {
                                  if (formKey.currentState!.validate()) {
                                    switch (esEdicion) {
                                      case true:
                                        ordenServicioProvider.verificar(
                                          "modificar",
                                          widget.cliente!,
                                          widget.vehiculo!,
                                          widget.ordenServicio!,
                                          fechaController,
                                          descripcionController,
                                          estadoServicioController,
                                          context,
                                          formKey,
                                          fechaCambioAceiteController,
                                          proximoCambioAceiteController,
                                          estadoPagoController,
                                        );
                                        break;
                                      case false:
                                        ordenServicioProvider.verificar(
                                          "guardar",
                                          widget.cliente!,
                                          widget.vehiculo!,
                                          <String, dynamic>{}, // Pass empty map for new order
                                          fechaController,
                                          descripcionController,
                                          estadoServicioController,
                                          context,
                                          formKey,
                                          fechaCambioAceiteController,
                                          proximoCambioAceiteController,
                                          estadoPagoController,
                                        );
                                        break;
                                    }
                                  }
                                },
                                child: ordenServicioProvider.loading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : Text(esEdicion ? "Actualizar" : "Registrar",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white)),
                              ),
                            ),

                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}