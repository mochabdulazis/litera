import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/content.dart';
import '../models/author.dart';

class ContentProvider extends ChangeNotifier {
  late Box<Content> _contentBox;
  late Box<Author> _authorBox;

  List<Content> _forYouList = [];
  List<Content> get forYouList => _forYouList;

  List<Author> _popularAuthors = [];
  List<Author> get popularAuthors => _popularAuthors;

  Content? _continueReadingContent;
  Content? get continueReadingContent => _continueReadingContent;

  Future<void> init() async {
    _contentBox = Hive.box<Content>('contents');
    _authorBox = Hive.box<Author>('authors');
    
    _loadDummyData();
    _fetchForYouList();
    _fetchPopularAuthors();
    _fetchContinueReading();
  }

  void _loadDummyData() {
    if (_contentBox.isEmpty) {
      _contentBox.put('c1', Content(id: 'c1', title: 'Senja di Jakarta', type: 'CERPEN', authorName: 'Pramoedya', coverPath: 'assets/images/cover1.webp', imagePages: ['assets/images/page1.webp']));
      _contentBox.put('c2', Content(id: 'c2', title: 'Hujan Bulan Juni', type: 'PUISI', authorName: 'Sapardi', coverPath: 'assets/images/cover2.webp', imagePages: ['assets/images/page2.webp']));
      _contentBox.put('c3', Content(id: 'c3', title: 'Si Juki', type: 'KOMIK', authorName: 'Faza Meonk', coverPath: 'assets/images/cover3.webp', imagePages: ['assets/images/page3.webp']));
    }
    if (_authorBox.isEmpty) {
      _authorBox.put('a1', Author(id: 'a1', name: 'Pramoedya', avatarPath: 'assets/images/author1.webp'));
      _authorBox.put('a2', Author(id: 'a2', name: 'Sapardi', avatarPath: 'assets/images/author2.webp'));
    }
  }

  void _fetchForYouList() {
    _forYouList = _contentBox.values.toList();
    notifyListeners();
  }

  void _fetchPopularAuthors() {
    _popularAuthors = _authorBox.values.toList();
    notifyListeners();
  }

  void _fetchContinueReading() {
    if (_contentBox.isNotEmpty) {
      final list = _contentBox.values.where((c) => c.lastReadTimestamp > 0).toList();
      if (list.isNotEmpty) {
        list.sort((a, b) => b.lastReadTimestamp.compareTo(a.lastReadTimestamp));
        _continueReadingContent = list.first;
      } else {
        _continueReadingContent = null; // Don't show if user hasn't read anything
      }
    } else {
      _continueReadingContent = null;
    }
    notifyListeners();
  }

  void updateReadingProgress(Content content, int page) {
    content.lastReadPage = page;
    content.lastReadTimestamp = DateTime.now().millisecondsSinceEpoch;
    content.save();
    _fetchContinueReading(); // This updates the UI automatically
  }

  List<Content> getContentsByType(String type) {
    return _contentBox.values.where((c) => c.type == type).toList();
  }

  List<Content> searchContent(String query) {
    if (query.trim().isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return _contentBox.values.where((c) {
      return c.title.toLowerCase().contains(lowerQuery) || c.authorName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  void toggleFavorite(Content content) {
    content.isFavorite = !content.isFavorite;
    content.save();
    notifyListeners();
  }
}
