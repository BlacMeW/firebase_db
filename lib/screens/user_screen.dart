import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_db/blocs/user_crud/user_crud_bloc.dart';
import 'package:firebase_db/blocs/user_crud/user_crud_event.dart';
import 'package:firebase_db/blocs/user_crud/user_crud_state.dart';
import 'package:firebase_db/blocs/auth/auth_bloc.dart';
import 'gps_update_screen.dart';
import 'login_screen.dart';

class UserScreen extends StatelessWidget {
  final GlobalKey<_UserFormState> _formKey = GlobalKey<_UserFormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSignedOut) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Firebase CRUD Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              UserForm(key: _formKey),
              const SizedBox(height: 20),
              Expanded(
                child: UserList(
                  onEdit: (key, name) {
                    _formKey.currentState?.populateForEdit(key, name);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final nameController = TextEditingController();
  String? selectedKey;

  void saveUser(BuildContext context) {
    final name = nameController.text.trim();
    if (name.isEmpty) return;

    if (selectedKey == null) {
      context.read<UserCrudBloc>().add(CreateUser(name));
    } else {
      context.read<UserCrudBloc>().add(UpdateUser(selectedKey!, name));
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
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => saveUser(context),
          child: Text(selectedKey == null ? 'Create User' : 'Update User'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GpsUpdateScreen()),
            );
          },
          child: Text('Go to GPS Update Screen'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(SignOutRequested());
          },
          child: Text('Logout'),
        ),
      ],
    );
  }
}

class UserList extends StatelessWidget {
  final Function(String key, String name) onEdit;

  const UserList({required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCrudBloc, UserCrudState>(
      builder: (context, state) {
        if (state is UserCrudLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UserCrudError) {
          return Center(child: Text(state.message));
        } else if (state is UserCrudLoaded) {
          final users = state.users;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['name']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        onEdit(user['key'], user['name']);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<UserCrudBloc>().add(DeleteUser(user['key']));
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
        return Center(child: Text('No users found'));
      },
    );
  }
}
