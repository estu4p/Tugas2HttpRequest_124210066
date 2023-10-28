import 'package:api/api_data_source.dart';
import 'package:api/users_model.dart';
import 'package:flutter/material.dart';

class User extends StatelessWidget {
  const User({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Users'),
        shape: const Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      body: FutureBuilder(
          future: ApiDataSource.instance.loadUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('ADA ERROR');
            }
            if (snapshot.hasData) {
              Users user = Users.fromJson(snapshot.data!);
              return ListView.builder(
                itemCount: user.data!.length,
                itemBuilder: (context, index) {
                  var usr = user.data![index];

                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return UserDetail(
                              user: usr,
                              idUser: usr.id!,
                            );
                          }));
                        },
                        leading: CircleAvatar(
                          foregroundImage: NetworkImage(usr.avatar!),
                        ),
                        title: Text("${usr.firstName!} ${usr.lastName!}"),
                        subtitle: Text(usr.email!),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                    ],
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class UserDetail extends StatelessWidget {
  const UserDetail({super.key, required this.idUser, required this.user});
  final int idUser;
  final Data user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail User ${idUser.toString()}'),
        shape: const Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      body: FutureBuilder(
        future: ApiDataSource.instance.loadDetaiUser(idUser),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('ADA ERROR');
          }
          if (snapshot.hasData) {
            // Users user = Users.fromJson(snapshot.data!);

            return Container(
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(user.avatar!),
                  const SizedBox(height: 20),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(user.email!),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
