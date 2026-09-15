import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/reports_provider.dart';
import '../../services/pdf_report_service.dart';

const _kGreen = Color(0xFF4CAF50);
const _kOrange = Color(0xFFFF9800);

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  int _selectedTab = 0; // 0: Semana, 1: Mes, 2: Año

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(reportSummaryProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Progreso y Métricas',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
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
                    color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Icon(Icons.ios_share, size: 16, color: Theme.of(context).colorScheme.onSurface),
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
        data: (data) => _buildBody(data),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildBody(Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSegmentedControl(),
          SizedBox(height: 20),
          _buildGlobalCompliance(data),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStreakCard('Racha actual', '${data['racha_actual']} días', 'Activa hoy', true)),
              SizedBox(width: 16),
              Expanded(child: _buildStreakCard('Racha máxima', '${data['racha_maxima']} días', 'Récord histórico', false)),
            ],
          ),
          SizedBox(height: 16),
          _buildInsightsCards(data),
          SizedBox(height: 16),
          _buildWeeklyVolume(data),
          SizedBox(height: 16),
          _buildMonthConsistency(data),
          SizedBox(height: 16),
          _buildSmartInsight(data),
          SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () async {
              await PdfReportService.generateAndDownloadPdf(data);
            },
            icon: Icon(Icons.download, size: 18),
            label: Text('Descargar reporte (PDF)'),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: ['Semana', 'Mes', 'Año'].asMap().entries.map((entry) {
          final idx = entry.key;
          final isSelected = _selectedTab == idx;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = idx),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  entry.value,
                  style: TextStyle(
                    color: isSelected ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGlobalCompliance(Map<String, dynamic> data) {
    final cumplimiento = data['cumplimiento_global'] ?? 0;
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
              Text('CUMPLIMIENTO GLOBAL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$cumplimiento%', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, height: 1.0)),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _kGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('+6% vs sem. ant.', style: TextStyle(color: _kGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
              SizedBox(height: 8),
              Text('${data['total_cumplido']} de ${data['total_esperado']} hábitos completados', style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Center(child: Text('${data['total_cumplido']}/${data['total_esperado']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStreakCard(String title, String value, String subtitle, bool isCurrent) {
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
              Text(title, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
              Spacer(),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isCurrent ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : _kOrange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(isCurrent ? Icons.local_fire_department : Icons.emoji_events, size: 16, color: isCurrent ? Theme.of(context).colorScheme.primary : _kOrange),
              )
            ],
          ),
          SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(isCurrent ? Icons.trending_up : Icons.star, size: 12, color: isCurrent ? _kGreen : _kOrange),
              SizedBox(width: 4),
              Text(subtitle, style: TextStyle(fontSize: 11, color: isCurrent ? _kGreen : _kOrange, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsCards(Map<String, dynamic> data) {
    final constante = data['mas_constante'];
    final oportunidad = data['oportunidad_mejora'];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          if (constante != null)
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: _kGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.water_drop, color: _kGreen),
              ),
              title: Text('MÁS CONSTANTE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _kGreen)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(constante['nombre'] ?? 'Desconocido', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface, fontSize: 14)),
                  Text('Racha activa de ${constante['racha'] ?? 0} días seguidos', style: TextStyle(fontSize: 12)),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${constante['rate']}%', style: TextStyle(fontWeight: FontWeight.bold, color: _kGreen, fontSize: 14)),
                  Text('cumplido', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          if (constante != null && oportunidad != null) Divider(height: 1),
          if (oportunidad != null)
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: _kOrange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.menu_book, color: _kOrange),
              ),
              title: Text('OPORTUNIDAD DE MEJORA', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _kOrange)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(oportunidad['nombre'] ?? 'Desconocido', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface, fontSize: 14)),
                  Text('Cumplimiento del ${oportunidad['rate'] ?? 0}%', style: TextStyle(fontSize: 12)),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${oportunidad['rate']}%', style: TextStyle(fontWeight: FontWeight.bold, color: _kOrange, fontSize: 14)),
                  Text('cumplido', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeeklyVolume(Map<String, dynamic> data) {
    List<dynamic> vol = data['volumen_semanal'] ?? [0,0,0,0,0,0,0];
    int totalSemanal = vol.fold<int>(0, (a, b) => a + (b as num).toInt());
    
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Volumen Semanal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Text('Meta: 7/día', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          SizedBox(height: 4),
          Text('Hábitos completados por día', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                        bool isToday = DateTime.now().weekday == value.toInt() + 1;
                        return Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(days[value.toInt()], style: TextStyle(color: isToday ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: isToday ? FontWeight.bold : FontWeight.normal)),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 28, getTitlesWidget: (val, meta) => Text(val.toInt().toString(), style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 10))),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 3,
                  getDrawingHorizontalLine: (value) => FlLine(color: Theme.of(context).colorScheme.surfaceContainerHighest, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (i) {
                  bool isToday = DateTime.now().weekday == i + 1;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: (vol[i] as num).toDouble(),
                        color: isToday ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 10,
                          color: Colors.grey.shade100,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 8),
          Row(
            children: [
              Text('Total semanal : ', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
              Text('$totalSemanal completados', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMonthConsistency(Map<String, dynamic> data) {
    // Aquí implementamos un heatmap sencillo o UI de días activos. 
    // Para no excedernos de complejidad, mostraremos la UI base con un texto descriptivo o grilla sencilla.
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Consistencia del Mes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Text('Últimos 30 días', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          SizedBox(height: 4),
          Text('Mapa de actividad de hábitos', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          SizedBox(height: 20),
          // Grilla heatmap simulada (idealmente construirla con los datos de consistencia_mes)
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 28, // Mostrar 4 semanas
            itemBuilder: (context, index) {
              // Simular intensidad basada en el índice
              int intensity = (index % 4);
              Color color = Theme.of(context).colorScheme.surfaceContainerHighest;
              if (intensity == 1) color = Theme.of(context).colorScheme.primary.withValues(alpha: 0.3);
              if (intensity == 2) color = Theme.of(context).colorScheme.primary.withValues(alpha: 0.6);
              if (intensity == 3) color = Theme.of(context).colorScheme.primary;
              return Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text('${index+1}', style: TextStyle(color: intensity == 3 ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSmartInsight(Map<String, dynamic> data) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Insight Inteligente', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(4)),
                      child: Text('IA HabitApp', style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 9, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  data['insight'] ?? 'Continúa así para mantener tu consistencia.',
                  style: TextStyle(color: Colors.grey.shade700, height: 1.5, fontSize: 13),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
