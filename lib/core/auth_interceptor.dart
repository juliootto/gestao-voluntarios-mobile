import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 1. Busca o token salvo
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    // 2. Se tiver token, adiciona no cabeçalho
    if (token != null) {
      options.headers['Authorization'] = 'Token $token';
    }

    // 3. Libera a requisição
    super.onRequest(options, handler);
  }
}