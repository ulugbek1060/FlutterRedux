import 'package:flutter_redux_example/screens/user/person.dart';
import 'package:flutter_redux_example/screens/user/person_list_action.dart';
import 'package:redux/redux.dart';

class State {
  final Iterable<Person>? users;
  final bool isLoading;
  final Object? error;

  State({
    required this.isLoading,
    required this.users,
    required this.error,
  });

  const State.empty()
      : error = null,
        users = null,
        isLoading = false;
}

State reducer(State oldState, action) {
  if (action is LoadPersonAction) {
    return State(
      isLoading: true,
      users: null,
      error: null,
    );
  } else if (action is SuccessfullyPersonFetchedAction) {
    return State(
      isLoading: false,
      users: action.persons,
      error: null,
    );
  } else if (action is FetchFailedPersonAction) {
    return State(
      isLoading: false,
      users: null,
      error: action.error,
    );
  }
  return oldState;
}

void loadUserMiddleware(
  Store<State> store,
  action,
  NextDispatcher next,
) {
  if (action is LoadPersonAction) {
    getPerson().then((persons) {
      store.dispatch(SuccessfullyPersonFetchedAction(persons: persons));
    }).catchError((error) {
      store.dispatch(FetchFailedPersonAction(error: error));
    });
  }
  next(action);
}
