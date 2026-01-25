import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'auth_interceptor.dart';

// Configuração centralizada do Dio
final dioClient = Dio(BaseOptions(
  baseUrl: _getBaseUrl(),
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
))..interceptors.add(AuthInterceptor());

String _getBaseUrl() {
  if (kIsWeb) return 'http://localhost:8000/api/';
  
  // Se for Android (Emulador), usa o IP especial 10.0.2.2
  // Se for iOS ou celular físico na mesma rede, teria que usar o IP da sua máquina (ex: 192.168.x.x)
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:8000/api/';
  }
  
  return 'http://127.0.0.1:8000/api/';
}