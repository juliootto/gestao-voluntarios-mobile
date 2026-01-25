class Escala {
  final int id;
  final String ministerioNome;
  final String? voluntarioNome; // Pode ser nulo se for vaga aberta
  final String status;
  final bool autoEscalado;
  final String eventoStr;

  Escala({
    required this.id,
    required this.ministerioNome,
    this.voluntarioNome,
    required this.status,
    required this.autoEscalado,
    required this.eventoStr,
  });

  factory Escala.fromJson(Map<String, dynamic> json) {
    return Escala(
      id: json['id'],
      ministerioNome: json['ministerio_nome'] ?? 'Desconhecido',
      voluntarioNome: json['voluntario_nome'], // O Django manda null se estiver vazio
      status: json['status'],
      autoEscalado: json['auto_escalado'] ?? false,
      eventoStr: json['evento_str'] ?? 'Evento',
    );
  }

  // Helper para saber se a vaga está livre
  bool get isVagaAberta => voluntarioNome == null;
}