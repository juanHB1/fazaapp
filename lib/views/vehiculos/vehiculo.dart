import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/Vehiculo/vehiculo.provider.dart';
import 'package:provider/provider.dart';

class Vehiculo extends StatefulWidget {
  const Vehiculo({super.key});

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


    return Scaffold(
      appBar: AppBar(title: const Text("Registro del vehiculo")),
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
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese la marca del vehiculo";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: modeloController,
                decoration: const InputDecoration(labelText: "Modelo"),
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese el modelo del vehiculo";
                  }
                  return null;
                }
              ),
              TextFormField(
                controller: anioController,
                decoration: const InputDecoration(labelText: "Año"),
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese el año del vehiculo";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: colorController,
                decoration: const InputDecoration(labelText: "Color"),
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese el color del vehiculo";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: placaController,
                decoration: const InputDecoration(labelText: "Placa"),
                keyboardType: TextInputType.text,
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese la placa del vehiculo";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: vinController,
                decoration: const InputDecoration(labelText: "vin"),
                keyboardType: TextInputType.text,
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, ingrese el vin del vehiculo";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (){
                  vehiculosProvider.agregarVehiculo(
                    'fOeCSB7f60aNKfjNSqIPAby5mYy1',
                    marcaController,
                    modeloController,
                    anioController,
                    colorController,
                    placaController,
                    vinController,
                    context, 
                    _formKey);
                    
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