/* import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/vehiculos/vistaordendeservicio/ordenservicio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/Vehiculo/formularioservicio.provider.dart';
import 'package:flutter_application_1/views/drawer/drawe.dart';


class AgregarOrden extends StatefulWidget {
  final Map<String, dynamic>? vehiculo;
  final Map<String, dynamic>? ordenServicio;
  final Map<String, dynamic>? cliente;

  const AgregarOrden({super.key, this.vehiculo, this.ordenServicio, this.cliente});

  @override
  State<AgregarOrden> createState() => _AgregarOrdenState();
}

class _AgregarOrdenState extends State<AgregarOrden> {

  final TextEditingController fechaController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController fechaCambioAceiteController = TextEditingController();
  final TextEditingController proximoCambioAceiteController = TextEditingController();
  final TextEditingController estadoPagoController = TextEditingController();
  

  final formKey = GlobalKey<FormState>();
  String? selectedOption; //opcion seleccionada

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos actuales del cliente
    fechaController.text = widget.ordenServicio?['fecha'] ?? '';
    descripcionController.text = widget.ordenServicio?['descripcion'] ?? '';
    estadoController.text = widget.ordenServicio?['estado'] ?? '';
    fechaCambioAceiteController.text = widget.ordenServicio?['fechaCambioAceite'] ?? '';
    proximoCambioAceiteController.text = widget.ordenServicio?['proximoCambioAceite'] ?? '';
    estadoPagoController.text = widget.ordenServicio?['estadoPago'] ?? '';
    if (widget.ordenServicio?['estado'] != null) {
      selectedOption = widget.ordenServicio!['estado'];
    }

    debugPrint("variable vehiculo: 👉 ${widget.vehiculo}"); 
    debugPrint("variable orden servicio: 👉 ${widget.ordenServicio}");
    debugPrint("variable orden cliente: 👉 ${widget.cliente}");
  }

// Método para mostrar el selector de fecha
Future<void> _seleccionarFecha(BuildContext context, TextEditingController controller) async {
  // Convertir el texto del controlador a un objeto DateTime si es válido
  DateTime? fechaInicial;
  if (controller.text.isNotEmpty) {
    try {
      fechaInicial = DateTime.parse(controller.text);
    } catch (e) {
      fechaInicial = DateTime.now(); // Si hay un error, usar la fecha actual
    }
  } else {
    fechaInicial = DateTime.now();
  }

  DateTime? fechaSeleccionada = await showDatePicker(
    context: context,
    initialDate: fechaInicial,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
    locale: Locale('es', 'ES'),
  );

  if (fechaSeleccionada != null) {
    setState(() {
      controller.text = fechaSeleccionada.toLocal().toString().split(' ')[0];
    });
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
                children: [
                  Icon(Icons.car_repair, color: Colors.amber, size: 28), // Ícono llamativo
                  SizedBox(width: 8),
                  //texto con el nombre de la empresa e icono
                  Text(
                    "Faza Ingeniería", 
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white,
                      letterSpacing: 1.2, // Espaciado para mejor estética
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              //icono para abrir el drawer( panel izquierdo )
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white), // 🔙 Botón de atrás
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrdenesServicio(vehiculo: widget.vehiculo ,cliente: widget.cliente as Map<String, dynamic>)
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
                              children: [
                                
                                // Tarjeta con el formulario
                                Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Icono y título
                                          Icon(Icons.person, size: 60, color: Colors.blueGrey),
                                          const SizedBox(height: 10),
                                          Text(
                                            esEdicion ? "Editar orden servicio" : "Registrar orden servicio",
                                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 45, 43, 43)),
                                          ),
                                          const SizedBox(height: 20),
                                
                                          // Campo de fecha
                                          TextFormField(
                                            controller: fechaController,
                                            decoration: InputDecoration(
                                              labelText: "Fecha del servicio",
                                              prefixIcon: Icon(Icons.calendar_today, color: Colors.blueGrey),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                            ),
                                            readOnly: true,
                                            onTap: () => _seleccionarFecha(context, fechaController),
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
                                              labelText: "Descripción",
                                              prefixIcon: Icon(Icons.person_outline, color: Colors.blueGrey),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                              alignLabelWithHint: true,
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
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Checkbox(
                                                  value: ordenServicioProvider.isCheckedController,
                                                  activeColor: Colors.green, // Color cuando está marcado
                                                  checkColor: Colors.white, // Color de la marca ✔
                                                  onChanged: (bool? value) {
                                                    ordenServicioProvider.verificarEstadoCheckSelector(value, context, formKey, fechaCambioAceiteController, proximoCambioAceiteController);
                                                  },
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  "¿Cambio de aceite realizado?",
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          // Campo de fecha de cambio de aceite
                                          
                                          Column(
                                            children: [
                                              if (ordenServicioProvider.isCheckedController)
                                                TextFormField(
                                                  controller: fechaCambioAceiteController,
                                                  decoration: InputDecoration(
                                                    labelText: "Fecha de cambio de aceite",
                                                    prefixIcon: Icon(Icons.calendar_today, color: Colors.blueGrey),
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                                  ),
                                                  readOnly: true,
                                                  onTap: () => _seleccionarFecha(context, fechaCambioAceiteController),
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return "Por favor, seleccione una fecha";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              if (ordenServicioProvider.isCheckedController)
                                                const SizedBox(height: 10),
                                              if (ordenServicioProvider.isCheckedController)
                                                TextFormField(
                                                  controller: proximoCambioAceiteController,
                                                  decoration: InputDecoration(
                                                    labelText: "Próximo cambio de aceite",
                                                    prefixIcon: Icon(Icons.calendar_today, color: Colors.blueGrey),
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                                  ),
                                                  readOnly: true,
                                                  onTap: () => _seleccionarFecha(context, proximoCambioAceiteController),
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return "Por favor, seleccione una fecha";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              if (ordenServicioProvider.isCheckedController)
                                                const SizedBox(height: 10),
                                              // Otros widgets que no dependen de la condición...
                                            ],
                                          ),

                                           //Campo de estado de pago

                                          DropdownButtonFormField<String>(
                                          value: estadoPagoController.text.isNotEmpty ? estadoPagoController.text : null,
                                          hint: const Text("Seleccione el estado de pago"),
                                          onChanged: (newValue) {
                                            setState(() {
                                              estadoPagoController.text = newValue ?? "";
                                            });
                                          },
                                          validator: (value) => value == null || value.isEmpty ? "Seleccione un estado de pago" : null,
                                          items: ["Pagado", "Pendiente"].map((String estado) {
                                            return DropdownMenuItem<String>(
                                              value: estado,
                                              child: Text(estado),
                                            );
                                          }).toList(),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                          ),
                                        ),

                                        const SizedBox(height: 10),


                                            const SizedBox(height: 10),
                                        // Dropdown para seleccionar el estado
                                          DropdownButtonFormField<String>(
                                            value: selectedOption,
                                            hint: const Text("Seleccione el estado del servicio"),
                                            onChanged: (newValue) {
                                              setState(() {
                                                selectedOption = newValue;
                                                estadoController.text = newValue ?? "";
                                              });
                                            },
                                            validator: (value) => value == null || value.isEmpty ? "Seleccione un rol" : null,
                                            items: ordenServicioProvider.optionsDropDownList.map((String role) {
                                              return DropdownMenuItem<String>(
                                                value: role,
                                                child: Text(role),
                                              );
                                            }).toList(),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                            ),
                                          ),
                                
                                          const SizedBox(height: 20),
                                
                                          // Botón de registro
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(vertical: 14),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                backgroundColor: Colors.blueGrey,
                                              ),
                                              
                                              onPressed: () {
                                                if (formKey.currentState!.validate()) {
                                                switch (esEdicion) {
                                                  case true:
                                                    debugPrint("variable esEdicion en true: 👉 ${widget.ordenServicio}");
                                                    ordenServicioProvider.verificar(
                                                      "modificar",
                                                      widget.cliente!,
                                                      widget.vehiculo!,
                                                      widget.ordenServicio!,
                                                      fechaController,
                                                      descripcionController,
                                                      estadoController,
                                                      context,
                                                      formKey,
                                                      fechaCambioAceiteController, // Asegurarse de pasar este controlador
                                                      proximoCambioAceiteController, // Asegurarse de pasar este controlador
                                                      estadoPagoController, // Asegurarse de pasar este controlador
                                                    );
                                                    /* ordenServicioProvider.editarOrdenServicio(
                                                      widget.cliente!,
                                                      widget.vehiculo!,
                                                      widget.ordenServicio!,
                                                      fechaController,
                                                      descripcionController,
                                                      estadoController,
                                                      context,
                                                      formKey,
                                                      fechaCambioAceiteController, // Asegurarse de pasar este controlador
                                                      proximoCambioAceiteController, // Asegurarse de pasar este controlador
                                                      estadoPagoController, // Asegurarse de pasar este controlador
                                                    
                                                    ); */
                                                    break;
                                                  case false:
                                                    debugPrint("variable esEdicion en false: 👉 ${widget.ordenServicio}");
                                                    ordenServicioProvider.verificar(
                                                      "guardar",
                                                      widget.cliente!,
                                                      widget.vehiculo!,
                                                      <String, dynamic>{},
                                                      fechaController,
                                                      descripcionController,
                                                      estadoController,
                                                      context,
                                                      formKey,
                                                      fechaCambioAceiteController, // Asegurarse de pasar este controlador
                                                      proximoCambioAceiteController, // Asegurarse de pasar este controlador
                                                      estadoPagoController, // Asegurarse de pasar este controlador
                                                    );
                                                    /* ordenServicioProvider.guardarOrdenServicio(
                                                      widget.cliente!,
                                                      widget.vehiculo!,
                                                      fechaController,
                                                      descripcionController,
                                                      estadoController,
                                                      context,
                                                      formKey,
                                                      fechaCambioAceiteController, // Asegurarse de pasar este controlador
                                                      proximoCambioAceiteController, // Asegurarse de pasar este controlador
                                                      estadoPagoController, // Asegurarse de pasar este controlador
                                                    ); */
                                                    break;
                                                }
                                              }
                                            },
                                              child: ordenServicioProvider.loading ?
                                              const SizedBox(
                                                height: 24,
                                                width: 24,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 3,
                                                ),
                                              ) :
                                              Text(esEdicion ? "Actualizar" : "Registrar", style: TextStyle(fontSize: 18, color: Colors.white)),
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
 */


