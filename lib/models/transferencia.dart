class Transferencia {
  final int? id;
  final double valor;
  final int numeroConta;

  // Construtor nomeado (melhor prática)
  Transferencia({
    this.id,
    required this.valor,
    required this.numeroConta,
  });

  // Converte o objeto para Map (para salvar no banco)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'valor': valor,
      'numeroConta': numeroConta,
    };
  }

  // Cria um objeto a partir do Map vindo do banco
  factory Transferencia.fromMap(Map<String, dynamic> map) {
    return Transferencia(
      id: map['id'] as int?,
      valor: map['valor'] as double,
      numeroConta: map['numeroConta'] as int,
    );
  }

  @override
  String toString() {
    return 'Transferencia(id: $id, valor: $valor, numeroConta: $numeroConta)';
  }
}