import 'package:flutter/material.dart';

class RegisterPhotoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("RegisterPhoto Page")),
        body: Center(
            child: 
            Column(
              children: [
                Container(
                  height: 200,
                  child: Center(
                    
                    child: Text("Passa reto boy 3", 
                  style: TextStyle(
                    fontSize: 30
                  )
                  ),)
                ),
                 RaisedButton(
                  child: Text("Passar reto"),
                  onPressed: () 
                  {
                    Navigator.pushNamed(context, '/login');
                  }
            ),
          ]
        )
      )
    );
  }
}