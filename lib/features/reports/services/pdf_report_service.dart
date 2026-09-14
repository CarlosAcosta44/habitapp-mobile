import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/foundation.dart';

class PdfReportService {
  static Future<void> generateAndDownloadPdf(Map<String, dynamic> data) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(level: 0, child: pw.Text("Reporte de Hábitos - HabitApp")),
                pw.SizedBox(height: 20),
                pw.Text("Cumplimiento Global: ${data['cumplimiento_global']}%", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Text("${data['total_cumplido']} de ${data['total_esperado']} hábitos completados"),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Racha Actual: ${data['racha_actual']} días"),
                    pw.Text("Racha Máxima: ${data['racha_maxima']} días"),
                  ]
                ),
                pw.SizedBox(height: 20),
                if (data['mas_constante'] != null) ...[
                  pw.Text("Hábito más constante:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("${data['mas_constante']['nombre']} - ${data['mas_constante']['racha']} días seguidos (${data['mas_constante']['rate']}%)"),
                  pw.SizedBox(height: 10),
                ],
                if (data['oportunidad_mejora'] != null) ...[
                  pw.Text("Oportunidad de mejora:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("${data['oportunidad_mejora']['nombre']} (${data['oportunidad_mejora']['rate']}%)"),
                  pw.SizedBox(height: 20),
                ],
                pw.Header(level: 1, child: pw.Text("Insight Inteligente")),
                pw.Text(data['insight'] ?? 'Continúa así.'),
              ],
            );
          },
        ),
      );

      // INFO 1: Guardar o Compartir el PDF
      // El paquete printing se encarga de manejar automáticamente el guardado o 
      // visualización de manera compatible con Web, Android y iOS.
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'reporte_habitos.pdf',
      );

      debugPrint("PDF generado y enviado para descarga/compartir.");
    } catch (e) {
      debugPrint("Error generando PDF: $e");
    }
  }
}
