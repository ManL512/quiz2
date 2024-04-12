import 'package:flutter/material.dart';
import 'package:quiz2/model.dart/modelo.dart';
import 'package:quiz2/views/ofertas.dart';

class inicio extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú principal'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage()),
                );
              },
              child: Text('Artículos'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePageO()),
                );
              },
              child: Text('Ofertas'),
            ),
          ],
        ),
      ),
    );
  }
}
