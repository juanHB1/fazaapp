import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/notificacionCambioAceiteProximo/notificacionCambioAceiteProximoProvider.dart';


class NotificacionCambioAceiteProximo extends StatefulWidget {
  const NotificacionCambioAceiteProximo({super.key});

  @override
  State<NotificacionCambioAceiteProximo> createState() => _NotificacionCambioAceiteProximoState();
}

class _NotificacionCambioAceiteProximoState extends State<NotificacionCambioAceiteProximo> {
  
  @override
  void initState() {
    super.initState();   
    Future.microtask(() {
      Provider.of<NotificacionCambioAceiteProximoProvider>(context, listen: false).obtenerOrdenesProximas();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}