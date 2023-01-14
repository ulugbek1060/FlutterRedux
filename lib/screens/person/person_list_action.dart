import 'package:flutter/foundation.dart';
import 'package:flutter_redux_example/screens/user/person.dart';

@immutable
abstract class Action {
  const Action();
}

@immutable
class LoadPersonAction extends Action {
  const LoadPersonAction();
}

@immutable
class SuccessfullyPersonFetchedAction extends Action {
  final Iterable<Person> persons;
  const SuccessfullyPersonFetchedAction({required this.persons});
}

@immutable
class FetchFailedPersonAction {
  final Object error;
  const FetchFailedPersonAction({required this.error});
}
