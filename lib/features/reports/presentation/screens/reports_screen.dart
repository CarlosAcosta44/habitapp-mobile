import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/habit_stats.dart';
import '../../providers/reports_provider.dart';
import '../../data/services/pdf_report_service.dart';

const _kGreen = Color(0xFF4CAF50);
const _kOrange = Color(0xFFFF9800);

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(habitStatsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Progreso y Métricas',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow
                        .withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.ios_share,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            // INFO 3: Lógica para Compartir
            // Aquí se conectará el botón superior derecho con la librería 'share_plus'
            // para enviar una captura del reporte o los datos principales por redes sociales.
            onPressed: () {},
          ),
          SizedBox(width: 8),
        ],
      ),
      body: reportAsync.when(
        data: (stats) => _buildBody(stats),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildBody(HabitStats stats) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSegmentedControl(),
          SizedBox(height: 20),
          _buildGlobalCompliance(stats),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStreakCard(
                  'Racha actual',
                  '${stats.currentStreak} días',
                  'Activa hoy',
                  true,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStreakCard(
                  'Racha máxima',
                  '${stats.maxStreak} días',
                  'Récord histórico',
                  false,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildInsightsCards(stats),
          SizedBox(height: 16),
          _buildWeeklyVolume(stats),
          SizedBox(height: 16),
          _buildMonthConsistency(stats),
          SizedBox(height: 16),
          _buildSmartInsight(stats),
          SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () async {
              await PdfReportService.generateAndDownloadPdf(
                stats,
                timeframe: 'General',
              );
            },
            icon: Icon(Icons.download, size: 18),
            label: Text('Descargar reporte (PDF)'),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return SizedBox.shrink(); // Tabs eliminadas por solicitud del usuario
  }

  Widget _buildGlobalCompliance(HabitStats stats) {
    final cumplimiento = stats.weeklyCompliancePercentage;
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CUMPLIMIENTO GLOBAL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$cumplimiento%',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+6% vs sem. ant.',
                      style: TextStyle(
                        color: _kGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '${stats.completedDays} de ${stats.totalExpectedDays} hábitos completados',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: cumplimiento / 100,
                  strokeWidth: 8,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Center(
                  child: Text(
                    '${stats.completedDays}/${stats.totalExpectedDays}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(
    String title,
    String value,
    String subtitle,
    bool isCurrent,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? Theme.of(context).colorScheme.primary
                            .withValues(alpha: 0.1)
                      : _kOrange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCurrent ? Icons.local_fire_department : Icons.emoji_events,
                  size: 16,
                  color: isCurrent
                      ? Theme.of(context).colorScheme.primary
                      : _kOrange,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isCurrent ? Icons.trending_up : Icons.star,
                size: 12,
                color: isCurrent ? _kGreen : _kOrange,
              ),
              SizedBox(width: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isCurrent ? _kGreen : _kOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsCards(HabitStats stats) {
    final constante = stats.mostConsistentHabit;
    final oportunidad = stats.improvementOpportunity;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          if (constante == null && oportunidad == null)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Completa tus hábitos para desbloquear tus insights.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ),
          if (constante != null)
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _kGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.water_drop, color: _kGreen),
              ),
              title: Text(
                'MÁS CONSTANTE',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: _kGreen,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    constante.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Racha activa de ${constante.streak} días seguidos',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${constante.rate}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _kGreen,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'cumplido',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          if (constante != null && oportunidad != null) Divider(height: 1),
          if (oportunidad != null)
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _kOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.menu_book, color: _kOrange),
              ),
              title: Text(
                'OPORTUNIDAD DE MEJORA',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: _kOrange,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    oportunidad.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Cumplimiento del ${oportunidad.rate}%',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${oportunidad.rate}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _kOrange,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'cumplido',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeeklyVolume(HabitStats stats) {
    // Obtenemos los datos del provider de fl_chart
    final chartDataAsync = ref.watch(weeklyProgressChartDataProvider);

    return chartDataAsync.when(
      data: (chartData) {
        double totalSemanal = chartData.fold<double>(0, (a, b) => a + b.y);
        
        // Calcular maxY dinámicamente para que las barras no desborden
        double maxY = 10.0;
        for (var data in chartData) {
          if (data.y > maxY) {
            maxY = data.y;
          }
        }
        maxY = (maxY * 1.2).ceilToDouble(); // 20% de margen superior

        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Volumen Semanal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Meta: 7/día',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Hábitos completados por día',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                height: 150,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxY,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                            bool isToday =
                                DateTime.now().weekday == value.toInt() + 1;
                            return Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                days[value.toInt()],
                                style: TextStyle(
                                  color: isToday
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36, // Más espacio para números grandes
                          getTitlesWidget: (val, meta) => Text(
                            val.toInt().toString(),
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 3,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: chartData.map((spot) {
                      int i = spot.x.toInt();
                      bool isToday = DateTime.now().weekday == i + 1;
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: spot.y,
                            color: isToday
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.primary
                                      .withValues(alpha: 0.5),
                            width: 20,
                            borderRadius: BorderRadius.circular(4),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxY,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.grey.shade100,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Total semanal : ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${totalSemanal.toInt()} completados',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error cargando gráfico: $e')),
    );
  }

  Widget _buildMonthConsistency(HabitStats stats) {
    // Aquí implementamos un heatmap sencillo o UI de días activos.
    // Para no excedernos de complejidad, mostraremos la UI base con un texto descriptivo o grilla sencilla.
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Consistencia del Mes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Últimos 30 días',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'Mapa de actividad de hábitos',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 20),
          // Grilla heatmap con datos reales
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: stats.monthlyProgress.length,
            itemBuilder: (context, index) {
              final dp = stats.monthlyProgress[index];
              int completed = dp.value.toInt();
              
              Color color = Theme.of(context).colorScheme.surfaceContainerHighest;
              if (completed == 1) {
                color = Theme.of(context).colorScheme.primary.withValues(alpha: 0.3);
              } else if (completed == 2) {
                color = Theme.of(context).colorScheme.primary.withValues(alpha: 0.6);
              } else if (completed >= 3) {
                color = Theme.of(context).colorScheme.primary;
              }
              return Tooltip(
                message: '${dp.label}: $completed completados',
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSmartInsight(HabitStats stats) {
    return SizedBox.shrink(); // Removido por solicitud del usuario
  }
}
