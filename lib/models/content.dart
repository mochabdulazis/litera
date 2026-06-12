import 'package:hive/hive.dart';

class Content extends HiveObject {
  final String id;
  final String title;
  final String type; // "CERPEN", "PUISI", "KOMIK"
  final String authorName;
  final String coverPath;
  final List<String> imagePages;
  bool isFavorite;
  int lastReadPage;
  int lastReadTimestamp;

  Content({
    required this.id,
    required this.title,
    required this.type,
    required this.authorName,
    required this.coverPath,
    required this.imagePages,
    this.isFavorite = false,
    this.lastReadPage = 0,
    this.lastReadTimestamp = 0,
  });
}

class ContentAdapter extends TypeAdapter<Content> {
  @override
  final int typeId = 0;

  @override
  Content read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Content(
      id: fields[0] as String,
      title: fields[1] as String,
      type: fields[2] as String,
      authorName: fields[3] as String,
      coverPath: fields[4] as String,
      imagePages: (fields[5] as List).cast<String>(),
      isFavorite: fields[6] as bool? ?? false,
      lastReadPage: fields[7] as int? ?? 0,
      lastReadTimestamp: fields[8] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, Content obj) {
    writer.writeByte(9);
    writer.writeByte(0); writer.write(obj.id);
    writer.writeByte(1); writer.write(obj.title);
    writer.writeByte(2); writer.write(obj.type);
    writer.writeByte(3); writer.write(obj.authorName);
    writer.writeByte(4); writer.write(obj.coverPath);
    writer.writeByte(5); writer.write(obj.imagePages);
    writer.writeByte(6); writer.write(obj.isFavorite);
    writer.writeByte(7); writer.write(obj.lastReadPage);
    writer.writeByte(8); writer.write(obj.lastReadTimestamp);
  }
}
