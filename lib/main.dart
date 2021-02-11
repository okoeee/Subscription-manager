import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:subscription_manager/add_post_page.dart';
import 'package:subscription_manager/analytics_page.dart';
import 'package:subscription_manager/update_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _selectedIndex = 0;
  static const IconData pie_chart = IconData(0xe92e, fontFamily: 'MaterialIcons');

  static List<Widget> _widgets = [
    HomePage(),
    AnalyticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgets.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home',),
          BottomNavigationBarItem(icon: Icon(pie_chart), label: 'Chart',),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blueAccent,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void _onItemTapped(int index) => setState(() => _selectedIndex = index);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('さぶすくかんり'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> documents = snapshot.data.docs;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: documents.map((document) {
                          String name = document['name'];
                          String money = document['money'];
                          String cycle = document['cycle'];
                          IconButton editIcon;
                          editIcon = IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UpdatePage(document: document)),
                              );
                            },
                          );
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                title: Text(
                                  "${'¥'}$money${cycle == '月に１度' ? '/毎月' : '/毎年'}",
                                  style: TextStyle(fontSize: 18),
                                ),
                                trailing: editIcon,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return Center(
                    child: Text('読込中'),
                  );
                },
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPostPage()),
          );
        },
      ), //
    );
  }
}
