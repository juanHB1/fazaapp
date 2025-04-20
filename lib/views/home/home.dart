import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/login/login.provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class BienvenidaScreen extends StatefulWidget {
  const BienvenidaScreen({super.key});

  @override
  _BienvenidaScreenState createState() => _BienvenidaScreenState();
}

class _BienvenidaScreenState extends State<BienvenidaScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return PopScope(
      canPop: false, // Bloquea el botón "Atrás"
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          bool salir = await loginProvider.mostrarAlertaCerrarSesion(context);
          if (salir) {
            loginProvider.cerrarSesion(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey[50],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  opacity: _opacity,
                  child: Column(
                    children: [
                      Lottie.asset(
                        'assets/welcome.json',
                        width: 250,
                        repeat: true,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "¡Bienvenido a nuestra App!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Explora, aprende y disfruta de todas nuestras funcionalidades.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/clientes');
                  },
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  label: const Text(
                    "Empezar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: Colors.blueGrey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    foregroundColor: Colors.white, // Added for text color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}