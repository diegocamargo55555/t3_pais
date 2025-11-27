class Pais {
  int? id;
  String nome;
  String capital;
  int populacao;
  String sigla;
  String continente;
  String regimePolitico;
  String? bandeira; 

  Pais({
    this.id,
    required this.nome,
    required this.capital,
    required this.populacao,
    required this.sigla,
    required this.continente,
    required this.regimePolitico,
    this.bandeira, 
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'capital': capital,
      'populacao': populacao,
      'sigla': sigla,
      'continente': continente,
      'regime_politico': regimePolitico,
      'bandeira': bandeira, 
    };
  }

  factory Pais.fromMap(Map<String, dynamic> map) {
    return Pais(
      id: map['id'],
      nome: map['nome'],
      capital: map['capital'],
      populacao: map['populacao'],
      sigla: map['sigla'],
      continente: map['continente'],
      regimePolitico: map['regime_politico'],
      bandeira: map['bandeira'], 
    );
  }
}
