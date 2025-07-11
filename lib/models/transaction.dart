class Transaction {
  int montant;
  String titre;
  DateTime dateTime;
  TType transactionType;

  Transaction({
    required this.montant,
    required this.titre,
    required this.dateTime,
    required this.transactionType,
  });

  static List<Transaction> transactionList = [
    Transaction(
      montant: 10000,
      titre: "Dépôt",
      dateTime: DateTime.now(),
      transactionType: TType.depot,
    ),
    Transaction(
      montant: 5000,
      titre: "Retrait",
      dateTime: DateTime.now(),
      transactionType: TType.retrait,
    ),
    Transaction(
      montant: 2000,
      titre: "Modou Sarr 77 777 77 77",
      dateTime: DateTime.now(),
      transactionType: TType.envoi,
    ),
    Transaction(
      montant: 1000,
      titre: "Canal +",
      dateTime: DateTime.now(),
      transactionType: TType.paiement,
    ),
    Transaction(
      montant: 500,
      titre: "Fatou Diagne 77 777 77 76",
      dateTime: DateTime.now(),
      transactionType: TType.reception,
    ),
  ];
}

enum TType { depot, retrait, envoi, paiement, reception }
