import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/clientes/crudclientes.dart';
import 'package:provider/provider.dart';

class Cliente extends StatefulWidget {
  const Cliente({super.key});

  @override
  State<Cliente> createState() => _ClienteState();
}

class _ClienteState extends State<Cliente> {
  @override
  Widget build(BuildContext context) {

    final clientesProvider = Provider.of<ClientesProvider>(context);
    clientesProvider.cargarClientes();

    return Scaffold(
  appBar: AppBar(
    title: Text('Lista de Clientes'),
  ),
  body: Padding(
    padding: EdgeInsets.all(10),
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Número de tarjetas por fila
        crossAxisSpacing: 10, // Espaciado horizontal entre tarjetas
        mainAxisSpacing: 10, // Espaciado vertical entre tarjetas
        childAspectRatio: 0.5, // Relación de aspecto de las tarjetas
      ),
      itemCount: clientesProvider.clientes.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  clientesProvider.clientes[index]["nombres"],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),


                Text(
                  clientesProvider.clientes[index]["apellidos"],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                  SizedBox(height: 5),

                 Text(
                  clientesProvider.clientes[index]["email"],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ), 
                SizedBox(height: 5),
                
                                 Text(
                  clientesProvider.clientes[index]["rol"],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ), 
                SizedBox(height: 5),
                
                  Text(
                  clientesProvider.clientes[index]["telefono"],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ), 
                SizedBox(height: 5),
                  
                  Text(
                  clientesProvider.clientes[index]["id"],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ), 
                SizedBox(height: 5),
/* 
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarClienteScreen(
                        cliente: clientesProvider.clientes[index],
                        index: index, // Pasa el índice del cliente // Agrega esta línea
                        ),
                      ),
                    );
                  },
                ) */

                
              ],
            ),
          ),
        );
      },
    ),
  ),
);



  }
}