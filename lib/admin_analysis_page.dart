import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminAnalysisPage extends StatefulWidget {
  final int? customerId; // phân tích theo khách

  const AdminAnalysisPage({super.key, this.customerId});

  @override
  State<AdminAnalysisPage> createState() => _AdminAnalysisPageState();
}

class _AdminAnalysisPageState extends State<AdminAnalysisPage> {
  static const String baseUrl = "http://10.0.2.2:8000";

  Map<String, double> sentiment = {};
  Map<String, double> category = {};
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchAnalysis(customerId: widget.customerId);
  }

  Future<void> fetchAnalysis({int? customerId}) async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final url = customerId == null
          ? "$baseUrl/chat/analysis/summary"
          : "$baseUrl/chat/analysis/summary?customer_id=$customerId";

      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data is Map &&
            data['sentiment'] is Map &&
            data['category'] is Map) {
          if (!mounted) return;
          setState(() {
            sentiment = Map<String, double>.from(
              (data['sentiment'] as Map).map((k, v) => MapEntry(
                (k?.toString() ?? 'Unknown').replaceAll('\n', ' '),
                v is num ? v.toDouble() : 0.0,
              )),
            );
            category = Map<String, double>.from(
              (data['category'] as Map).map((k, v) => MapEntry(
                (k?.toString() ?? 'Unknown').replaceAll('\n', ' '),
                v is num ? v.toDouble() : 0.0,
              )),
            );
            isLoading = false;
          });
        } else {
          throw Exception('Định dạng dữ liệu API không hợp lệ');
        }
      } else {
        throw Exception('Lỗi tải dữ liệu: HTTP ${res.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = 'Lỗi khi lấy dữ liệu phân tích: $e';
      });

      // Show snackbar an toàn
      Future.microtask(() {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final chartHeight = screenHeight * 0.35;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customerId == null
            ? "📊 Phân tích tất cả khách hàng"
            : "📊 Phân tích khách hàng #${widget.customerId}"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => fetchAnalysis(customerId: widget.customerId),
            tooltip: 'Làm mới dữ liệu',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(
        child: Text(errorMessage!,
            style: const TextStyle(color: Colors.red)),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card cảm xúc
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "📈 Phân tích cảm xúc",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: chartHeight,
                      child: sentiment.isEmpty
                          ? const Center(
                        child: Text('Không có dữ liệu cảm xúc'),
                      )
                          : SfCircularChart(
                        legend: Legend(
                            isVisible: true,
                            position: LegendPosition.bottom,
                            overflowMode:
                            LegendItemOverflowMode.wrap),
                        tooltipBehavior: TooltipBehavior(
                            enable: true),
                        series: <PieSeries>[
                          PieSeries<MapEntry<String, double>,
                              String>(
                            dataSource: sentiment.entries.toList(),
                            xValueMapper:
                                (MapEntry<String, double> entry,
                                _) =>
                            entry.key,
                            yValueMapper:
                                (MapEntry<String, double> entry,
                                _) =>
                            entry.value,
                            dataLabelSettings:
                            const DataLabelSettings(
                                isVisible: true),
                            explode: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Card danh mục
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "📌 Chủ đề khách hàng quan tâm",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: chartHeight,
                      child: category.isEmpty
                          ? const Center(
                        child: Text('Không có dữ liệu danh mục'),
                      )
                          : SfCartesianChart(
                        primaryXAxis: CategoryAxis(
                            labelRotation: 45,
                            majorGridLines:
                            const MajorGridLines(width: 0)),
                        primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'Số lượng'),
                            majorGridLines:
                            const MajorGridLines(width: 0)),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <ColumnSeries>[
                          ColumnSeries<MapEntry<String, double>,
                              String>(
                            dataSource: category.entries.toList(),
                            xValueMapper:
                                (MapEntry<String, double> entry,
                                _) =>
                            entry.key,
                            yValueMapper:
                                (MapEntry<String, double> entry,
                                _) =>
                            entry.value,
                            dataLabelSettings:
                            const DataLabelSettings(
                                isVisible: true),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
