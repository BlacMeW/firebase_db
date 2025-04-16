abstract class UserCrudState {}

class UserCrudInitial extends UserCrudState {}

class UserCrudLoading extends UserCrudState {}

class UserCrudLoaded extends UserCrudState {
  final List<Map<String, dynamic>> users;

  UserCrudLoaded(this.users);
}

class UserCrudError extends UserCrudState {
  final String message;

  UserCrudError(this.message);
}
