import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_client.dart';
import '../models/escala.dart';

// Família de Providers: Cria um provider diferente para cada ID de evento
// Uso: ref.watch(escalasProvider(eventoId))
final escalasProvider = FutureProvider.family<List<Escala>, int>((ref, eventoId) async {
  final response = await dioClient.get('escalas/', queryParameters: {
    'evento_id': eventoId,
  });
  
  final List data = response.data;
  return data.map((json) => Escala.fromJson(json)).toList();
});

// Classe para ações (Assumir vaga)
final escalaActionsProvider = Provider((ref) => EscalaActions());

class EscalaActions {
  Future<void> assumirVaga(int escalaId) async {
    try {
      // Chama a ação customizada que criamos no Django
      await dioClient.post('escalas/$escalaId/assumir_vaga/');
    } catch (e) {
      throw Exception('Erro ao assumir vaga: $e');
    }
  }
  Future<void> abandonarVaga(int escalaId) async {
    try {
      await dioClient.post('escalas/$escalaId/abandonar_vaga/');
    } catch (e) {
      throw Exception('Erro ao abandonar vaga: $e');
    }
  }
}

// Provider simples que chama /api/escalas/minhas/
final minhasEscalasProvider = FutureProvider<List<Escala>>((ref) async {
  final response = await dioClient.get('escalas/minhas/');
  final List data = response.data;
  return data.map((json) => Escala.fromJson(json)).toList();
});