import 'dart:math';

class DataSource {
  String getAnswer() {
    final randomIndex = Random().nextInt(memberList.length);

    return loadMemberList()[randomIndex];
  }

  List<String> loadMemberList() {
    return memberList
        .map((member) => (member["name"] ?? "").toUpperCase())
        .toList();
  }

  final memberList = [
    {"name": "Ashel"},
    {"name": "Christy"},
    // {"name": "Anin"},
    {"name": "Zee"},
    // {"name": "Cindy"},
    {"name": "Oniel"},
    // {"name": "Dey"},
    {"name": "Olla"},
    {"name": "Feni"},
    {"name": "Fiony"},
    {"name": "Flora"},
    {"name": "Sisca"},
    {"name": "Freya"},
    // {"name": "Gaby"},
    {"name": "Gita"},
    {"name": "Eli"},
    {"name": "Indah"},
    {"name": "Jessi"},
    {"name": "Jesslyn"},
    // {"name": "Jinan"},
    {"name": "Kathrina"},
    {"name": "Lulu"},
    {"name": "Marsha"},
    {"name": "Muthe"},
    {"name": "Adel"},
    {"name": "Shani"},
    {"name": "Gracia"},
    // {"name": "Celine"},
    {"name": "Chika"},
    // {"name": "Giselle"},
    {"name": "Amanda"},
    {"name": "Lia"},
    {"name": "Callie"},
    {"name": "Ella"},
    {"name": "Indira"},
    {"name": "Lyn"},
    {"name": "Raisha"},
    {"name": "Alya"},
    {"name": "Anindya"},
    // {"name": "Aulia"},
    {"name": "Cathy"},
    {"name": "Elin"},
    {"name": "Chelsea"},
    {"name": "Cynthia"},
    {"name": "Danella"},
    {"name": "Daisy"},
    {"name": "Gendis"},
    {"name": "Gracie"},
    {"name": "Greesel"},
    {"name": "Jeane"},
    {"name": "Michie"},
  ];
}
