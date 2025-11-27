import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:t3_pais/database/model/pais_model.dart';
import 'package:t3_pais/service/pais_service.dart';

class CadastroPaisPage extends StatefulWidget {
  final Pais? paisParaEditar;

  const CadastroPaisPage({super.key, this.paisParaEditar});

  @override
  State<CadastroPaisPage> createState() => _CadastroPaisPageState();
}

class _CadastroPaisPageState extends State<CadastroPaisPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _capitalController = TextEditingController();
  final _populacaoController = TextEditingController();
  final _siglaController = TextEditingController();

  String? _continenteSelecionado;
  String? _regimeSelecionado;
  String? _caminhoImagemBandeira;

  final List<String> _continentes = [
    'África',
    'América',
    'Antártida',
    'Ásia',
    'Europa',
    'Oceania',
  ];
  final List<String> _regimes = [
    'Democracia',
    'República',
    'Monarquia',
    'Ditadura',
    'Parlamentarismo',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.paisParaEditar != null) {
      _nomeController.text = widget.paisParaEditar!.nome;
      _capitalController.text = widget.paisParaEditar!.capital;
      _populacaoController.text = widget.paisParaEditar!.populacao.toString();
      _siglaController.text = widget.paisParaEditar!.sigla;
      _continenteSelecionado = widget.paisParaEditar!.continente;
      _regimeSelecionado = widget.paisParaEditar!.regimePolitico;
      _caminhoImagemBandeira = widget.paisParaEditar!.bandeira;
    }
  }

  Future<void> _selecionarImagem() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _caminhoImagemBandeira = image.path;
      });
    }
  }

  _salvarPais() async {
    if (_formKey.currentState!.validate()) {
      Pais pais = Pais(
        id: widget.paisParaEditar?.id,
        nome: _nomeController.text,
        capital: _capitalController.text,
        populacao: int.parse(_populacaoController.text),
        sigla: _siglaController.text,
        continente: _continenteSelecionado!,
        regimePolitico: _regimeSelecionado!,
        bandeira: _caminhoImagemBandeira,
      );

      PaisService db = PaisService();

      if (widget.paisParaEditar == null) {
        await db.createPais(pais);
      } else {
        await db.updatePais(pais);
      }

      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.paisParaEditar == null ? 'Novo País' : 'Editar País',
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/imgs/onu.jpeg"),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                GestureDetector(
                  onTap: _selecionarImagem,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200]?.withOpacity(0.8),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        _caminhoImagemBandeira != null &&
                            File(_caminhoImagemBandeira!).existsSync()
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(_caminhoImagemBandeira!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.grey,
                              ),
                              Text("Toque para adicionar bandeira"),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: _capitalController,
                  decoration: const InputDecoration(
                    labelText: 'Capital',
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: _populacaoController,
                  decoration: const InputDecoration(
                    labelText: 'População',
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Campo obrigatório';
                    if (int.tryParse(value) == null)
                      return 'Digite apenas números';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _siglaController,
                  decoration: const InputDecoration(
                    labelText: 'Sigla',
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Campo obrigatório';
                    if (value.length < 2 || value.length > 3)
                      return 'Sigla deve ter 2 ou 3 letras';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _continenteSelecionado,
                  decoration: const InputDecoration(
                    labelText: 'Continente',
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  items: _continentes
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _continenteSelecionado = value),
                  validator: (value) =>
                      value == null ? 'Selecione um continente' : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _regimeSelecionado,
                  decoration: const InputDecoration(
                    labelText: 'Regime Político',
                    filled: true,
                    fillColor: Colors.white70,
                  ),
                  items: _regimes
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _regimeSelecionado = value),
                  validator: (value) =>
                      value == null ? 'Selecione um regime' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _salvarPais,
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
