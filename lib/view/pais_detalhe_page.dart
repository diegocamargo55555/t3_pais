import 'dart:io';
import 'package:flutter/material.dart';
import 'package:t3_pais/database/model/pais_model.dart'; 
import 'package:url_launcher/url_launcher.dart';

class PaisDetalhePage extends StatelessWidget {
  final Pais pais;

  const PaisDetalhePage({super.key, required this.pais});

  Future<void> _abrirLink(BuildContext context) async {
    if (pais.link.isNotEmpty) {
      final Uri url = Uri.parse(
        pais.link.startsWith('http') ? pais.link : 'https://${pais.link}',
      );
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Não foi possível abrir o link.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pais.nome), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagem da Bandeira
            if (pais.bandeira != null && File(pais.bandeira!).existsSync())
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(pais.bandeira!),
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              const Center(
                child: Icon(Icons.flag, size: 100, color: Colors.grey),
              ),

            const SizedBox(height: 20),

            _infoCard('Capital', pais.capital),
            _infoCard('Sigla', pais.sigla),
            _infoCard('População', '${pais.populacao}'),
            _infoCard('Continente', pais.continente),
            _infoCard('Regime Político', pais.regimePolitico),

            const SizedBox(height: 20),

            const Text(
              "Descrição:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              pais.descricao.isNotEmpty ? pais.descricao : 'Sem descrição.',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 30),

            if (pais.link.isNotEmpty)
              ElevatedButton.icon(
                onPressed: () => _abrirLink(context),
                icon: const Icon(Icons.link),
                label: const Text('Visitar Link'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String label, String value) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
