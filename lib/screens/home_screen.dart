import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/content_provider.dart';
import 'category_screen.dart';
import 'reader_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const _HomeView(),
      const CategoryListScreen(type: "CERPEN"),
      const CategoryListScreen(type: "PUISI"),
      const CategoryListScreen(type: "KOMIK"),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF483F29),
        unselectedItemColor: const Color(0xFFA1AFB8),
        backgroundColor: const Color(0xFFDFD7C7),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: "Cerpen"),
          BottomNavigationBarItem(icon: Icon(Icons.history_edu), label: "Puisi"),
          BottomNavigationBarItem(icon: Icon(Icons.brush), label: "Komik"),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _currentIndex == 0 ? const _ContinueReadingFloating() : null,
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContentProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "LITERA",
          style: TextStyle(fontFamily: 'Serif', color: Color(0xFF483F29), fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text("For You", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF483F29))),
          ),
          SizedBox(
            height: 250,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: provider.forYouList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final content = provider.forYouList[index];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReaderScreen(content: content))),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.asset(content.coverPath, width: 160, height: 250, fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(width: 160, height: 250, color: Colors.grey)),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7A774A).withOpacity(0.85),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              content.type,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text("Penulis Terpopuler", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF483F29))),
          ),
          SizedBox(
            height: 100,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: provider.popularAuthors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final author = provider.popularAuthors[index];
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(author.avatarPath, width: 70, height: 70, fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(width: 70, height: 70, color: Colors.grey)),
                    ),
                    const SizedBox(height: 8),
                    Text(author.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF483F29))),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueReadingFloating extends StatelessWidget {
  const _ContinueReadingFloating({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final content = context.watch<ContentProvider>().continueReadingContent;
    if (content == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFDFD7C7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFA1AFB8).withOpacity(0.5)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(content.coverPath, width: 40, height: 60, fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(width: 40, height: 60, color: Colors.grey)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("CONTINUE READING", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF7A774A))),
                Text(content.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF483F29)), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_fill, size: 36, color: Color(0xFF483F29)),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReaderScreen(content: content))),
          ),
        ],
      ),
    );
  }
}
