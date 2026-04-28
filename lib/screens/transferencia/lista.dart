import 'package:flutter/material.dart';
import 'formulario.dart';
import '../../models/transferencia.dart';
import '../../database/transferencia_dao.dart';
import 'package:intl/intl.dart';

class ListaTransferencias extends StatefulWidget {
  const ListaTransferencias({super.key});

  @override
  State<ListaTransferencias> createState() => _ListaTransferenciasState();
}

class _ListaTransferenciasState extends State<ListaTransferencias> {
  static const _tituloAppBar = 'Transferências';
  final TransferenciaDao _dao = TransferenciaDao();

  // Chave para forçar recarregamento do FutureBuilder
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  Future<List<Transferencia>> _buscarTransferencias() async {
    return await _dao.buscarTodas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_tituloAppBar),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder<List<Transferencia>>(
          future: _buscarTransferencias(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Erro ao carregar transferências:\n${snapshot.error}'),
              );
            }

            final List<Transferencia> transferencias = snapshot.data ?? [];

            if (transferencias.isEmpty) {
              return const Center(
                child: Text('Nenhuma transferência cadastrada ainda.'),
              );
            }

            return ListView.builder(
              itemCount: transferencias.length,
              itemBuilder: (context, indice) {
                final transferencia = transferencias[indice];
                return ItemTransferencia(
                  transferencia: transferencia,
                  dao: _dao,
                  onDelete: () => setState(() {}), // Atualiza a lista após deletar
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormularioTransferencia(),
            ),
          ).then((_) {
            // Atualiza a lista ao voltar do formulário
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// Componente para cada item da lista
class ItemTransferencia extends StatelessWidget {
  final Transferencia transferencia;
  final TransferenciaDao dao;
  final VoidCallback onDelete;

  const ItemTransferencia({
    super.key,
    required this.transferencia,
    required this.dao,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final formatoMoeda = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.monetization_on, color: Colors.green, size: 32),
        title: Text(
          formatoMoeda.format(transferencia.valor),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Conta: ${transferencia.numeroConta}',
          style: const TextStyle(fontSize: 16),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmarExclusao(context),
        ),
      ),
    );
  }

  void _confirmarExclusao(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text(
          'Deseja realmente excluir a transferência da conta ${transferencia.numeroConta}?',
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
            onPressed: () async {
              await dao.deletar(transferencia.id!);
              Navigator.pop(context); // Fecha o dialog
              onDelete();             // Atualiza a lista
            },
          ),
        ],
      ),
    );
  }
}