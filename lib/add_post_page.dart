import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  String name = '';
  String money = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('追加'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
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
              Container(
                width: double.infinity,
                height: 56,
                child: RaisedButton(
                  child: Text('登録'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(56)),
                  ),
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('posts').doc().set({
                      'name' : name,
                      'money' : money,
                    });
                    print(name);
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
