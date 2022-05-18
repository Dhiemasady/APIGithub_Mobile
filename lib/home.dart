import 'package:flutter/material.dart';
import 'package:apigithub/search_bar.dart';
import 'package:apigithub/user_info.dart';
import 'package:apigithub/repositories.dart';
import 'package:apigithub/user.dart';
import 'package:apigithub/follower.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Icon actionIcon = Icon(Icons.search);
  Widget customSearchBar = Text("Github Repository");
  final searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    searchController.addListener(_searchControllerHandler);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (actionIcon.icon == Icons.search) {
                    actionIcon = const Icon(Icons.cancel);
                    customSearchBar = ListTile(
                      leading: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                      title: TextField(
                        controller: searchController,
                        onEditingComplete: (){
                          setState(() {
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Input Github username or ID',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    actionIcon = const Icon(Icons.search);
                    customSearchBar = const Text('Github Repository');
                  }
                });
              },
              icon: actionIcon)
        ],
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: UserDataSource.instance.getAllUser(searchController.text),
          builder: (
              BuildContext context,
              AsyncSnapshot<dynamic> snapshot,
              ) {
            if (snapshot.hasError) {
              return Text("something error");
            }
            if (snapshot.hasData) {
              SearchUserModel userModel = SearchUserModel.fromJson(snapshot.data);
              if (userModel.items != null) {
                return _buildSuccessSection(userModel);
              }
            }
            if(searchController.text == ''){
              return Center(
              );
            }
            return _buildLoadingSection();
          },
        ),
      ),
    );
  }

  Widget _buildSuccessSection(data) {
    return Container(
      child: ListView.builder(
          itemCount: data.items.length,
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future: UserDataSource.instance.getSpecificUser(data.items[index].login),
              builder: (
                  BuildContext context,
                  AsyncSnapshot<dynamic> snapshot,
                  ) {
                if (snapshot.hasError) {
                  return Text("something error");
                }
                if (snapshot.hasData) {
                  ModelSpecificUser specificUser = ModelSpecificUser.fromJson(snapshot.data);
                  if (specificUser.login != null) {
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: Image.network(specificUser.avatarUrl!),
                            title: Text(specificUser.login!),
                            subtitle: TextButton(
                              onPressed: (){
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => UserRepo(userId: specificUser.login,))
                                );
                              },
                                child: Align(
                                  alignment: Alignment.topLeft,
                                    child: Text("Total Repositories = " + specificUser.publicRepos.toString(), textAlign: TextAlign.start,))
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => UserFollowerFollowing(section: "followers", userId: specificUser.login,))
                                    );
                                  }, child: Text("${specificUser.followers.toString()}  follower")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => UserFollowerFollowing(section: "following", userId: specificUser.login))
                                    );
                                  }, child: Text("${specificUser.following.toString()}   following "))
                            ],
                          )
                        ],
                      ),
                    );
                  }
                }
                return _buildLoadingSection();
              },

            );
          }),
    );
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void _searchControllerHandler(){
      print(searchController.text);
  }

}
