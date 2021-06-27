import 'package:flutter/cupertino.dart';

class NoData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "No Data Found",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0
            )
          ),
          Text("Tap the icon in the bottom right corner to add a new data")
        ],
      ),
    );
  }
}