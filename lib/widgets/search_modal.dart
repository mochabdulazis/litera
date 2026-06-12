import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/content.dart';
import '../providers/content_provider.dart';
import '../screens/reader_screen.dart';

class SearchModal extends StatefulWidget {
  const SearchModal({Key? key}) : super(key: key);

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final TextEditingController _controller = TextEditingController();
  List<Content> _results = [];

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() => _results = []);
      return;
    }
    final results = context.read<ContentProvider>().searchContent(query);
    setState(() => _results = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          color: const Color(0xFFDFD7C7).withOpacity(0.65), // Semi-transparent cream
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      onChanged: _onSearch,
                      style: const TextStyle(color: Color(0xFF483F29), fontSize: 18),
                      decoration: InputDecoration(
                        hintText: "Cari judul atau penulis...",
                        hintStyle: TextStyle(color: const Color(0xFF483F29).withOpacity(0.5)),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF483F29)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.6),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF483F29), size: 30),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: _results.isEmpty && _controller.text.isNotEmpty
                    ? const Center(child: Text("Tidak ditemukan hasil yang cocok.", style: TextStyle(color: Color(0xFF483F29))))
                    : ListView.separated(
                        itemCount: _results.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final content = _results[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(content.coverPath, width: 50, height: 75, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 50, color: Colors.grey)),
                            ),
                            title: Text(content.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF483F29))),
                            subtitle: Text(content.authorName, style: const TextStyle(color: Color(0xFF483F29))),
                            onTap: () {
                              Navigator.pop(context); // Close modal
                              Navigator.push(context, MaterialPageRoute(builder: (_) => ReaderScreen(content: content)));
                            },
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
