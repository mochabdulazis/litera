import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/content_provider.dart';
import 'category_screen.dart';
import 'reader_screen.dart';
import '../models/content.dart';
import '../widgets/ribbon_bookmark.dart';
import '../widgets/search_modal.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

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
      extendBody: true, // Needed for curved_navigation_bar transparent background
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: <Widget>[
          _buildNavIcon(0, 'assets/icons/home'),
          _buildNavIcon(1, 'assets/icons/cerpen'),
          _buildNavIcon(2, 'assets/icons/puisi'),
          _buildNavIcon(3, 'assets/icons/komik'),
        ],
        color: const Color(0xFF483F29), // Dark Olive Brown
        buttonBackgroundColor: const Color(0xFF7A774A), // Accent Green
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }

  Widget _buildNavIcon(int index, String iconPrefix) {
    // Both background and active button are dark, so we use the bright icons.
    return Padding(
      padding: const EdgeInsets.all(8.0), // Padding to make it fit nicely
      child: Image.asset(
        '${iconPrefix}_active.png',
        width: 30,
        height: 30,
        errorBuilder: (c, e, s) => Icon(
          index == 0 ? Icons.home : index == 1 ? Icons.menu_book : index == 2 ? Icons.history_edu : Icons.brush,
          color: Colors.white,
          size: 30,
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
            onPressed: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: "SearchModal",
                barrierColor: Colors.transparent, // Custom BackdropFilter handles color
                transitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (context, animation, secondaryAnimation) {
                  return const SearchModal();
                },
                transitionBuilder: (context, animation, secondaryAnimation, child) {
                  final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
                  return AnimatedBuilder(
                    animation: curvedAnimation,
                    builder: (context, childWidget) {
                      return ClipPath(
                        clipper: CircularRevealClipper(
                          fraction: curvedAnimation.value,
                          center: Offset(MediaQuery.of(context).size.width - 40, 50), // Position of search icon
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: childWidget,
                        ),
                      );
                    },
                    child: FadeTransition(
                      opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
                      child: child,
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120, top: 16),
        children: [
          if (provider.continueReadingContent != null)
            const Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: _ContinueReadingFloating(key: ValueKey('continue_reading_widget')),
            ),
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

class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset center;

  CircularRevealClipper({required this.fraction, required this.center});

  @override
  Path getClip(Size size) {
    final maxRadius = _calcMaxRadius(size, center);
    final path = Path();
    path.addOval(Rect.fromCircle(center: center, radius: maxRadius * fraction));
    return path;
  }

  double _calcMaxRadius(Size size, Offset center) {
    final dx = math.max(center.dx, size.width - center.dx);
    final dy = math.max(center.dy, size.height - center.dy);
    return math.sqrt(dx * dx + dy * dy);
  }

  @override
  bool shouldReclip(covariant CircularRevealClipper oldClipper) {
    return fraction != oldClipper.fraction || center != oldClipper.center;
  }
}
