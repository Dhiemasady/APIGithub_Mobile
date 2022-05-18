import 'package:apigithub/base_network2.dart';

import 'base_network.dart';
class UserDataSource {
  static UserDataSource instance = UserDataSource();

  Future<Map<String, dynamic>> getAllUser(username) {
    return BaseNetwork.get("search/users?q=$username&type=users&per_page=20");
  }

  Future<Map<String, dynamic>> getSpecificUser(username) {
    return BaseNetwork.get("users/$username");
  }

  Future<List<dynamic>> getFollowingFollower(username,section) {
    return BaseNetworkDua.get("users/$username/$section");
  }

  Future<List<dynamic>> getRepo(username) {
    return BaseNetworkDua.get("users/$username/repos");
  }
}