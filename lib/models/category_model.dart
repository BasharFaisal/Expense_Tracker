class Category {
  int? id;
  String name;
  String? icon;
  int userId;

  Category({
    this.id,
    required this.name,
    this.icon,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'user_id': userId,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
      userId: map['user_id'],
    );
  }
}
