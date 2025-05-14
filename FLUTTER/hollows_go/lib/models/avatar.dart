class Avatar {
  final int id;
  final String url;

  Avatar({required this.id, required this.url});

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      id: json['id'],
      url: json['url'],
    );
  }
}
