import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  String name = '';
  String money = '';
  String cycle = '月に１度';

  String _selectedValue = '月に１度';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('追加'),
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
                  validator: (value) {
                    if(value.isEmpty) {
                      return 'サービス名を入力してください';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'サービス名',
                  ),
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
                  validator: (value) {
                    if(int.tryParse(value) == null) {
                      return '金額を入力してください';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: '金額'),
                  onChanged: (String value) {
                    setState(() {
                      money = value;
                    });
                  },
                ),
                Container(
                  padding: EdgeInsets.all(8),
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(labelText: '支払い周期'),
                  isExpanded: true,
                  items: ['月に１度', '年に１度'].map((label) => DropdownMenuItem(
                        child: Text(label),
                        value: label,
                      )).toList(),
                  value: _selectedValue,
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
                    child: Text('登録'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(56)),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState.validate()) {
                        //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                        await FirebaseFirestore.instance
                            .collection('posts')
                            .doc()
                            .set({
                          'name': name,
                          'money': money,
                          'cycle': cycle,
                        });
                        Navigator.pop(context);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
