import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  List<Map<String, dynamic>> userList = [];

  @override
  void initState() {
    super.initState();

    sqfliteFfiInit(); // Use sqfliteFfiWebInit for web
    databaseFactory = databaseFactoryFfiWeb;

    _fetchUserList();
  }


  _fetchUserList() async {
    // final response = await http.get('https://randomuser.me/api/?results=5' as Uri);
    final response = await get(Uri.parse('https://randomuser.me/api/?results=5'));

    if (response.statusCode == 200) {
      setState(() {
        userList = List<Map<String, dynamic>>.from(
          json.decode(response.body)['results'],
        );
      });
      print(userList);
    }
  }


  _fetchMoreUsers() async {
    // final response = await http.get('https://randomuser.me/api/?results=5' as Uri);
    final response = await get(Uri.parse('https://randomuser.me/api/?results=5'));
    if (response.statusCode == 200) {
      setState(() {
        userList.addAll(
          List<Map<String, dynamic>>.from(
            json.decode(response.body)['results'],
          ),
        );
      });
    }
  }

  _storeDataInDatabase() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT)',
        );
      },
      version: 1,
    );

    for (var user in userList) {
      await database.insert(
        'users',
        {'name': user['name']['first'], 'email': user['email']},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await database.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(userList[index]['name']['first']),
                  subtitle: Text(userList[index]['email']),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _fetchMoreUsers();
                },
                child: Text('Get More Users'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/third' );
                },
                child: Text('Go to screen 3'),
              ),
              ElevatedButton(
                onPressed: () {
                  _storeDataInDatabase();
                },
                child: Text('Store Data in SQLite'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
