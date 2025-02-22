import 'package:shared_preferences/shared_preferences.dart';

class Shared {


  // Guardar credenciales
  static Future<void> saveCredentials(String key, String data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data);
  }
 
  // Obtener credenciales
  static Future<String?> getCredentials(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Eliminar credenciales
  static Future<void> removeCredentials(key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

}