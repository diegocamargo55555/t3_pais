import 'dart:io';
import 'package:flutter/material.dart';
import 'package:t3_pais/database/helper/pais_helper.dart';
import 'package:t3_pais/database/model/pais_model.dart';
import 'package:t3_pais/view/cadastro_page.dart';

class PaisPage extends StatefulWidget {
  const PaisPage({super.key});

  @override
  State<PaisPage> createState() => _PaisPageState();
}

enum OrderOption { orderAZ, orderZA, orderPopDesc, orderPopAsc }

class _PaisPageState extends State<PaisPage> {
  late PaisHelper dbPais;
  List<Pais> listaPaises = [];
  OrderOption _currentOrder = OrderOption.orderAZ;

  @override
  void initState() {
    super.initState();
    dbPais = PaisHelper();
    _atualizarLista();
  }

  _atualizarLista() async {
    List<Pais> x = await dbPais.getPaises();
    setState(() {
      listaPaises = x;
      _ordenarLista();
    });
  }

  void _ordenarLista() {
    switch (_currentOrder) {
      case OrderOption.orderAZ:
        listaPaises.sort(
          (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()),
        );
        break;
      case OrderOption.orderZA:
        listaPaises.sort(
          (a, b) => b.nome.toLowerCase().compareTo(a.nome.toLowerCase()),
        );
        break;
      case OrderOption.orderPopDesc:
        listaPaises.sort((a, b) => b.populacao.compareTo(a.populacao));
        break;
      case OrderOption.orderPopAsc:
        listaPaises.sort((a, b) => a.populacao.compareTo(b.populacao));
        break;
    }
  }

  _deletarPais(String id) async {
    await dbPais.deletePais(id);
    _atualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Países (Firebase)'),
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOption>(
            icon: const Icon(Icons.sort),
            onSelected: (OrderOption result) {
              setState(() {
                _currentOrder = result;
                _ordenarLista();
              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<OrderOption>>[
                  const PopupMenuItem(
                    value: OrderOption.orderAZ,
                    child: Text('Nome (A-Z)'),
                  ),
                  const PopupMenuItem(
                    value: OrderOption.orderZA,
                    child: Text('Nome (Z-A)'),
                  ),
                  const PopupMenuItem(
                    value: OrderOption.orderPopDesc,
                    child: Text('População (Maior > Menor)'),
                  ),
                  const PopupMenuItem(
                    value: OrderOption.orderPopAsc,
                    child: Text('População (Menor > Maior)'),
                  ),
                ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          bool? saved = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CadastroPaisPage()),
          );
          if (saved == true) _atualizarLista();
        },
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
        child: listaPaises.isEmpty
            ? const Center(
                child: Text(
                  'Nenhum país cadastrado.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                itemCount: listaPaises.length,
                itemBuilder: (context, index) {
                  Pais p = listaPaises[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: ListTile(
                      leading:
                          p.bandeira != null && File(p.bandeira!).existsSync()
                          ? SizedBox(
                              width: 60,
                              height: 40,
                              child: Image.file(
                                File(p.bandeira!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : const SizedBox(
                              width: 60,
                              height: 40,
                              child: Icon(Icons.flag, size: 30),
                            ),
                      title: Text('${p.nome} (${p.sigla})'),
                      subtitle: Text(
                        'Capital: ${p.capital} | Pop: ${p.populacao}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              bool? edited = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CadastroPaisPage(paisParaEditar: p),
                                ),
                              );
                              if (edited == true) _atualizarLista();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Excluir'),
                                  content: Text('Deseja excluir ${p.nome}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _deletarPais(p.id!);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Excluir'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
