import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux_example/screens/detailed_users/user.dart';
import 'package:flutter_redux_example/screens/detailed_users/user_action.dart';
import 'package:redux/redux.dart';

@immutable
class State {
  final bool isLoading;
  final Iterable<User>? users;
  final Object? error;

  Iterable<User>? get sortedFetchedPerson =>
      users?.toList()?..sort((u1, u2) => u1.id.compareTo(u2.id));

  const State({
    required this.isLoading,
    required this.users,
    required this.error,
  });

  const State.empty()
      : isLoading = false,
        users = null,
        error = null;
}

State reducer(State oldState, action) {
  if (action is UserSuccessfullyFetchedImageAction) {
    final selectedUser = oldState.sortedFetchedPerson?.firstWhere(
      (e) => e.id == action.userId,
    );
    if (selectedUser != null) {
      return State(
        isLoading: false,
        users: oldState.users
            ?.where((user) => user.id != selectedUser.id)
            .followedBy([selectedUser.copy(false, action.imageData)]),
        error: oldState.error,
      );
    } else {
      return oldState;
    }
  } else if (action is UserImageLoadAction) {
    final selectedUser = oldState.sortedFetchedPerson?.firstWhere(
      (e) => e.id == action.userId,
    );
    if (selectedUser != null) {
      return State(
        isLoading: false,
        users: oldState.users
            ?.where((user) => user.id != selectedUser.id)
            .followedBy([selectedUser.copy(true)]),
        error: oldState.error,
      );
    } else {
      return oldState;
    }
  } else if (action is UserImageLoadAction) {
    return const State(
      isLoading: true,
      users: null,
      error: null,
    );
  } else if (action is UserSuccessfullyFetchedAction) {
    return State(
      isLoading: false,
      users: action.users,
      error: null,
    );
  } else if (action is UserErrorFetchedAction) {
    return State(
      isLoading: false,
      users: null,
      error: action.error,
    );
  }
  return oldState;
}

void loadUsersMiddleware(
  Store<State> store,
  action,
  NextDispatcher next,
) {
  if (action is LoadUserAction) {
    getUser().then((users) {
      store.dispatch(UserSuccessfullyFetchedAction(users: users));
    }).catchError((error) {
      store.dispatch(UserErrorFetchedAction(error: error));
    });
  }
  next(action);
}

void loadUsersImageMiddleware(
  Store<State> store,
  action,
  NextDispatcher next,
) {
  if (action is UserImageLoadAction) {
    final user =
        store.state.users?.firstWhere((user) => user.id == action.userId);
    if (user != null) {
      final imageUrl = user.imageUrl;
      NetworkAssetBundle(Uri.parse(imageUrl))
          .load(imageUrl)
          .then((value) => value.buffer.asUint8List())
          .then((data) {
        store.dispatch(UserSuccessfullyFetchedImageAction(
          userId: user.id,
          imageData: data,
        ));
      });
    }
  }
  next(action);
}
