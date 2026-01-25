import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_client.dart';
import '../models/evento.dart';

// Este provider faz a busca na API e retorna uma lista de Eventos
final eventosProvider = FutureProvider<List<Evento>>((ref) async {
  try {
    // Chama a URL /eventos/
    final response = await dioClient.get('eventos/');
    
    // Converte a lista de JSONs em lista de objetos Evento
    final List data = response.data;
    return data.map((json) => Evento.fromJson(json)).toList();
  } catch (e) {
    throw Exception('Erro ao carregar eventos: $e');
  }
});