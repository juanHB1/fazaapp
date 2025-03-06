import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/Vehiculo/formularioservicio.provider.dart';

class AgregarOrden extends StatelessWidget {
  final Map<String, dynamic> vehiculo;

  const AgregarOrden({super.key, required this.vehiculo});

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<OrdenServicioFormProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Agregar Orden de Servicio")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formProvider.formKey,
          child: Column(
            children: [
              // 📅 Fecha
              TextFormField(
                decoration: const InputDecoration(labelText: "Fecha (YYYY-MM-DD)"),
                onChanged: formProvider.setFecha,
                validator: (value) =>
                    value == null || value.isEmpty ? "Ingrese una fecha" : null,
              ),
              const SizedBox(height: 10),

              // 📝 Descripción
              TextFormField(
                decoration: const InputDecoration(labelText: "Descripción"),
                onChanged: formProvider.setDescripcion,
                validator: (value) =>
                    value == null || value.isEmpty ? "Ingrese una descripción" : null,
              ),
              const SizedBox(height: 10),

              // 📌 Estado
              DropdownButtonFormField<String>(
                value: formProvider.estado,
                decoration: const InputDecoration(labelText: "Estado"),
                items: ["Pendiente", "En Proceso", "Finalizado"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    formProvider.setEstado(newValue);
                  }
                },
              ),
              const SizedBox(height: 20),

              // 💾 Botón Guardar
              ElevatedButton(
                onPressed: formProvider.isLoading
                    ? null
                    : () async {
                        await formProvider.saveOrdenServicio( vehiculo['id'] );
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                child: formProvider.isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Guardar Orden"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
