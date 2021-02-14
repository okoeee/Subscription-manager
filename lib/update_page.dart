import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:subscription_manager/main.dart';

class UpdatePage extends StatefulWidget {
  final DocumentSnapshot document;
  UpdatePage({this.document});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  String name = '';
  String money = '';
  String value = '';
  String monthMoney = '';
  String yearMoney = '';
  String cycle = '月に１度';
  String _selectedValue = '月に１度';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('変更'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await FirebaseFirestore.instance.collection('posts').doc(widget.document.id).delete();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  initialValue: (widget.document['name']).toString(),
                  validator: (value) {
                    if(value.isEmpty) {
                      return 'サービス名を入力してください';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'サービス名'),
                  onChanged: (String value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                Container(
                  padding: EdgeInsets.all(8),
                ),
                TextFormField(
                  initialValue: (widget.document['money']).toString(),
                  validator: (value) {
                    if(int.tryParse(value) == null) {
                      return '金額を入力してください';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: '金額'),
                  onChanged: (String value) {
                    setState(() {
                      money = value;
                    });
                  },
                ),
                Container(
                  padding: EdgeInsets.all(32),
                ),
                DropdownButtonFormField(
                  value: (widget.document['cycle']).toString(),
                  decoration: InputDecoration(labelText: '支払い周期'),
                  isExpanded: true,
                  items: ['月に１度', '年に１度'].map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  )).toList(),
                  onChanged: (String value) {
                    setState(() {
                      cycle = value;
                      _selectedValue = value;
                    });
                  },
                ),
                Container(
                  padding: EdgeInsets.all(32),
                ),
                Container(
                  width: double.infinity,
                  height: 56,
                  child: RaisedButton(
                    child: Text('変更'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(56)),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        await FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.document.id)
                            .update({
                          'name': name.isEmpty ? (widget.document['name'].toString()) : name,
                          'money': money.isEmpty ? (widget.document['money']).toString() : money,
                          'cycle': cycle,
                          'month_money': cycle == '月に１度' ? money : ((int.parse(money)/12).round()).toString(),
                          'year_money': cycle == '年に１度' ? money : ((int.parse(money)*12).round()).toString(),
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
