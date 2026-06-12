import 'package:hive_flutter/hive_flutter.dart';
import '../models/content.dart';
import '../models/author.dart';

class HiveService {
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ContentAdapter());
    Hive.registerAdapter(AuthorAdapter());
    
    await Hive.openBox<Content>('contents');
    await Hive.openBox<Author>('authors');
  }
}
