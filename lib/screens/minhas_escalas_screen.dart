import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/escala_provider.dart';

class MinhasEscalasScreen extends ConsumerWidget {
  const MinhasEscalasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEscalas = ref.watch(minhasEscalasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Minha Agenda')),
      body: asyncEscalas.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro: $err')),
        data: (escalas) {
          if (escalas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.event_busy, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Você não tem escalas agendadas.'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: escalas.length,
            itemBuilder: (context, index) {
              final escala = escalas[index];
              // Precisamos mostrar o NOME DO EVENTO e a DATA aqui.
              // O serializer padrão de Escala já manda 'evento_str' (ex: "Culto Domingo - 10/02 09:00")
              // Vamos usar ele por simplicidade agora.
              
              return Card(
                color: Colors.blue.shade50,
                child: ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(escala.ministerioNome, style: const TextStyle(fontWeight: FontWeight.bold)),
                  // O campo 'evento_str' vem do nosso Serializer lá no Django
                  subtitle: Text(escala.eventoStr),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.redAccent),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Desistir da Escala?'),
                          content: const Text('Sua vaga ficará disponível para outros voluntários.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Não'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(ctx).pop(); // Fecha o diálogo
                                try {
                                  // 1. Chama o Backend
                                  await ref.read(escalaActionsProvider).abandonarVaga(escala.id);
                                  
                                  // 2. Atualiza a lista
                                  ref.refresh(minhasEscalasProvider);
                                  
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Vaga liberada!')),
                                    );
                                  }
                                } catch (e) {
                                  // Tratar erro
                                }
                              },
                              child: const Text('Sim, Desistir', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}