
class City {
  int id;
  String name;
  
  City({ this.id, this.name });

  factory City.fromMap(Map<String, dynamic> data) => new City(
    id: data["id"],
    name: data["name"],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}