import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/providers/Clientes/cliente.provider.dart';
import 'package:flutter_application_1/views/listadoclientes/listaclientes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/views/drawer/drawe.dart'; // Importa el Drawer reutilizable

class RegistroClientes extends StatefulWidget {
  
  final Map<String, dynamic>? cliente; // Datos del cliente a editar
  const RegistroClientes({super.key, this.cliente});


  @override
  State<RegistroClientes> createState() => RegistroState();
}

class RegistroState extends State<RegistroClientes> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _rolController = TextEditingController();

  String? selectedOption; //opcion seleccionada 
  
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos actuales del cliente
    _nombresController.text = widget.cliente?['nombres'] ?? '';
    _apellidoController.text = widget.cliente?['apellidos'] ?? '';
    _emailController.text = widget.cliente?['email'] ?? '';
    _passwordController.text = widget.cliente?['password'] ?? '';
    _telefonoController.text = widget.cliente?['telefono'] ?? '';
    _rolController.text = widget.cliente?['rol'] ?? '';

    // Asigna el valor del rol a selectedOption si existe en la lista de opciones
    if (widget.cliente?['rol'] != null) {
      selectedOption = widget.cliente!['rol'];
    }

  }

  
  @override
  Widget build(BuildContext context) {

    bool esEdicion = widget.cliente != null;
    final clientesProvider = Provider.of<ClientesProvider>(context);


      return PopScope(
        canPop: false, // Bloquea el botón "Atrás"
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
        },
        child: Scaffold(
            backgroundColor: Colors.blueGrey[50],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 0, // Puedes cambiar esto si necesitas manejar la navegación
              selectedItemColor: Colors.blueGrey[800],
              unselectedItemColor: Colors.blueGrey[400],
              onTap: (index) {
                if (index == 0) {
                  clientesProvider.hacerLlamada(_telefonoController.text, context);
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.phone),
                  label: 'teléfono',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.messenger_sharp),
                  label: 'whatsapp',
                ),
              ],
            ),
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
                      builder: (context) => ListaCliente()
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
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Icono y título
                                      Icon(Icons.person, size: 60, color: Colors.blueGrey),
                                      const SizedBox(height: 10),
                                      Text(
                                        esEdicion ? "Editar Cliente" : "Registrar Cliente",
                                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 45, 43, 43)),
                                      ),
                                      const SizedBox(height: 20),
                            
                                      // Campo de Nombres
                                      TextFormField(
                                        controller: _nombresController,
                                        decoration: InputDecoration(
                                          labelText: "Nombres",
                                          prefixIcon: Icon(Icons.person, color: Colors.blueGrey),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Por favor, ingresa tu correo";
                                          }
                                          return null;
                                        },
                                      ),
                            
                                      const SizedBox(height: 10),
                            
                                      // Campo de Apellidos
                                    TextFormField(
                                        controller: _apellidoController,
                                        decoration: InputDecoration(
                                          labelText: "Apellidos",
                                          prefixIcon: Icon(Icons.person_outline, color: Colors.blueGrey),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Por favor, ingrese sus apellidos";
                                          }
                                          return null;
                                        },
                                      ),
                            
                                      const SizedBox(height: 10),
                            
                                      // Campo de Correo
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blueGrey), // Borde cuando está habilitado
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey), // Borde cuando está deshabilitado
                                          ),
                                          labelText: "Correo",
                                          prefixIcon: Icon(Icons.email, color: Colors.blueGrey),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                        enabled: esEdicion ? false : true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Por favor, ingresa tu correo";
                                          } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(value)) {
                                            return "Ingresa un correo válido";
                                          }
                                          return null;
                                        },
                                      ),
                            
                                      const SizedBox(height: 10),
                            
                                    // Campo de Teléfono
                                    TextFormField(
                                        controller: _telefonoController,
                                        decoration: InputDecoration(
                                          labelText: "Teléfono",
                                          prefixIcon: Icon(Icons.phone, color: Colors.blueGrey),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Por favor, ingrese un número de teléfono";
                                          } else if (value.length > 10) {
                                            return "El número de teléfono no puede tener más de 10 dígitos";
                                          }
                                          return null;
                                        },
                                      ),
                            
                                      const SizedBox(height: 10),
                            
                                    // Campo de Contraseña
                                    TextFormField(
                                        controller: _passwordController,
                                        
                                        decoration: InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blueGrey), // Borde cuando está habilitado
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey), // Borde cuando está deshabilitado
                                          ),
                                          labelText: "Contraseña",
                                          prefixIcon: Icon(Icons.lock, color: Colors.blueGrey),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                        enabled: esEdicion ? false : true,
                                        obscureText: esEdicion ? false : true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Por favor, ingresa tu contraseña";
                                          } else if (value.length < 6) {
                                            return "La contraseña debe tener al menos 6 caracteres";
                                          }
                                          return null;
                                        },
                                      ),
                            
                                      const SizedBox(height: 10),
                            
                                      // Dropdown para seleccionar el rol
                                      DropdownButtonFormField<String>(
                                        value: selectedOption,
                                        hint: const Text("Seleccione un rol"),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedOption = newValue;
                                            _rolController.text = newValue ?? "";
                                          });
                                        },
                                        validator: (value) => value == null || value.isEmpty ? "Seleccione un rol" : null,
                                        items: clientesProvider.optionsDropDownList.map((String role) {
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
                                            if (_formKey.currentState!.validate()) {
                          
                                              switch (esEdicion) {
                                                case true:
                                                  clientesProvider.editarCliente(
                                                    widget.cliente!["id"], 
                                                    _nombresController, 
                                                    _apellidoController, 
                                                    _emailController, 
                                                    _telefonoController, 
                                                    _rolController, 
                                                    _passwordController, 
                                                    context, 
                                                    _formKey);
                                                  break;
                                                case false:
                                                  clientesProvider.registrarCliente(
                                                    _nombresController,
                                                    _apellidoController,
                                                    _emailController,
                                                    _telefonoController,
                                                    _rolController,
                                                    _passwordController,
                                                    context,
                                                    _formKey,
                                                  );
                                                  break;
                                              }
                                              
                                            }
                                          },
                                          child: clientesProvider.loading ? 
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