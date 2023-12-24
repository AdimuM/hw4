import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import sqflite_ffi

class ThirdScreen extends StatefulWidget {
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  List<Map<String, dynamic>> userList = [];

  @override
  void initState() {
    super.initState();

    // Initialize the databaseFactory for sqflite_common_ffi
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    _retrieveDataFromDatabase();
  }

  _retrieveDataFromDatabase() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
    );

    final List<Map<String, dynamic>> maps = await database.query('users');

    setState(() {
      userList = List<Map<String, dynamic>>.from(maps);
    });

    await database.close();

    print('Retrieved Data: $userList');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Third Screen'),
      ),
      body: userList.isEmpty
          ? Center(
        child: Text('No users stored in the database'),
      )
          : ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(userList[index]['name']),
            subtitle: Text(userList[index]['email']),
          );
        },
      ),
    );
  }
}
