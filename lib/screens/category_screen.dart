import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/content_provider.dart';
import 'reader_screen.dart';
import '../widgets/ribbon_bookmark.dart';

class CategoryListScreen extends StatelessWidget {
  final String type;
  const CategoryListScreen({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContentProvider>();
    final contents = provider.getContentsByType(type);

    return Scaffold(
      backgroundColor: const Color(0xFFDFD7C7),
      appBar: AppBar(
        title: Text(type, style: const TextStyle(color: Color(0xFF483F29))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: contents.length,
        itemBuilder: (context, index) {
          final content = contents[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReaderScreen(content: content))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(content.coverPath, fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(color: Colors.grey)),
                        if (content.isFavorite)
                          const Positioned(
                            top: -2,
                            right: 12,
                            child: RibbonBookmark(),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF483F29)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  content.authorName,
                  style: TextStyle(fontSize: 12, color: const Color(0xFF483F29).withOpacity(0.7)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
