import 'package:flutter/material.dart';
import 'package:apigithub/repo_info.dart';
import 'package:apigithub/user.dart';
import 'package:url_launcher/url_launcher.dart';

class UserRepo extends StatelessWidget {
  final userId;
  const UserRepo(
      {Key? key,required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$userId Repo"),
      ),
      body: Container(
        child: FutureBuilder(
          future: UserDataSource.instance.getRepo(userId),
          builder: (
              BuildContext context,
              AsyncSnapshot<dynamic> snapshot,
              ) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.hasData) {
              UserRepoModel repoModel = UserRepoModel.fromJson(snapshot.data);
              return ListView.builder(
                  itemCount: repoModel.items?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () async {
                        if (!await launch(
                            "${repoModel.items![index].htmlUrl!}"))
                          throw 'Could not launch ${repoModel.items![index].htmlUrl!}';
                      },
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.book_outlined),
                              title: Text(repoModel.items![index].name!),
                              subtitle: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text("${repoModel.items![index].description}"),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
            return _buildLoadingSection();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
