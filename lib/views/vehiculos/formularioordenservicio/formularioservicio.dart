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

class _AgregarOrdenState extends State<AgregarOrden> {

  final TextEditingController fechaController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? selectedOption; //opcion seleccionada

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos actuales del cliente
    fechaController.text = widget.ordenServicio?['fecha'] ?? '';
    descripcionController.text = widget.ordenServicio?['descripcion'] ?? '';
    estadoController.text = widget.ordenServicio?['estado'] ?? '';

    if (widget.ordenServicio?['estado'] != null) {
      selectedOption = widget.ordenServicio!['estado'];
    }

    debugPrint("variable vehiculo: 👉 ${widget.vehiculo}");
    debugPrint("variable orden servicio: 👉 ${widget.ordenServicio}");
    debugPrint("variable orden cliente: 👉 ${widget.cliente}");
  }

  // Método para mostrar el selector de fecha
  Future<void> _seleccionarFecha(BuildContext context) async {
      // Convertir el texto del controlador a un objeto DateTime si es válido
      DateTime? fechaInicial;
      if (fechaController.text.isNotEmpty) {
        try {
          fechaInicial = DateTime.parse(fechaController.text);
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
        fechaController.text = fechaSeleccionada.toLocal().toString().split(' ')[0];
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
                                            onTap: () => _seleccionarFecha(context),
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
                                                      ordenServicioProvider.editarOrdenServicio(
                                                        widget.cliente!,
                                                        widget.vehiculo!,
                                                        widget.ordenServicio!,
                                                        fechaController,
                                                        descripcionController,
                                                        estadoController,
                                                        context, 
                                                        formKey);
                                                      break;
                                                    case false:
                                                      debugPrint("variable esEdicion en false: 👉 ${widget.ordenServicio}");
                                                      ordenServicioProvider.guardarOrdenServicio(
                                                        widget.cliente!,
                                                        widget.vehiculo!,
                                                        fechaController,
                                                        descripcionController,
                                                        estadoController,
                                                        context, 
                                                        formKey);
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
