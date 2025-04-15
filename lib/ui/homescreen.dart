import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final databaseRef = FirebaseDatabase.instance.ref(
    "users",
  ); // reference to "users" node
  final nameController = TextEditingController();

  void addUser() {
    String id = databaseRef.push().key!;
    databaseRef.child(id).set({
      'name': nameController.text,
      'created_at': DateTime.now().toString(),
    });
    nameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Realtime DB')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Enter name'),
            ),
            ElevatedButton(onPressed: addUser, child: Text('Add User')),
            Expanded(
              child: StreamBuilder(
                stream: databaseRef.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data!.snapshot.value != null) {
                    Map<dynamic, dynamic> users =
                        snapshot.data!.snapshot.value as Map;
                    List<Map> userList =
                        users.entries
                            .map((e) => {"key": e.key, "name": e.value["name"]})
                            .toList();

                    return ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        return ListTile(title: Text(userList[index]['name']));
                      },
                    );
                  }
                  return Text('No data available');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
