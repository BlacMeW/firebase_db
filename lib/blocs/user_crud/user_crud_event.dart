abstract class UserCrudEvent {}

class CreateUser extends UserCrudEvent {
  final String name;

  CreateUser(this.name);
}

class UpdateUser extends UserCrudEvent {
  final String key;
  final String name;

  UpdateUser(this.key, this.name);
}

class DeleteUser extends UserCrudEvent {
  final String key;

  DeleteUser(this.key);
}

class LoadUsers extends UserCrudEvent {}
