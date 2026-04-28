import 'package:flutter/material.dart';

class Editor extends StatelessWidget {
  final TextEditingController? controlador;
  final String? rotulo;
  final String? dica;
  final IconData? icone;
  final TextInputType? tipoTeclado;

  const Editor({
    super.key,
    this.controlador,
    this.rotulo,
    this.dica,
    this.icone,
    this.tipoTeclado = TextInputType.number,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controlador,
        style: const TextStyle(fontSize: 24),
        decoration: InputDecoration(
          icon: icone != null ? Icon(icone) : null,
          labelText: rotulo,
          hintText: dica,
          border: const OutlineInputBorder(),
        ),
        keyboardType: tipoTeclado,
        // Permite números decimais no campo de valor
        inputFormatters: tipoTeclado == TextInputType.numberWithOptions(decimal: true)
            ? null // Você pode adicionar formatadores de moeda depois se quiser
            : null,
      ),
    );
  }
}