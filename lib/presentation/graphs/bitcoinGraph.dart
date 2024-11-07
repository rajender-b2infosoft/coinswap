import 'package:crypto_app/core/app_export.dart';
import 'package:crypto_app/presentation/graphs/providers/btcProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartScreen extends StatefulWidget {
  final String type;

  const LineChartScreen({super.key, required this.type});

  @override
  State<LineChartScreen> createState() => _LineChartScreenState();

  static Widget builder(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return ChangeNotifierProvider(
      create: (context) => BtcProvider(),
      child: LineChartScreen(
        type: args['type'],
      ),
    );
  }
}

class _LineChartScreenState extends State<LineChartScreen> {
  late BtcProvider btcProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      btcProvider = Provider.of<BtcProvider>(context, listen: false);
      btcProvider.fetchPriceData(widget.type);
      btcProvider.fetchStatsData(widget.type);
    }); // Pass the type here
  }

  @override
  Widget build(BuildContext context) {
    btcProvider = Provider.of<BtcProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.main,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              NavigatorService.goBack();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: appTheme.white,
            )),
        title: Text(
          'Market History (${(widget.type=='ethereum')?'ETH':(widget.type=='bitcoin')?'BTC':'USDT'})',
          style: CustomTextStyles.headlineMediumRegular,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          height: SizeUtils.height,
          width: SizeUtils.width,
          decoration: BoxDecoration(
              color: appTheme.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              )),
          child: btcProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : btcProvider.errorMessage != null
                  ? Text(
                      btcProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    )
                  : SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: appTheme.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: appTheme.color549FE3,
                                    blurRadius: 1.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 400,
                              width: SizeUtils.width - 20,
                              padding: const EdgeInsets.fromLTRB(10, 20, 20, 5),
                              child: LineChartSample(
                                  dataPoints: btcProvider.dataPoints, type:widget.type),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Market Stats",
                            style: CustomTextStyles.gray7272_16,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  // color: appTheme.grayEE,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Current Value',
                                          style: CustomTextStyles.main14,
                                        ),
                                        Text(
                                          '${btcProvider.usdPrice}',
                                          style: CustomTextStyles.gray7272_12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: appTheme.gray,
                                    thickness: 1,
                                    indent: 00,
                                    endIndent: 0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Market Cap',
                                          style: CustomTextStyles.main14,
                                        ),
                                        Text(
                                          '${btcProvider.marketCap}',
                                          style: CustomTextStyles.gray7272_12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: appTheme.gray,
                                    thickness: 1,
                                    indent: 00,
                                    endIndent: 0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '24h Volume',
                                          style: CustomTextStyles.main14,
                                        ),
                                        Text(
                                          '${btcProvider.volume24h}',
                                          style: CustomTextStyles.gray7272_12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: appTheme.gray,
                                    thickness: 1,
                                    indent: 00,
                                    endIndent: 0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '24h Change',
                                          style: CustomTextStyles.main14,
                                        ),
                                        Text(
                                          '${btcProvider.change24h}',
                                          style: CustomTextStyles.gray7272_12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: appTheme.gray,
                                    thickness: 1,
                                    indent: 00,
                                    endIndent: 0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Last Updated Date',
                                          style: CustomTextStyles.main14,
                                        ),
                                        Text(
                                          '${btcProvider.lastUpdated}',
                                          style: CustomTextStyles.gray7272_12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                  ),
        ),
      ),
    );
  }
}

class LineChartSample extends StatelessWidget {
  final List<FlSpot> dataPoints;
  String type;

  LineChartSample({required this.dataPoints, required this.type});

  List<Color> gradientColors = [Colors.cyan, Colors.blue];

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        // backgroundColor: Colors.lightBlueAccent.withOpacity(0.2),
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints,
            isCurved: false,
            gradient: LinearGradient(
              colors: gradientColors,
            ),
            // colors: [Colors.cyan, Colors.blue],
            barWidth: 2,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  ColorTween(begin: gradientColors[0], end: gradientColors[1])
                      .lerp(0.2)!
                      .withOpacity(0.1),
                  ColorTween(begin: gradientColors[0], end: gradientColors[1])
                      .lerp(0.2)!
                      .withOpacity(0.1),
                ],
              ),
            ),
            // dotData: FlDotData(show: true),
            dotData: FlDotData(show: dataPoints.length <= 20),
          ),
        ],
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false), // Hide top titles
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (type=='bitcoin')?1000:(type=='ethereum')?50:0.0001,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color:
                          appTheme.black, // Set left axis title color to black
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              // interval: 10,
              // reservedSize: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  // DateTime.now().add(Duration(days: value.toInt() - 30)).toString().substring(5, 10),
                  DateFormat('dd/MM').format(
                      DateTime.now().add(Duration(days: value.toInt() - 30))),
                  style: TextStyle(color: appTheme.black, fontSize: 10),
                );
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final date = DateFormat('dd/MM/yyyy').format(
                  DateTime.now().add(Duration(days: spot.x.toInt() - 30)),
                ); // Customize date based on the x-axis value
                final price = spot.y.toStringAsFixed(2);
                return LineTooltipItem(
                  'Date: $date\nPrice: \$${price} USD',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
          touchCallback: (event, response) {},
        ),
      ),
    );
  }
}
