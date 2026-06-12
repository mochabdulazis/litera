import 'package:flutter/material.dart';
import '../models/content.dart';

enum ReadingMode { webtoon, book, slide, tap }

class ReaderScreen extends StatefulWidget {
  final Content content;
  const ReaderScreen({Key? key, required this.content}) : super(key: key);

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  ReadingMode _currentMode = ReadingMode.webtoon;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    PaintingBinding.instance.imageCache.maximumSize = 50; 
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50 MB limits
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    super.dispose();
  }

  void _changeMode(ReadingMode mode) {
    setState(() => _currentMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black45,
        elevation: 0,
        title: Text(widget.content.title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        actions: [
          PopupMenuButton<ReadingMode>(
            icon: const Icon(Icons.settings),
            onSelected: _changeMode,
            itemBuilder: (context) => [
              const PopupMenuItem(value: ReadingMode.webtoon, child: Text("Webtoon Scroll")),
              const PopupMenuItem(value: ReadingMode.book, child: Text("Book Curl")),
              const PopupMenuItem(value: ReadingMode.slide, child: Text("Horizontal Slide")),
              const PopupMenuItem(value: ReadingMode.tap, child: Text("Tap Navigation")),
            ],
          )
        ],
      ),
      body: _buildReaderBody(),
    );
  }

  Widget _buildReaderBody() {
    switch (_currentMode) {
      case ReadingMode.webtoon:
        return ListView.builder(
          itemCount: widget.content.imagePages.length,
          itemBuilder: (context, index) {
            return Image.asset(
              widget.content.imagePages[index],
              fit: BoxFit.fitWidth,
              cacheWidth: MediaQuery.of(context).size.width.toInt() * 2,
              errorBuilder: (c, e, s) => const SizedBox(height: 200, child: Center(child: Icon(Icons.error, color: Colors.white))),
            );
          },
        );
      case ReadingMode.book:
      case ReadingMode.slide:
        return PageView.builder(
          controller: _pageController,
          itemCount: widget.content.imagePages.length,
          itemBuilder: (context, index) {
            return _OptimizedReaderImage(imagePath: widget.content.imagePages[index]);
          },
        );
      case ReadingMode.tap:
        return GestureDetector(
          onTapUp: (details) {
            final width = MediaQuery.of(context).size.width;
            final dx = details.globalPosition.dx;
            if (dx < width * 0.3) {
              _pageController.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
            } else if (dx > width * 0.7) {
              _pageController.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
            }
          },
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.content.imagePages.length,
            itemBuilder: (context, index) {
               return _OptimizedReaderImage(imagePath: widget.content.imagePages[index]);
            },
          ),
        );
    }
  }
}

class _OptimizedReaderImage extends StatelessWidget {
  final String imagePath;
  const _OptimizedReaderImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Image.asset(
      imagePath,
      fit: BoxFit.contain,
      cacheWidth: size.width.toInt() * 2, 
      errorBuilder: (c, e, s) => const Center(child: Icon(Icons.error, color: Colors.white)),
    );
  }
}
