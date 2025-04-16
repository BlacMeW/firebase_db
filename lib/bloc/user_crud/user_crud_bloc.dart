
import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_db/bloc/user_crud/user_crud_event.dart';
import 'package:firebase_db/bloc/user_crud/user_crud_state.dart';

class UserCrudBloc extends Bloc<UserCrudEvent, UserCrudState> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref('users');

  UserCrudBloc() : super(UserCrudInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(UserCrudLoading());
      try {
        final event = await dbRef.once();
        Map? users = event.snapshot.value as Map?;
        List<Map<String, dynamic>> userList = [];
        users?.forEach((key, value) {
          userList.add({'key': key, 'name': value['name']});
        });
        emit(UserCrudLoaded(userList));
      } catch (e) {
        emit(UserCrudError('Failed to load users'));
      }
    });

    on<CreateUser>((event, emit) async {
      try {
        final newUserRef = dbRef.push();
        await newUserRef.set({'name': event.name});
        add(LoadUsers());
      } catch (_) {
        emit(UserCrudError('Failed to create user'));
      }
    });

    on<UpdateUser>((event, emit) async {
      try {
        await dbRef.child(event.key).update({'name': event.name});
        add(LoadUsers());
      } catch (_) {
        emit(UserCrudError('Failed to update user'));
      }
    });

    on<DeleteUser>((event, emit) async {
      try {
        await dbRef.child(event.key).remove();
        add(LoadUsers());
      } catch (_) {
        emit(UserCrudError('Failed to delete user'));
      }
    });
  }
}
