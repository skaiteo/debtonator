import 'package:flutter/material.dart';
import 'package:raven/reorder_sample_page.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Padding(
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'This is the about page, I\'ll probably add more stuff here in the future. \n\nIn the meanwhile, you can check out this sample from the library which I got the reorderable list in the preset page',
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text('knopp\'s ReorderableList'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => KnoppReorderPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
