import 'package:flutter/material.dart';
import '../../components/editor.dart';
import '../../models/transferencia.dart';
import '../../database/transferencia_dao.dart';

class FormularioTransferencia extends StatefulWidget {
  const FormularioTransferencia({super.key});

  @override
  State<FormularioTransferencia> createState() =>
      _FormularioTransferenciaState();
}

class _FormularioTransferenciaState extends State<FormularioTransferencia> {
  static const _tituloAppBar = 'Nova Transferência';

  final _controladorCampoNumeroConta = TextEditingController();
  final _controladorCampoValor = TextEditingController();

  final _dao = TransferenciaDao();

  @override
  void dispose() {
    _controladorCampoNumeroConta.dispose();
    _controladorCampoValor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_tituloAppBar),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Editor(
              controlador: _controladorCampoNumeroConta,
              rotulo: 'Número da Conta',
              dica: '0000',
              tipoTeclado: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Editor(
              controlador: _controladorCampoValor,
              rotulo: 'Valor',
              dica: '0.00',
              icone: Icons.monetization_on,
              tipoTeclado: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _criaTransferencia(context),
                child: const Text('Confirmar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _criaTransferencia(BuildContext context) async {
    final String textoNumeroConta = _controladorCampoNumeroConta.text.trim();
    final String textoValor = _controladorCampoValor.text.trim();

    if (textoNumeroConta.isEmpty || textoValor.isEmpty) {
      _mostrarMensagemErro(context, 'Por favor, preencha todos os campos.');
      return;
    }

    try {
      final int numeroConta = int.parse(textoNumeroConta);
      final double valor = double.parse(textoValor.replaceAll(',', '.'));

      if (valor <= 0) {
        _mostrarMensagemErro(context, 'O valor deve ser maior que zero.');
        return;
      }

      final transferencia = Transferencia(
        valor: valor,
        numeroConta: numeroConta,
      );

      final int id = await _dao.inserir(transferencia);

      final transferenciaSalva = Transferencia(
        id: id,
        valor: valor,
        numeroConta: numeroConta,
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transferência salva com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, transferenciaSalva);
    } catch (e) {
      _mostrarMensagemErro(context, 'Erro ao salvar. Verifique os dados informados.');
    }
  }

  void _mostrarMensagemErro(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
      ),
    );
  }
}