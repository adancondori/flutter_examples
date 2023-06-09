class Pokemon {
  final int id;
  final String name;
  final int base_experience;

  Pokemon({
    required this.id,
    required this.name,
    required this.base_experience,
  });

  factory Pokemon.fromMap(Map<String, dynamic> json) => Pokemon(
        id: json["id"],
        name: json["name"],
        base_experience: json["base_experience"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "base_experience": base_experience,
      };
}
