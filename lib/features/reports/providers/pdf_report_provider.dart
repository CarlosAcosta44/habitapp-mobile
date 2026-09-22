import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/habit_stats.dart';
import '../data/repositories/pdf_report_repository.dart';

/// State for PDF generation: idle, loading, done, or error.
enum PdfGenerationStatus { idle, loading, done, error }

class PdfReportState {
  final PdfGenerationStatus status;
  final String? errorMessage;
  const PdfReportState({this.status = PdfGenerationStatus.idle, this.errorMessage});
}

/// Notifier that wraps [PdfReportRepository] so the presentation layer
/// never imports the repository directly.
class PdfReportNotifier extends Notifier<PdfReportState> {
  @override
  PdfReportState build() => const PdfReportState();

  Future<void> generateAndDownload(
    HabitStats stats, {
    String timeframe = 'Semana',
    String userName = 'Usuario HabitApp',
  }) async {
    state = const PdfReportState(status: PdfGenerationStatus.loading);
    try {
      await PdfReportRepository.generateAndDownloadPdf(
        stats,
        timeframe: timeframe,
        userName: userName,
      );
      state = const PdfReportState(status: PdfGenerationStatus.done);
    } catch (e) {
      state = PdfReportState(
        status: PdfGenerationStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

final pdfReportProvider =
    NotifierProvider<PdfReportNotifier, PdfReportState>(PdfReportNotifier.new);
