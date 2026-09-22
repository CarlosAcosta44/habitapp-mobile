import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';

part 'quotes_service.g.dart';

class Quote {
  final String phrase;
  final String author;

  Quote({required this.phrase, required this.author});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      phrase: json['phrase'] ?? 'Cada día es una nueva oportunidad.',
      author: json['author'] ?? 'HabitApp',
    );
  }
}

class QuotesService {
  final Dio _dio;

  QuotesService(this._dio);

  Future<Quote> getDailyQuote() async {
    try {
      final response = await _dio.get('/admin/quotes/daily');
      return Quote.fromJson(response.data);
    } catch (e) {
      // Fallback
      return Quote(phrase: 'Transforma tus metas en hábitos y tus hábitos en realidad.', author: 'HabitApp');
    }
  }
}

@riverpod
QuotesService quotesService(Ref ref) {
  return QuotesService(ref.watch(dioClientProvider));
}
