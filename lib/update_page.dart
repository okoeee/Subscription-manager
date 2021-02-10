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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('追加'),
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
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                initialValue: widget.document['name'],
                decoration: InputDecoration(labelText: 'サービス名'),
                onChanged: (String value) {
                  setState(() {
                    if (value != null) {
                      name = value;
                    } else {
                      name = widget.document['name'];
                    }
                  });
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
              ),
              TextFormField(
                initialValue: widget.document['money'],
                decoration: InputDecoration(labelText: '金額'),
                onChanged: (String value) {
                  setState(() {
                    if (value != null) {
                      money = value;
                    } else {
                      money = widget.document['name'];
                    }
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
                    await FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.document.id)
                        .update({
                      'name': name,
                      'money': money,
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
