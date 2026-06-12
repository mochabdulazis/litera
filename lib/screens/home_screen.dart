import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/content_provider.dart';
import 'category_screen.dart';
import 'reader_screen.dart';
import '../models/content.dart';
import '../widgets/ribbon_bookmark.dart';

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
      bottomNavigationBar: _buildCustomBottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _currentIndex == 0
            ? const _ContinueReadingFloating(key: ValueKey('continue_reading_widget'))
            : const SizedBox.shrink(key: ValueKey('empty_widget')),
      ),
    );
  }

  Widget _buildCustomBottomNav() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFFEFE8DA), // Matched lighter background
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, 'Home', 'assets/icons/home'),
          _buildNavItem(1, 'Cerpen', 'assets/icons/cerpen'),
          _buildNavItem(2, 'Puisi', 'assets/icons/puisi'),
          _buildNavItem(3, 'Komik', 'assets/icons/komik'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String iconPrefix) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF483F29) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
              child: Image.asset(
                isSelected ? '${iconPrefix}_active.png' : '${iconPrefix}_inactive.png',
                key: ValueKey(isSelected ? 'active' : 'inactive'),
                width: 24,
                height: 24,
                errorBuilder: (c, e, s) => Icon(
                  index == 0 ? Icons.home : index == 1 ? Icons.menu_book : index == 2 ? Icons.history_edu : Icons.brush,
                  key: ValueKey(isSelected ? 'icon_active' : 'icon_inactive'),
                  color: isSelected ? Colors.white : const Color(0xFF483F29),
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              child: isSelected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
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
        leading: const Icon(Icons.menu_book, color: Color(0xFF483F29)),
        title: const Text(
          "LITERA",
          style: TextStyle(fontFamily: 'Serif', color: Color(0xFF483F29), fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF483F29)),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text("For You", style: TextStyle(fontFamily: 'Serif', fontSize: 22, color: Color(0xFF483F29))),
          ),
          SizedBox(
            height: 300,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: provider.forYouList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final content = provider.forYouList[index];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReaderScreen(content: content))),
                  child: SizedBox(
                    width: 180,
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
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      content.type,
                                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                if (content.isFavorite)
                                  const Positioned(
                                    top: -2,
                                    right: 16,
                                    child: RibbonBookmark(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          content.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF483F29), fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          content.authorName,
                          style: TextStyle(fontSize: 12, color: const Color(0xFF483F29).withOpacity(0.7)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          Divider(
            color: const Color(0xFF483F29).withOpacity(0.15),
            thickness: 1,
            indent: 32,
            endIndent: 32,
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text("Penulis Terpopuler", style: TextStyle(fontFamily: 'Serif', fontSize: 22, color: Color(0xFF483F29))),
          ),
          SizedBox(
            height: 90,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: provider.popularAuthors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 24),
              itemBuilder: (context, index) {
                final author = provider.popularAuthors[index];
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF483F29).withOpacity(0.1)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(author.avatarPath, width: 60, height: 60, fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(width: 60, height: 60, color: Colors.grey)),
                      ),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEE6),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(content.coverPath, width: 40, height: 50, fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(width: 40, height: 50, color: Colors.grey)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("CONTINUE READING", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF7A774A), letterSpacing: 0.5)),
                const SizedBox(height: 2),
                Text(content.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF483F29), fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: content.imagePages.length > 1 ? content.lastReadPage / (content.imagePages.length - 1) : 0,
                    backgroundColor: const Color(0xFFA1AFB8).withOpacity(0.3),
                    color: const Color(0xFF7A774A),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReaderScreen(content: content))),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF483F29),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}
