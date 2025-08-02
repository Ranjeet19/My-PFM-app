import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/quote.dart';

class FavoriteQuotesScreen extends StatelessWidget {
  const FavoriteQuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favBox = Hive.box<Quote>('favorites');
    final favorites = favBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("❤️ Favorite Quotes", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      backgroundColor: const Color(0xFFE8FCEF),
      body: favorites.isEmpty
          ? const Center(child: Text("No favorite quotes yet."))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(2, 3))
                    ],
                  ),
                  child: Text(
                    '"${favorites[index].text}"',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
    );
  }
}
