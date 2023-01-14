import 'package:flutter/foundation.dart';
import 'package:flutter_redux_example/screens/user/person.dart';

@immutable
abstract class Action {
  const Action();
}

@immutable
class LoadUserAction extends Action {
  const LoadUserAction();
}

@immutable
class SuccessfullyUserFetchedAction extends Action {
  final Iterable<Person> users;
  const SuccessfullyUserFetchedAction({required this.users});
}

@immutable
class FetchFailedUserAction {
  final Object error;
  const FetchFailedUserAction({required this.error});
}
