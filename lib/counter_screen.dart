import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState(); //[6]
}

class _CounterScreenState
    extends
        State<CounterScreen> //[7]
        {
  int _cnt = 0;

  void _increase() {
    setState(() //[8]
    {
      _cnt++;
    });
  }

  void _decrease() {
    if (_cnt > 0) {
      setState(() {
        _cnt--;
      });
    }
  }

  void _reset() {
    setState(() {
      _cnt = 0;
    });
  }

  Color _setColor() {
    if (_cnt == 0) {
      return Colors.deepPurple;
    } else if (_cnt < 5) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Counter App"),
        backgroundColor: Colors.lightGreen,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Number:", style: TextStyle(fontSize: 24)),

            Text(
              '$_cnt', 
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: _setColor(),
              ),
            ),
            SizedBox(height: 30), // blank

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _cnt == 0 ? null : _decrease,
                  backgroundColor: _cnt == 0
                      ? Colors.blueGrey
                      : Colors.redAccent,
                  child: Icon(Icons.remove),
                ),
                SizedBox(width: 20),

                ElevatedButton(onPressed: _reset, child: Text("RESET")),
                SizedBox(width: 20),

                FloatingActionButton(
                  onPressed: _increase,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
