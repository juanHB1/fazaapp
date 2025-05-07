import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/Vehiculo/vehiculo.provider.dart';
import 'package:flutter_application_1/views/drawer/drawe.dart';
import 'package:flutter_application_1/views/vehiculos/listaVehiculos/vehiculo.dart';
import 'package:provider/provider.dart';

class FormularioVehiculo extends StatefulWidget {
  final Map<String, dynamic>? cliente;
  final Map<String, dynamic>? vehiculo;
  const FormularioVehiculo({super.key, this.cliente, this.vehiculo});

  @override
  State<FormularioVehiculo> createState() => _FormularioVehiculoState();
}

class _FormularioVehiculoState extends State<FormularioVehiculo> {
  final TextEditingController marcaController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController kilometrajeEntradaController = TextEditingController();
  final TextEditingController tipoCombustibleController = TextEditingController();
  //final TextEditingController numeroChasisController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    marcaController.text = widget.vehiculo?['marca'] ?? '';
    modeloController.text = widget.vehiculo?['modelo'] ?? '';
    placaController.text = widget.vehiculo?['placa'] ?? '';
    colorController.text = widget.vehiculo?['color'] ?? '';
    kilometrajeEntradaController.text = widget.vehiculo?['kilometrajeEntrada'] ?? '';
    tipoCombustibleController.text = widget.vehiculo?['tipoCombustible'] ?? '';
    //numeroChasisController.text = widget.vehiculo?['numeroChasis'] ?? '';

    Future.microtask(() {
      final provider = Provider.of<VehiculoProvider>(context, listen: false);
      provider.obtenerPlacasExistentes();
    });

    
  }

  @override
  Widget build(BuildContext context) {
    bool esEdicion = widget.vehiculo != null;
    final vehiculoProvider = Provider.of<VehiculoProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          elevation: 4,
          shadowColor: Colors.black45,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.car_repair, color: const Color.fromARGB(255, 255, 7, 7), size: 28),
              SizedBox(width: 8),
              Text(
                "Faza Ingeniería",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Vehiculo(cliente: widget.cliente as Map<String, dynamic>),
                ),
              );
            },
          ),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 28),
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
                            Icon(Icons.person, size: 60, color: const Color.fromARGB(255, 0, 0, 0)),
                            const SizedBox(height: 10),
                            Text(
                              esEdicion ? "Editar vehículo" : "Registrar vehículo",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            const SizedBox(height: 20),
                            buildTextFormField(
                              controller: marcaController,
                              label: "Marca",
                              icon: Icons.directions_car,
                              validatorMsg: "Por favor, ingrese la marca del vehículo",
                            ),
                            const SizedBox(height: 10),
                            buildTextFormField(
                              controller: modeloController,
                              label: "Modelo",
                              icon: Icons.build,
                              validatorMsg: "Por favor, ingrese el modelo del vehículo",
                              additionalValidator: (value) {
                                if (value != null && !RegExp(r'^\d+$').hasMatch(value)) {
                                  return "El modelo debe contener solo números";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            buildTextFormField(
                              controller: placaController,
                              label: "Placa",
                              icon: Icons.confirmation_number,
                              validatorMsg: "Por favor, ingrese la placa",
                              additionalValidator: (value) {
                                if (value != null && value.length > 6) {
                                  return "La placa puede tener como máximo 6 dígitos";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            buildTextFormField(
                              controller: colorController,
                              label: "Color",
                              icon: Icons.color_lens,
                              validatorMsg: "Por favor, ingrese el color del vehículo",
                              additionalValidator: (value) {
                                if (value != null && !RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]+$').hasMatch(value)) {
                                  return "La marca solo debe contener letras y espacios";
                                }
                                if (value != null && value.length > 30) {
                                  return "La marca no debe exceder los 30 caracteres";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            buildTextFormField(
                              controller: kilometrajeEntradaController,
                              label: "Kilometraje de ingreso",
                              icon: Icons.speed,
                              validatorMsg: "Por favor, ingrese el kilometraje de ingreso",
                              additionalValidator: (value) {
                                if (value != null && !RegExp(r'^\d+$').hasMatch(value)) {
                                  return "El kilometraje debe contener solo números";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            buildTextFormField(
                              controller: tipoCombustibleController,
                              label: "Tipo de combustible",
                              icon: Icons.local_gas_station,
                              validatorMsg: "Por favor, ingrese el tipo de combustible",
                              additionalValidator: (value) {
                                final opcionesValidas = ['gasolina', 'gas', 'eléctrico'];

                                if (value != null && !opcionesValidas.contains(value.toLowerCase().trim())) {
                                  return "Solo se permite: gasolina, gas o eléctrico";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
     
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  esEdicion ? Icons.update : Icons.save,
                                  color: Colors.white,
                                ),
                                label: vehiculoProvider.loading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 3,
                                        ),
                                      )
                                    : Text(
                                        esEdicion ? "Actualizar" : "Registrar",
                                        style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 255, 255, 255)),
                                      ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                                ),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    
                                    if (esEdicion) {
                                      vehiculoProvider.editarVehiculo(
                                        widget.cliente!,
                                        widget.vehiculo!["uid"],
                                        marcaController,
                                        modeloController,
                                        placaController,
                                        colorController,
                                        kilometrajeEntradaController,
                                        tipoCombustibleController,
                                        //numeroChasisController,
                                        context,
                                        formKey,
                                      );
                                    } else {
                                      bool placaExistente = await vehiculoProvider.verificarPlacaExistente(placaController.text);
                                      if (placaExistente) {
                                          // Si la placa ya existe, mostramos un mensaje de error.
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('La placa ya existe en el sistema.')),
                                        );
                                      }else{
                                        vehiculoProvider.guardarVehiculo(
                                        widget.cliente!,
                                        marcaController,
                                        modeloController,
                                        placaController,
                                        colorController,
                                        kilometrajeEntradaController,
                                        tipoCombustibleController,
                                        //numeroChasisController,
                                        context,
                                        formKey,
                                      );
                                      }
                                    }
                                  }
                                },
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

  Widget buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String validatorMsg,
    String? Function(String?)? additionalValidator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMsg;
        }
        if (additionalValidator != null) {
          return additionalValidator(value);
        }
        return null;
      },
    );
  }
}
