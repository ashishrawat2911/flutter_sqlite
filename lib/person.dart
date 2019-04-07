import 'dart:convert';

Person clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Person.fromMap(jsonData);
}

String clientToJson(Person data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Person {
  int id;
  String name;
  String city;

  Person({this.id, this.name, this.city});

  factory Person.fromMap(Map<String, dynamic> json) => new Person(
        id: json["id"],
        name: json["name"],
        city: json["city"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "city": city,
      };
}
