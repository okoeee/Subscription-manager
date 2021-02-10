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

  List<Color> colorList = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
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
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            if(!snapshot.hasData || snapshot.data.docs.isEmpty){
              return Text('データを入力してください');
            }

            for(int i = 0; i < snapshot.data.docs.length; i++) {
              documentHashList[snapshot.data.docs[i]['name']] = double.parse(snapshot.data.docs[i]['money']);
              total = total + int.parse(snapshot.data.docs[i]['money']);
            } //documentHashListにpostsデータを追加,total金額の計算

            return Padding(
              padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
              child: Column(
                children: [
                  PieChart(
                    dataMap: documentHashList,
                    colorList: colorList,
                    centerText: '合計\n¥${total}',
                    legendOptions: LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: snapshot.data.docs.map((DocumentSnapshot document) {
                        return Column(
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: Text(
                                    document['name'],
                                    style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Text(
                                    "${'¥'}${document.data()['money']}${'/毎月'}",
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