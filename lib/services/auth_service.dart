import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_client.dart'; // Importe nosso cliente Dio configurado

class AuthService {
  // Faz o login e retorna True se deu certo
  Future<bool> login(String username, String password) async {
    try {
      // 1. Envia os dados para o Django
      final response = await dioClient.post('api-token-auth/', data: {
        'username': username,
        'password': password,
      });

      // 2. Se o Django devolveu um Token
      if (response.data['token'] != null) {
        final token = response.data['token'];
        
        // 3. Salva no armazenamento local do celular
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        
        print("Login Sucesso! Token: $token");
        return true;
      }
      return false;
    } on DioException catch (e) {
      print("Erro de Login: ${e.response?.data ?? e.message}");
      return false;
    }
  }

  // Apaga o token para deslogar
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}