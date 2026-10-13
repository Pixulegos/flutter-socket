
class Band {

  String id, name;
  int votes;

  Band({required this.id, required this.name, this.votes = 0});

  factory Band.fromMap(Map<String, dynamic> json) =>
    Band(
      id: json['id'], 
      name: json['name'],
      votes: json['votes']
    );

}