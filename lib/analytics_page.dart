import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  Map<String, double> documentHashList = {};
  int total = 0;
  int colorInt = -1;

  List<Color> colorList = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
  ];

  @override
  Widget build(BuildContext context) {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');

    return Scaffold(
      appBar: AppBar(
        title: Text('ぶんせき'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: posts.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
              return Text('データを入力してください');
            }

            for (int i = 0; i < snapshot.data.docs.length; i++) {
              documentHashList[snapshot.data.docs[i]['name']] =
                  double.parse(snapshot.data.docs[i]['month_money']);
              total = total + int.parse(snapshot.data.docs[i]['month_money']);
            } //documentHashListにpostsデータを追加,total金額の計算

            return Padding(
              padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      PieChart(
                        dataMap: documentHashList,
                        chartType: ChartType.ring,
                        colorList: colorList,
                        ringStrokeWidth: 26,
                        chartRadius: MediaQuery.of(context).size.width / 1.4,
                        chartValuesOptions: ChartValuesOptions(
                          showChartValueBackground: false,
                          showChartValuesInPercentage: true,
                          showChartValuesOutside: false,
                        ),
                        legendOptions: LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          showLegends: false,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        child: Center(
                          child: Text(
                            '合計\n¥${total}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                  ),
                  Expanded(
                    child: ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                            colorInt = colorInt + 1;
                        return Column(
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.circle,
                                    color: colorList[colorInt],
                                  ),
                                  title: Text(
                                    document['name'],
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                    "${'¥'}${document.data()['month_money']}${'/毎月'}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
