import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/evento.dart';
import '../models/escala.dart';
import '../providers/escala_provider.dart';

class EventoDetailScreen extends ConsumerWidget {
  final Evento evento;

  const EventoDetailScreen({super.key, required this.evento});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Busca as escalas específicas deste evento
    final asyncEscalas = ref.watch(escalasProvider(evento.id));

    return Scaffold(
      appBar: AppBar(title: Text(evento.tipoNome)),
      body: Column(
        children: [
          // Cabeçalho com data
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blueAccent.withOpacity(0.1),
            width: double.infinity,
            child: Column(
              children: [
                const Icon(Icons.calendar_month, size: 40, color: Colors.blueAccent),
                const SizedBox(height: 8),
                Text(
                  DateFormat("EEEE, dd 'de' MMMM", 'pt_BR').format(evento.dataHora),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(DateFormat("HH:mm").format(evento.dataHora)),
              ],
            ),
          ),
          
          // Lista de Escalas
          Expanded(
            child: asyncEscalas.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Erro: $err')),
              data: (escalas) {
                if (escalas.isEmpty) {
                  return const Center(
                    child: Text('A escala ainda não foi gerada para este evento.'),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: escalas.length,
                  itemBuilder: (context, index) {
                    final escala = escalas[index];
                    return _buildEscalaCard(context, ref, escala);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEscalaCard(BuildContext context, WidgetRef ref, Escala escala) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Ícone do Ministério (Genérico)
            CircleAvatar(
              backgroundColor: Colors.blueAccent.withOpacity(0.2),
              child: const Icon(Icons.group, color: Colors.blueAccent),
            ),
            const SizedBox(width: 16),
            
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    escala.ministerioNome,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (escala.isVagaAberta)
                    const Text(
                      'VAGA DISPONÍVEL',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    )
                  else
                    Text(
                      escala.voluntarioNome!,
                      style: const TextStyle(color: Colors.black87),
                    ),
                ],
              ),
            ),

            // Botão de Ação
            if (escala.isVagaAberta)
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Chama a ação de assumir
                    await ref.read(escalaActionsProvider).assumirVaga(escala.id);
                    
                    // Atualiza a lista na tela
                    ref.refresh(escalasProvider(evento.id));
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Você assumiu a vaga!')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Pegar'),
              )
            else
              const Icon(Icons.check_circle, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}