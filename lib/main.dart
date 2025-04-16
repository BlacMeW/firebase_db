import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Firebase apps count: ${Firebase.apps.length}");
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(title: 'Firebase CRUD', home: UserScreen());
  // }
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Error check
        if (snapshot.hasError) {
          print('Firebase init error: ${snapshot.error}');
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Firebase init failed')),
            ),
          );
        }

        // Done initializing
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            home: UserScreen(),
          );
        }

        // Still loading
        return MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final dbRef = FirebaseDatabase.instance.ref('users');
  final TextEditingController nameController = TextEditingController();
  String? selectedKey;

  void createUser(String name) {
    final newUserRef = dbRef.push();
    newUserRef.set({'name': name});
  }

  void updateUser(String key, String name) {
    dbRef.child(key).update({'name': name});
  }

  void deleteUser(String key) {
    dbRef.child(key).remove();
  }

  void saveUser() {
    final name = nameController.text.trim();
    if (name.isEmpty) return;

    if (selectedKey == null) {
      createUser(name);
    } else {
      updateUser(selectedKey!, name);
    }

    nameController.clear();
    setState(() => selectedKey = null);
  }

  void populateForEdit(String key, String name) {
    nameController.text = name;
    setState(() {
      selectedKey = key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase CRUD Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: saveUser,
              child: Text(selectedKey == null ? 'Create User' : 'Update User'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: dbRef.onValue,
                builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data!.snapshot.value != null) {
                    Map users = snapshot.data!.snapshot.value as Map;
                    List<Map<String, dynamic>> userList = [];

                    users.forEach((key, value) {
                      userList.add({'key': key, 'name': value['name']});
                    });

                    return ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        final user = userList[index];
                        return ListTile(
                          title: Text(user['name']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.orange),
                                onPressed:
                                    () => populateForEdit(
                                      user['key'],
                                      user['name'],
                                    ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteUser(user['key']),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Text('No users found');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
