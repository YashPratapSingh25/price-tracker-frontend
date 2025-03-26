import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_scraper_price_tracker/models/tracked_product.dart';
import 'package:web_scraper_price_tracker/providers/price_history_provider.dart';

class TrackedProductHistory extends StatefulWidget {
  final TrackedProduct trackedProduct;
  const TrackedProductHistory({super.key, required this.trackedProduct});

  @override
  State<TrackedProductHistory> createState() => _TrackedProductHistoryState();
}

class _TrackedProductHistoryState extends State<TrackedProductHistory> {
  String? docId;
  Map<String, dynamic>? foundProduct;
  List<Map<String, dynamic>>? priceHistory;
  List<FlSpot>? flSpots;
  List<double> yValues = [];
  List<double> xValues = [];
  DateTime? firstDate;
  double? minY, maxY, minX, maxX;

  @override
  void initState() {
    super.initState();

  }

  double priceToDouble(String price) {
    double dbPrice = double.parse(price.replaceAll(",", "")) / 1000;
    return double.parse(dbPrice.toStringAsFixed(1));
  }

  String getDateLabel(double daysSinceStart) {
    DateTime? dt = firstDate?.add(Duration(days: daysSinceStart.toInt()));
    return DateFormat("dd MMM").format(dt!);
  }

  void createSpots() {
    firstDate = DateTime.parse(priceHistory?.first["date"]);
    flSpots = priceHistory?.map((history) {
      var date = DateTime.parse(history["date"]);
      var daysSinceStart = date.difference(firstDate!).inDays;
      xValues.add(daysSinceStart.toDouble());
      var price = priceToDouble(history["price"]);
      yValues.add(price);
      minY ??= price;
      maxY ??= price;
      minY = min(minY!, price);
      maxY = max(maxY!, price);
      return FlSpot(daysSinceStart.toDouble(), price);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    docId = "${widget.trackedProduct.title} ${widget.trackedProduct.site}"
        .replaceAll(" ", "_")
        .replaceAll("/", "`");

    final provider = Provider.of<PriceHistoryProvider>(context, listen: true);
    foundProduct = provider.priceHistory?.firstWhere(
      (element) => element["product"] == docId,
      orElse: () => {},
    );
    if (foundProduct == null) print("No such product exists");
    if(foundProduct?["history"] != null){
      priceHistory = (foundProduct?["history"] as List<dynamic>)
          .map((history) => history as Map<String, dynamic>)
          .toList();
      createSpots();
      minX = flSpots!.first.x;
      maxX = flSpots!.last.x;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Price History", style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.deepPurple[200],
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: foundProduct?["history"] == null ? 
      const Center(
        child: CircularProgressIndicator(),
      ):
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image.network(
              widget.trackedProduct.imageUrl,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 30,),
            Text(
              widget.trackedProduct.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                launchUrl(
                    Uri.parse(widget.trackedProduct.productUrl),
                    mode: LaunchMode.inAppWebView
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Buy Now for ${widget.trackedProduct.currentPrice}",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 40,),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: double.infinity,
                maxHeight: 300
              ),
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 6,
                radius: const Radius.circular(10),
                interactive: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    border: TableBorder.all(color: Colors.deepPurple, width: 2, borderRadius: BorderRadius.circular(6)),
                    headingRowColor: WidgetStateColor.resolveWith((states) => Colors.deepPurple.shade200),
                    columns: [
                      DataColumn(
                        onSort: (columnIndex, ascending) {

                        },
                        headingRowAlignment: MainAxisAlignment.center,
                        label: const Text(
                          "Date",
                          style: TextStyle(
                            fontSize: 20
                          ),
                        )
                      ),
                      const DataColumn(
                        headingRowAlignment: MainAxisAlignment.center,
                        label: Text(
                          "Price",
                          style: TextStyle(
                            fontSize: 20
                          ),
                        )
                      )
                    ],
                    rows: priceHistory!.map((history) {
                      return DataRow(
                        cells: [
                        DataCell(
                          Center(
                            child: Text(
                              DateFormat("dd MMM, yy").format(DateTime.parse(history["date"])),
                              style: const TextStyle(
                                fontSize: 16
                              ),
                            ),
                          )
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              history["price"],
                              style: const TextStyle(
                                fontSize: 16
                              ),
                            ),
                          )
                        )
                      ]);
                    },).toList()
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40,),
            AspectRatio(
              aspectRatio: 4 / 3,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  backgroundColor: Colors.white,
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.deepPurple, width: 1),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((touchedSpot) {
                          final price = touchedSpot.y.toStringAsFixed(1);
                          final date = getDateLabel(touchedSpot.x);
                          return LineTooltipItem(
                            "Date: $date\nPrice: $price K",
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: flSpots!,
                      isCurved: true,
                      preventCurveOverShooting: true,
                      color: Colors.deepPurple,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.deepPurple.withOpacity(0.3),
                      ),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 50,
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if(value == minY! - 1 || value == maxY! + 1) return const SizedBox();
                          return Text("${value.toStringAsFixed(1)}K",
                              style: const TextStyle(fontSize: 14, color: Colors.deepPurple));
                        },
                        interval: 1.0
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 45,
                        showTitles: false,
                        getTitlesWidget: (value, meta) {
                          return xValues.contains(value)
                              ? Text(getDateLabel(value),
                              style: const TextStyle(fontSize: 14, color: Colors.deepPurple))
                              : const SizedBox();
                        },
                        interval: 1,
                      ),
                    ),
                  ),
                  minY: minY! - 1,
                  maxY: maxY! + 1,
                  minX: minX! - 0.5,
                  maxX: maxX! + 0.5,
                ),
              ),
            ),
            const SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }
}
