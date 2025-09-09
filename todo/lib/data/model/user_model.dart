class AppUser {
  final String id;
  final String name;

  const AppUser({required this.id, required this.name});
}

final users = [
  AppUser(id: '', name: "Select User"),
  AppUser(id: "u1", name: "Alice"),
  AppUser(id: "u2", name: "Bob"),
  AppUser(id: "u3", name: "Charlie"),
];
