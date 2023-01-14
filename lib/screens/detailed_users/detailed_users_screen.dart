import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_example/screens/detailed_users/user.dart';
import 'package:flutter_redux_example/screens/detailed_users/user_action.dart';
import 'package:redux/redux.dart';
import 'user_state.dart' as st;

extension GetElement<T> on Iterable<T> {
  T operator [](int index) => elementAt(index);
}

class DetailedUsersScreen extends StatelessWidget {
  const DetailedUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Store(
      st.reducer,
      initialState: const st.State.empty(),
      middleware: [
        st.loadUsersMiddleware,
        st.loadUsersImageMiddleware,
      ],
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
              child: const Text('Load users'),
            ),
            StoreConnector<st.State, bool>(
              converter: (store) => store.state.isLoading,
              builder: (context, isLoading) {
                if (isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const SizedBox();
              },
            ),
            StoreConnector<st.State, Iterable<User>?>(
              converter: (store) => store.state.sortedFetchedPerson,
              builder: (context, users) {
                if (users != null) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];

                        final ageInfo = Text(
                          '${users.elementAt(index).age.toString()} years old',
                        );

                        final Widget subtitle = user.imageData == null
                            ? ageInfo
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ageInfo,
                                  Container(
                                    height: 100,
                                    child: Image.memory(
                                      user.imageData!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ],
                              );

                        final Widget trailing = user.isLoading
                            ? const CircularProgressIndicator()
                            : TextButton(
                                onPressed: () {
                                  store.dispatch(
                                    UserImageLoadAction(
                                      userId: users[index].id,
                                    ),
                                  );
                                },
                                child: const Text('Load image'),
                              );

                        return ListTile(
                          title: Text(users.elementAt(index).name),
                          subtitle: subtitle,
                          trailing: trailing,
                        );
                      },
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
