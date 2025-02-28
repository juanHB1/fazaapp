import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/Vehiculo/vehiculo.provider.dart';
import 'package:provider/provider.dart';

class Vehiculo extends StatefulWidget {
  final Map<String, dynamic> cliente; // Propiedad cliente

  const Vehiculo({super.key, required this.cliente}); // Constructor corregido

  @override
  State<Vehiculo> createState() => VehiculoState();
}

class VehiculoState extends State<Vehiculo> {
  final TextEditingController marcaController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController anioController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final TextEditingController vinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vehiculosProvider = Provider.of<VehiculoProvider>(context);
    final cliente = widget.cliente; // Accede al cliente

    return Scaffold(
      appBar: AppBar(
        title: Text("Registro del vehículo para ${cliente["nombres"]}"), // Usa el cliente
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: marcaController,
                decoration: const InputDecoration(labelText: "Marca"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese la marca del vehículo";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: modeloController,
                decoration: const InputDecoration(labelText: "Modelo"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese el modelo del vehículo";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: anioController,
                decoration: const InputDecoration(labelText: "Año"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese el año del vehículo";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: colorController,
                decoration: const InputDecoration(labelText: "Color"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese el color del vehículo";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: placaController,
                decoration: const InputDecoration(labelText: "Placa"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese la placa del vehículo";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: vinController,
                decoration: const InputDecoration(labelText: "VIN"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese el VIN del vehículo";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  vehiculosProvider.agregarVehiculo(
                    'fOeCSB7f60aNKfjNSqIPAby5mYy1',
                    marcaController,
                    modeloController,
                    anioController,
                    colorController,
                    placaController,
                    vinController,
                    context,
                    _formKey,
                  );
                },
                child: const Text("Registrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}