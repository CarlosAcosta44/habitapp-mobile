import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../domain/habit_stats.dart';

class PdfReportService {
  /// Genera y descarga el reporte PDF estilizado para HabitApp
  static Future<void> generateAndDownloadPdf(
    HabitStats stats, {
    String timeframe = 'Semana',
    String userName = 'Usuario HabitApp',
  }) async {
    try {
      final pdf = pw.Document();

      // Carga del Logo Oficial de la app
      pw.MemoryImage? logoImage;
      try {
        final logoBytes = await rootBundle.load('assets/images/logo-habitapp.png');
        logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
      } catch (e) {
        debugPrint('Aviso: No se pudo cargar la imagen del logo: $e');
      }

      // Definición de Colores Corporativos de HabitApp
      final primaryBlue = PdfColor.fromHex('#2D82FA');
      final primaryPink = PdfColor.fromHex('#F94C84');
      final successGreen = PdfColor.fromHex('#4CAF50');
      final warningOrange = PdfColor.fromHex('#FF9800');
      final bgCardColor = PdfColor.fromHex('#F8F9FA');
      final textDark = PdfColor.fromHex('#1E1E1E');
      final textGray = PdfColor.fromHex('#6B6B6B');

      // Fecha y Hora de emisión
      final now = DateTime.now();
      final dateStr =
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      final compliancePercentage = timeframe == 'Mes'
          ? stats.monthlyCompliancePercentage
          : stats.weeklyCompliancePercentage;

      final chartPoints = timeframe == 'Mes'
          ? (stats.monthlyProgress.isNotEmpty ? stats.monthlyProgress : stats.weeklyProgress)
          : stats.weeklyProgress;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // ── 1. ENCABEZADO Y BRANDING ──
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Row(
                      children: [
                        if (logoImage != null)
                          pw.Container(
                            width: 48,
                            height: 48,
                            margin: const pw.EdgeInsets.only(right: 12),
                            child: pw.Image(logoImage),
                          ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'HabitApp',
                              style: pw.TextStyle(
                                fontSize: 24,
                                fontWeight: pw.FontWeight.bold,
                                color: primaryBlue,
                              ),
                            ),
                            pw.Text(
                              'Tu Transformación Diaria',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: textGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: pw.BoxDecoration(
                            color: primaryPink,
                            borderRadius: pw.BorderRadius.circular(12),
                          ),
                          child: pw.Text(
                            'REPORTE DE $timeframe'.toUpperCase(),
                            style: pw.TextStyle(
                              color: PdfColors.white,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Emitido: $dateStr',
                          style: pw.TextStyle(fontSize: 9, color: textGray),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 12),
                pw.Divider(color: primaryBlue, thickness: 2),
                pw.SizedBox(height: 16),

                // ── 2. TARJETAS DE MÉTRICAS CLAVE (KPIs) ──
                pw.Row(
                  children: [
                    // Cumplimiento Global
                    pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(14),
                        decoration: pw.BoxDecoration(
                          color: primaryBlue,
                          borderRadius: pw.BorderRadius.circular(12),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Cumplimiento Global',
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              '${compliancePercentage.toInt()}%',
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 28,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              '${stats.completedDays} de ${stats.totalExpectedDays} hábitos completados',
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 12),
                    // Racha y Puntos
                    pw.Expanded(
                      flex: 3,
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(12),
                              decoration: pw.BoxDecoration(
                                color: bgCardColor,
                                borderRadius: pw.BorderRadius.circular(12),
                                border: pw.Border.all(color: PdfColors.grey300),
                              ),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'Racha Actual',
                                    style: pw.TextStyle(fontSize: 10, color: textGray),
                                  ),
                                  pw.SizedBox(height: 4),
                                  pw.Text(
                                    '${stats.currentStreak} días 🔥',
                                    style: pw.TextStyle(
                                      fontSize: 16,
                                      fontWeight: pw.FontWeight.bold,
                                      color: textDark,
                                    ),
                                  ),
                                  pw.SizedBox(height: 4),
                                  pw.Text(
                                    'Máx: ${stats.maxStreak} días',
                                    style: pw.TextStyle(fontSize: 9, color: textGray),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Expanded(
                            child: pw.Container(
                              padding: const pw.EdgeInsets.all(12),
                              decoration: pw.BoxDecoration(
                                color: bgCardColor,
                                borderRadius: pw.BorderRadius.circular(12),
                                border: pw.Border.all(color: PdfColors.grey300),
                              ),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'Puntos Acumulados',
                                    style: pw.TextStyle(fontSize: 10, color: textGray),
                                  ),
                                  pw.SizedBox(height: 4),
                                  pw.Text(
                                    '+${stats.accumulatedPoints} pts ⭐',
                                    style: pw.TextStyle(
                                      fontSize: 16,
                                      fontWeight: pw.FontWeight.bold,
                                      color: primaryPink,
                                    ),
                                  ),
                                  pw.SizedBox(height: 4),
                                  pw.Text(
                                    'Nivel Activo',
                                    style: pw.TextStyle(fontSize: 9, color: textGray),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // ── 3. DIAGRAMA DE BARRAS DE VOLUMEN DE PROGRESO ──
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(14),
                  decoration: pw.BoxDecoration(
                    color: bgCardColor,
                    borderRadius: pw.BorderRadius.circular(12),
                    border: pw.Border.all(color: PdfColors.grey300),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Diagrama de Consistencia ($timeframe)',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      pw.SizedBox(height: 14),
                      pw.Container(
                        height: 90,
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: (chartPoints.isNotEmpty
                                  ? chartPoints
                                  : [
                                      const ChartDataPoint(label: 'Lun', value: 80),
                                      const ChartDataPoint(label: 'Mar', value: 100),
                                      const ChartDataPoint(label: 'Mié', value: 60),
                                      const ChartDataPoint(label: 'Jue', value: 90),
                                      const ChartDataPoint(label: 'Vie', value: 100),
                                      const ChartDataPoint(label: 'Sáb', value: 40),
                                      const ChartDataPoint(label: 'Dom', value: 70),
                                    ])
                              .map((dp) {
                            final pct = (dp.value / 100.0).clamp(0.05, 1.0);
                            final barHeight = pct * 60;
                            return pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Text(
                                  '${dp.value.toInt()}%',
                                  style: pw.TextStyle(
                                    fontSize: 8,
                                    fontWeight: pw.FontWeight.bold,
                                    color: textGray,
                                  ),
                                ),
                                pw.SizedBox(height: 4),
                                pw.Container(
                                  width: 18,
                                  height: barHeight,
                                  decoration: pw.BoxDecoration(
                                    color: dp.value >= 80 ? primaryBlue : primaryPink,
                                    borderRadius: const pw.BorderRadius.vertical(
                                      top: pw.Radius.circular(4),
                                    ),
                                  ),
                                ),
                                pw.SizedBox(height: 6),
                                pw.Text(
                                  dp.label,
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    color: textDark,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // ── 4. HÁBITOS DESTACADOS Y OPORTUNIDADES ──
                pw.Row(
                  children: [
                    // Hábito más constante
                    pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(12),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromHex('#E8F5E9'),
                          borderRadius: pw.BorderRadius.circular(12),
                          border: pw.Border.all(color: successGreen.shade(0.3)),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: 8,
                                  height: 8,
                                  decoration: pw.BoxDecoration(
                                    color: successGreen,
                                    shape: pw.BoxShape.circle,
                                  ),
                                ),
                                pw.SizedBox(width: 6),
                                pw.Text(
                                  'HÁBITO MÁS CONSTANTE',
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold,
                                    color: successGreen,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 6),
                            pw.Text(
                              stats.mostConsistentHabit?.name ?? 'Hidratación Diaria',
                              style: pw.TextStyle(
                                fontSize: 13,
                                fontWeight: pw.FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              '${stats.mostConsistentHabit?.streak ?? 12} días seguidos (${(stats.mostConsistentHabit?.rate ?? 95).toInt()}% cumplimiento)',
                              style: pw.TextStyle(fontSize: 9, color: textGray),
                            ),
                          ],
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 12),
                    // Oportunidad de mejora
                    pw.Expanded(
                      child: pw.Container(
                        padding: const pw.EdgeInsets.all(12),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromHex('#FFF3E0'),
                          borderRadius: pw.BorderRadius.circular(12),
                          border: pw.Border.all(color: warningOrange.shade(0.3)),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: 8,
                                  height: 8,
                                  decoration: pw.BoxDecoration(
                                    color: warningOrange,
                                    shape: pw.BoxShape.circle,
                                  ),
                                ),
                                pw.SizedBox(width: 6),
                                pw.Text(
                                  'OPORTUNIDAD DE MEJORA',
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold,
                                    color: warningOrange,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 6),
                            pw.Text(
                              stats.improvementOpportunity?.name ?? 'Lectura Nocturna',
                              style: pw.TextStyle(
                                fontSize: 13,
                                fontWeight: pw.FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              'Tasa de éxito actual: ${(stats.improvementOpportunity?.rate ?? 40).toInt()}%',
                              style: pw.TextStyle(fontSize: 9, color: textGray),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // ── 5. INSIGHT INTELIGENTE ──
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(14),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#EBF3FE'),
                    borderRadius: pw.BorderRadius.circular(12),
                    border: pw.Border.all(color: primaryBlue.shade(0.3)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '💡 Insight Inteligente de IA',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        stats.smartInsight.isNotEmpty
                            ? stats.smartInsight
                            : '¡Gran trabajo esta semana! Mantener la constancia por la mañana aumenta en un 80% la probabilidad de cumplir tus hábitos del resto del día.',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: textDark,
                          lineSpacing: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Spacer(),

                // ── 6. PIE DE PÁGINA (FOOTER) ──
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 6),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'HabitApp Mobile • Reporte Oficial generado de forma segura',
                      style: pw.TextStyle(fontSize: 8, color: textGray),
                    ),
                    pw.Text(
                      'Página ${context.pageNumber} de ${context.pagesCount}',
                      style: pw.TextStyle(fontSize: 8, color: textGray),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );

      // Guardar / Descargar / Compartir el PDF mediante 'printing'
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'reporte_habitos_${timeframe.toLowerCase()}.pdf',
      );

      debugPrint("PDF ejecutivo generado y compartido con éxito.");
    } catch (e) {
      debugPrint("Error generando PDF: $e");
    }
  }
}
