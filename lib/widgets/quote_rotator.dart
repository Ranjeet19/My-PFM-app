import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/quote.dart';
import '../data/quotes_list.dart';

class QuoteRotator extends StatefulWidget {
  const QuoteRotator({super.key});

  @override
  State<QuoteRotator> createState() => _QuoteRotatorState();
}

class _QuoteRotatorState extends State<QuoteRotator> {
  int _currentIndex = 0;
  late Timer _timer;
  late Box<Quote> _favBox;

  @override
  void initState() {
    super.initState();
    _favBox = Hive.box<Quote>('favorites');
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % financeQuotes.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  bool isFavorite(String quoteText) {
    return _favBox.values.any((q) => q.text == quoteText);
  }

  void toggleFavorite(String quoteText) {
    final existing = _favBox.values.firstWhere(
        (q) => q.text == quoteText,
        orElse: () => Quote(text: ""));
    if (existing.text != "") {
      _favBox.delete(existing.key);
    } else {
      _favBox.add(Quote(text: quoteText));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final quote = financeQuotes[_currentIndex];
    final isFav = isFavorite(quote);

    return Stack(
      
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 4, offset: Offset(2, 3))
            ],
          ),
          child: Text(
            '"$quote"',
            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
        ),

        SizedBox(height: 15,),
        Positioned(
          top: 3,
          right: 0,
          child: IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () => toggleFavorite(quote),
          ),
        ),
      ],
    );
  }
}