import 'package:flutter/material.dart';
import 'package:flutter_application_1/views/vehiculos/vistaordendeservicio/ordenservicio.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/Vehiculo/formularioservicio.provider.dart';
import 'package:flutter_application_1/views/drawer/drawe.dart';

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
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController fechaCambioAceiteController = TextEditingController();
  final TextEditingController proximoCambioAceiteController = TextEditingController();
  final TextEditingController estadoPagoController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  String? selectedOption; //opcion seleccionada


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Registrar el observer
    // Inicializa los controladores con los datos actuales del cliente
    fechaController.text = widget.ordenServicio?['fecha'] ?? '';
    descripcionController.text = widget.ordenServicio?['descripcion'] ?? '';
    estadoController.text = widget.ordenServicio?['estado'] ?? '';
    fechaCambioAceiteController.text = widget.ordenServicio?['fechaCambioAceite'] ?? '';
    proximoCambioAceiteController.text = widget.ordenServicio?['proximoCambioAceite'] ?? '';
    estadoPagoController.text = widget.ordenServicio?['estadoPago'] ?? '';
    if (widget.ordenServicio?['estado'] != null) {
      selectedOption = widget.ordenServicio!['estado'];
    }

    debugPrint("variable vehiculo: 👉 ${widget.vehiculo}");
    debugPrint("variable orden servicio: 👉 ${widget.ordenServicio}");
    debugPrint("variable orden cliente: 👉 ${widget.cliente}");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Desregistrar el observer
    fechaController.dispose();
    descripcionController.dispose();
    estadoController.dispose();
    fechaCambioAceiteController.dispose();
    proximoCambioAceiteController.dispose();
    estadoPagoController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      
      case AppLifecycleState.resumed:
        // Usar listen: false es importante al llamar a Provider fuera del método build
        // o dentro de callbacks como initState, didChangeDependencies o didChangeAppLifecycleState
        // si solo necesitas leer el valor o llamar un método una vez.
        final provider = Provider.of<OrdenServicioFormProvider>(context, listen: false);
        if (provider.volviendoDeWhatsApp) {
          debugPrint("App resumed y volviendoDeWhatsApp es true. Navegando a OrdenesServicio...");
          // 🔹 Acción específica al volver de WhatsApp (o lo que sea que active el flag)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrdenesServicio(vehiculo: widget.vehiculo, cliente: widget.cliente),
            ),
          );
          provider.volviendoDeWhatsApp = false; // Resetea la bandera
        } else {
          debugPrint("App resumed, pero volviendoDeWhatsApp es false.");
        }
        // Aquí podrías poner código que SIEMPRE se ejecuta al reanudar la app,
        // independientemente del flag. Por ejemplo, refrescar datos.
      break;
      // ... otros casos (inactive, paused, detached, hidden)
      // Es bueno tener logs para entender el flujo si es necesario.
      case AppLifecycleState.inactive:
        print("App in inactive state");
        break;
      case AppLifecycleState.paused:
        print("App in paused state"); // La app pasa a segundo plano
        break;
      case AppLifecycleState.detached:
        print("App in detached state"); // El engine de Flutter se está desconectando (raro en móviles)
        break;
      case AppLifecycleState.hidden:
         print("App in hidden state"); // Nuevo estado, similar a paused pero puede no ser visible en absoluto.
        break;
    }
  }

   // Método para mostrar el selector de fecha
  Future<void> _seleccionarFecha(
      BuildContext context, TextEditingController controller) async {
    // Convertir el texto del controlador a un objeto DateTime si es válido
    DateTime? fechaInicial;
    if (controller.text.isNotEmpty) {
      try {
        fechaInicial = DateTime.parse(controller.text);
      } catch (e) {
        fechaInicial = DateTime.now(); // Si hay un error, usar la fecha actual
      }
    } else {
      fechaInicial = DateTime.now();
    }

    DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: fechaInicial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: Locale('es', 'ES'),
    );

    if (fechaSeleccionada != null) {
      setState(() {
        controller.text = fechaSeleccionada.toLocal().toString().split(' ')[0];
      });
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
            children: [
              Icon(Icons.car_repair, color: Colors.amber, size: 28), // Ícono llamativo
              SizedBox(width: 8),
              //texto con el nombre de la empresa e icono
              Text(
                "Faza Ingeniería",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2, // Espaciado para mejor estética
                ),
              ),
            ],
          ),
          centerTitle: true,
          //icono para abrir el drawer( panel izquierdo )
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white), // 🔙 Botón de atrás
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
                            Icon(Icons.person, size: 60, color: Colors.blueGrey),
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
                                labelText: "Descripción",
                                prefixIcon: Icon(Icons.person_outline,
                                    color: Colors.blueGrey),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                alignLabelWithHint: true,
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: ordenServicioProvider.isCheckedController,
                                    activeColor:
                                        Colors.green, // Color cuando está marcado
                                    checkColor: Colors.white, // Color de la marca ✔
                                    onChanged: (bool? value) {
                                      ordenServicioProvider.verificarEstadoCheckSelector(
                                          value,
                                          context,
                                          formKey,
                                          fechaCambioAceiteController,
                                          proximoCambioAceiteController);
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "¿Cambio de aceite realizado?",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Campo de fecha de cambio de aceite

                            Column(
                              children: [
                                if (ordenServicioProvider.isCheckedController)
                                  TextFormField(
                                    controller: fechaCambioAceiteController,
                                    decoration: InputDecoration(
                                      labelText: "Fecha de cambio de aceite",
                                      prefixIcon: Icon(Icons.calendar_today,
                                          color: Colors.blueGrey),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    readOnly: true,
                                    onTap: () => _seleccionarFecha(
                                        context, fechaCambioAceiteController),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Por favor, seleccione una fecha";
                                      }
                                      return null;
                                    },
                                  ),
                                if (ordenServicioProvider.isCheckedController)
                                  const SizedBox(height: 10),
                                if (ordenServicioProvider.isCheckedController)
                                  TextFormField(
                                    controller: proximoCambioAceiteController,
                                    decoration: InputDecoration(
                                      labelText: "Próximo cambio de aceite",
                                      prefixIcon: Icon(Icons.calendar_today,
                                          color: Colors.blueGrey),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    readOnly: true,
                                    onTap: () => _seleccionarFecha(
                                        context, proximoCambioAceiteController),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Por favor, seleccione una fecha";
                                      }
                                      return null;
                                    },
                                  ),
                                if (ordenServicioProvider.isCheckedController)
                                  const SizedBox(height: 10),
                                // Otros widgets que no dependen de la condición...
                              ],
                            ),

                            //Campo de estado de pago

                            DropdownButtonFormField<String>(
                              value: estadoPagoController.text.isNotEmpty
                                  ? estadoPagoController.text
                                  : null,
                              hint: const Text("Seleccione el estado de pago"),
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
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                              ),
                            ),

                            const SizedBox(height: 10),

                            const SizedBox(height: 10),
                            // Dropdown para seleccionar el estado
                            DropdownButtonFormField<String>(
                              value: selectedOption,
                              hint: const Text("Seleccione el estado del servicio"),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedOption = newValue;
                                  estadoController.text = newValue ?? "";
                                });
                              },
                              validator: (value) => value == null || value.isEmpty
                                  ? "Seleccione un rol"
                                  : null,
                              items: ordenServicioProvider.optionsDropDownList
                                  .map((String role) {
                                return DropdownMenuItem<String>(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                              ),
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
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    switch (esEdicion) {
                                      case true:
                                        debugPrint(
                                            "variable esEdicion en true: 👉 ${widget.ordenServicio}");
                                        ordenServicioProvider.verificar(
                                          "modificar",
                                          widget.cliente!,
                                          widget.vehiculo!,
                                          widget.ordenServicio!,
                                          fechaController,
                                          descripcionController,
                                          estadoController,
                                          context,
                                          formKey,
                                          fechaCambioAceiteController,
                                          proximoCambioAceiteController,
                                          estadoPagoController,
                                        );
                                        /* ordenServicioProvider.editarOrdenServicio(
                                          widget.cliente!,
                                          widget.vehiculo!,
                                          widget.ordenServicio!,
                                          fechaController,
                                          descripcionController,
                                          estadoController,
                                          context,
                                          formKey,
                                          fechaCambioAceiteController, // Asegurarse de pasar este controlador
                                          proximoCambioAceiteController, // Asegurarse de pasar este controlador
                                          estadoPagoController, // Asegurarse de pasar este controlador
                                        ); */
                                        break;
                                      case false:
                                        debugPrint(
                                            "variable esEdicion en false: 👉 ${widget.ordenServicio}");
                                        ordenServicioProvider.verificar(
                                          "guardar",
                                          widget.cliente!,
                                          widget.vehiculo!,
                                          <String, dynamic>{},
                                          fechaController,
                                          descripcionController,
                                          estadoController,
                                          context,
                                          formKey,
                                          fechaCambioAceiteController,
                                          proximoCambioAceiteController,
                                          estadoPagoController,
                                        );
                                        /* ordenServicioProvider.guardarOrdenServicio(
                                          widget.cliente!,
                                          widget.vehiculo!,
                                          fechaController,
                                          descripcionController,
                                          estadoController,
                                          context,
                                          formKey,
                                          fechaCambioAceiteController, // Asegurarse de pasar este controlador
                                          proximoCambioAceiteController, // Asegurarse de pasar este controlador
                                          estadoPagoController, // Asegurarse de pasar este controlador
                                        ); */
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