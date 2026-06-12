import 'package:hive/hive.dart';

class Author extends HiveObject {
  final String id;
  final String name;
  final String avatarPath;

  Author({
    required this.id,
    required this.name,
    required this.avatarPath,
  });
}

class AuthorAdapter extends TypeAdapter<Author> {
  @override
  final int typeId = 1;

  @override
  Author read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Author(
      id: fields[0] as String,
      name: fields[1] as String,
      avatarPath: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Author obj) {
    writer.writeByte(3);
    writer.writeByte(0); writer.write(obj.id);
    writer.writeByte(1); writer.write(obj.name);
    writer.writeByte(2); writer.write(obj.avatarPath);
  }
}
