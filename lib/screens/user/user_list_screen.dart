import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_example/screens/user/person.dart';
import 'package:flutter_redux_example/screens/user/user_list_action.dart';
import 'package:redux/redux.dart';
import 'user_state.dart' as state;

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Store(
      state.reducer,
      initialState: const state.State.empty(),
      middleware: [state.loadUserMiddleware],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('User list'),
      ),
      body: StoreProvider(
        store: store,
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                store.dispatch(const LoadUserAction());
              },
              child: const Text('Load person'),
            ),
            StoreConnector<state.State, bool>(
              converter: (storee) => storee.state.isLoading,
              builder: (context, isLoading) {
                if (isLoading) {
                  return const CircularProgressIndicator();
                }
                return const SizedBox();
              },
            ),
            StoreConnector<state.State, Iterable<Person>?>(
              converter: (store) => store.state.users,
              builder: (context, users) {
                if (users != null) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text(
                          'name: ${users.elementAt(index).name} age: ${users.elementAt(index).age}',
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            StoreConnector<state.State, Object?>(
              converter: (store) => store.state.error,
              builder: (context, error) {
                if (error != null) {
                  return Center(
                    child: Text(error.toString()),
                  );
                }
                return const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }
}
