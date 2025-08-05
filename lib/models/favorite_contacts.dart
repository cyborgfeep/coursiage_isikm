final String tableContact = "contacts";
final String columnId = '_id';
final String columnName = 'name';
final String columnPhone = 'phone';

class FavoriteContact {
  int? id;
  String? name;
  String? phone;

  FavoriteContact({this.id, this.name, this.phone});
  Map<String, Object?> toMap() {
    var map = <String, Object?>{columnName: name, columnPhone: phone};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  FavoriteContact.fromMap(Map<dynamic, dynamic> map) {
    id = map[columnId] as int?;
    name = map[columnName] as String?;
    phone = map[columnPhone] as String?;
  }
}
