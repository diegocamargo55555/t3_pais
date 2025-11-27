class Pais {
  String? id;
  String nome;
  String capital;
  int populacao;
  String sigla;
  String continente;
  String regimePolitico;
  String? bandeira;
  String descricao;
  String link; 

  Pais({
    this.id,
    required this.nome,
    required this.capital,
    required this.populacao,
    required this.sigla,
    required this.continente,
    required this.regimePolitico,
    this.bandeira,
    required this.descricao,
    required this.link,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'capital': capital,
      'populacao': populacao,
      'sigla': sigla,
      'continente': continente,
      'regime_politico': regimePolitico,
      'bandeira': bandeira,
      'descricao': descricao, 
      'link': link, 
    };
  }

  factory Pais.fromMap(Map<String, dynamic> map, String docId) {
    return Pais(
      id: docId,
      nome: map['nome'] ?? '',
      capital: map['capital'] ?? '',
      populacao: map['populacao'] ?? 0,
      sigla: map['sigla'] ?? '',
      continente: map['continente'] ?? '',
      regimePolitico: map['regime_politico'] ?? '',
      bandeira: map['bandeira'],
      descricao: map['descricao'] ?? '',
      link: map['link'] ?? '', 
    );
  }
}
