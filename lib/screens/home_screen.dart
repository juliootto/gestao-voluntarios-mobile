import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Para formatar a data
import '../providers/eventos_provider.dart';
import '../models/evento.dart';
import 'evento_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // O ref.watch fica "ouvindo" o provider.
    // O 'asyncEventos' contém o estado atual (Carregando, Erro ou Lista Pronta)
    final asyncEventos = ref.watch(eventosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Próximos Cultos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            // Força a atualização da lista
            onPressed: () => ref.refresh(eventosProvider),
          ),
        ],
      ),
      body: asyncEventos.when(
        // 1. Estado de Carregamento
        loading: () => const Center(child: CircularProgressIndicator()),
        
        // 2. Estado de Erro
        error: (err, stack) => Center(child: Text('Erro: $err')),
        
        // 3. Estado de Sucesso (Lista carregada)
        data: (eventos) {
          if (eventos.isEmpty) {
            return const Center(child: Text('Nenhum evento agendado.'));
          }

          return ListView.builder(
            itemCount: eventos.length,
            itemBuilder: (context, index) {
              final evento = eventos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.event, color: Colors.blueAccent),
                  title: Text(
                    evento.tipoNome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    DateFormat("dd/MM 'às' HH:mm").format(evento.dataHora),
                  ),
                  trailing: evento.escalaFechada
                      ? const Chip(label: Text('Fechada'), backgroundColor: Colors.grey)
                      : const Chip(label: Text('Aberta'), backgroundColor: Colors.greenAccent),
                  onTap: () {
                    Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventoDetailScreen(evento: evento),
                ),
              );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}