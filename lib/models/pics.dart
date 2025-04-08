class Pics {
  final int id;
  final String name;
  final String path;
  final String uploadDate;

  Pics({
    required this.id,
    required this.name,
    required this.path,
    required this.uploadDate,
  });

  // convert json to obj
  factory Pics.fromJson(Map<String, dynamic> json) {
    return Pics(
      id: json['ID'],
      name: json['name'],
      path: json['path'],
      uploadDate: json['upload_date'],
    );
  }

  // obj --> json
  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'name': name,
      'path': path,
      'upload_date': uploadDate,
    };
  }
}
