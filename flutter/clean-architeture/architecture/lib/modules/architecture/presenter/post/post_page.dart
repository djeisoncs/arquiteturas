
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PostPageState();

}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Search"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8, left: 8, top: 8),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Search...",
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemBuilder: (_, id) {
                    return ListTile();
                  }
              ),
          ),
        ],
      ),
    );
  }

}