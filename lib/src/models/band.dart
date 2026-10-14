
class Band {

  String id, name;
  int votes;

  Band({required this.id, required this.name, this.votes = 0});

  factory Band.fromMap(Map<String, dynamic> json) =>
    Band(
      id: json['id'] ?? 'no-id',  
      name: json['name'] ?? 'no-name',
      votes: json['votes'] ?? 0
    );

}