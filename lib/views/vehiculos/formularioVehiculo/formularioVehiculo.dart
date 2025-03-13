import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/Vehiculo/vehiculo.provider.dart';
import 'package:flutter_application_1/views/drawer/drawe.dart';
import 'package:flutter_application_1/views/vehiculos/listaVehiculos/vehiculo.dart';
import 'package:provider/provider.dart'; // Importa el Drawer reutilizable


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
  final TextEditingController numeroChasisController = TextEditingController();
  final formKey = GlobalKey<FormState>();


   @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos actuales del cliente
    marcaController.text = widget.vehiculo?['marca'] ?? '';
    modeloController.text = widget.vehiculo?['modelo'] ?? '';
    placaController.text = widget.vehiculo?['placa'] ?? '';
    colorController.text = widget.vehiculo?['color'] ?? '';
    kilometrajeEntradaController.text = widget.vehiculo?['kilometrajeEntrada'] ?? '';
    tipoCombustibleController.text = widget.vehiculo?['tipoCombustible'] ?? '';
    numeroChasisController.text = widget.vehiculo?['numeroChasis'] ?? '';
    debugPrint("variable cliente: 👉 ${widget.cliente}");
    debugPrint("variable vehiculo: 👉 ${widget.vehiculo}");
  }

  @override
  Widget build(BuildContext context) {

    bool esEdicion = widget.vehiculo != null;
    final vehiculoProvider = Provider.of<VehiculoProvider>(context);

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
                      builder: (context) => Vehiculo(cliente: widget.cliente as Map<String, dynamic>)
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
                                        esEdicion ? "Editar vehiculo" : "Registrar vehiculo",
                                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 45, 43, 43)),
                                      ),
                                      const SizedBox(height: 20),
                            
                                      // Campo de marca
                                      TextFormField(
                                        controller: marcaController,
                                        decoration: InputDecoration(
                                          labelText: "Marca",
                                          prefixIcon: Icon(Icons.card_membership, color: Colors.blueGrey),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Por favor, la marca de su vehiculo ";
                                          }
                                          return null;
                                        },
                                      ),
                            
                                      const SizedBox(height: 10),
                            
                                      // Campo de modelo
                                    TextFormField(
                                        controller: modeloController,
                                        decoration: InputDecoration(
                                          labelText: "Modelo",
                                          prefixIcon: Icon(Icons.person_outline, color: Colors.blueGrey),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Por favor, ingrese el modelo de su vehiculo";
                                          }
                                          return null;
                                        },
                                      ),
                            
                                      const SizedBox(height: 10),
                            
                                      // Campo de placa
                                      TextFormField(
                                        controller: placaController,
                                        decoration: InputDecoration(
                                          labelText: "Placa",
                                          prefixIcon: Icon(Icons.email, color: Colors.blueGrey),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Por favor, ingresa tu correo";
                                          }else if (value.length > 6) {
                                            return "La placa puede tener como maximo 6 digitos";
                                          }
                                          return null;
                                        },
                                      ),
                            
                                      const SizedBox(height: 10),
                            
                                    // Campo de color
                                    TextFormField(
                                        controller: colorController,
                                        decoration: InputDecoration(
                                          labelText: "Color",
                                          prefixIcon: Icon(Icons.phone, color: Colors.blueGrey),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Por favor, ingrese el color del vehiculo";
                                          }
                                          return null;
                                        },
                                      ),
                            
                                      const SizedBox(height: 10),
                            
                                    // Campo de Contraseña
                                    TextFormField(
                                        controller: kilometrajeEntradaController,
                                        decoration: InputDecoration(
                                          labelText: "Kilometraje de ingreso",
                                          prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Por favor, ingresar el kilometraje de ingreso del vehiculo";
                                          }
                                          return null;
                                        },
                                      ),

                                    const SizedBox(height: 10),

                                      // Campo de tipo de combustible
                                    TextFormField(
                                        controller: tipoCombustibleController,
                                        decoration: InputDecoration(
                                          labelText: "tipo de combustible",
                                          prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Por favor, ingresar el tipo de combustible del vehiculo";
                                          }
                                          return null;
                                        },
                                      ),

                                    const SizedBox(height: 10),

                                      // Campo de numero chasis
                                    TextFormField(
                                        controller: numeroChasisController,
                                        decoration: InputDecoration(
                                          labelText: "Número de chasis",
                                          prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Por favor, ingresar el # de chasis del vehiculo";
                                          }
                                          return null;
                                        },
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
                                                   vehiculoProvider.editarVehiculo(
                                                    widget.cliente!, 
                                                    widget.vehiculo!["uid"],
                                                    marcaController,
                                                    modeloController,
                                                    placaController,
                                                    colorController,
                                                    kilometrajeEntradaController,
                                                    tipoCombustibleController,
                                                    numeroChasisController,
                                                    context, 
                                                    formKey); 
                                                  break;
                                                case false:
                                                  vehiculoProvider.guardarVehiculo(
                                                    widget.cliente!,
                                                    marcaController,
                                                    modeloController,
                                                    placaController,
                                                    colorController,
                                                    kilometrajeEntradaController,
                                                    tipoCombustibleController,
                                                    numeroChasisController,
                                                    context, 
                                                    formKey);
                                                  break;
                                              }
                                              
                                            }
                                          },
                                          child: vehiculoProvider.loading ? 
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