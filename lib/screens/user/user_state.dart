import 'package:flutter_redux_example/screens/user/person.dart';
import 'package:flutter_redux_example/screens/user/user_list_action.dart';
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
  if (action is LoadUserAction) {
    return State(
      isLoading: true,
      users: null,
      error: null,
    );
  } else if (action is SuccessfullyUserFetchedAction) {
    return State(
      isLoading: false,
      users: action.users,
      error: null,
    );
  } else if (action is FetchFailedUserAction) {
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
  if (action is LoadUserAction) {
    getPerson().then((users) {
      store.dispatch(SuccessfullyUserFetchedAction(users: users));
    }).catchError((error) {
      store.dispatch(FetchFailedUserAction(error: error));
    });
  }
  next(action);
}
