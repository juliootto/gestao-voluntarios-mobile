class Evento {
  final int id;
  final String tipoNome;
  final DateTime dataHora;
  final String? observacao;
  final bool escalaFechada;

  Evento({
    required this.id,
    required this.tipoNome,
    required this.dataHora,
    this.observacao,
    required this.escalaFechada,
  });

  // Fábrica para criar o objeto a partir do JSON
  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'],
      // O Django manda 'tipo_nome' (snake_case), aqui usamos camelCase
      tipoNome: json['tipo_nome'] ?? 'Evento sem nome',
      dataHora: DateTime.parse(json['data_hora']),
      observacao: json['observacao'],
      escalaFechada: json['escala_fechada'] ?? false,
    );
  }
}