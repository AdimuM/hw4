import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _showTutorial = false;

  @override
  void initState() {
    super.initState();
    _checkIfShowTutorial();
  }

  _checkIfShowTutorial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showTutorial = prefs.getBool('showTutorial') ?? true;

    setState(() {
      _showTutorial = showTutorial;
    });
  }

  _onDismiss() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showTutorial', false);

    setState(() {
      _showTutorial = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Screen'),
      ),
      body: _showTutorial ? _buildTutorial() : _buildMainContent(),
    );
  }

  Widget _buildTutorial() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome to the App!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          'This is a quick tutorial. Swipe to dismiss.',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onHorizontalDragEnd: (details) {
            // Dismiss tutorial on swipe
            _onDismiss();
          },
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey[300],
            child: Text(
              'Swipe to Dismiss',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Main Content',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context as BuildContext,'/second');
            },
            child: Text('Go to Second Screen'),
          ),
        ],
      ),
    );
  }
}


