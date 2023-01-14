import 'package:flutter/foundation.dart';
import 'package:flutter_redux_example/screens/detailed_users/user.dart';

@immutable
abstract class Action {
  const Action();
}

@immutable
class LoadUserAction extends Action {
  const LoadUserAction();
}

@immutable
class UserSuccessfullyFetchedAction extends Action {
  final Iterable<User>? users;
  const UserSuccessfullyFetchedAction({required this.users});
}

@immutable
class UserErrorFetchedAction extends Action {
  final Object? error;
  const UserErrorFetchedAction({required this.error});
}

@immutable
class UserImageLoadAction extends Action {
  final int userId;
  const UserImageLoadAction({required this.userId});
}

@immutable
class UserSuccessfullyFetchedImageAction extends Action {
  final int userId;
  final Uint8List imageData;
  const UserSuccessfullyFetchedImageAction({
    required this.userId,
    required this.imageData,
  });
}
