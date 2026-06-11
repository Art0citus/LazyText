import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../widgets/user_tile.dart';
import '../chat/chat_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final ApiService api = ApiService();

  List<UserModel> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final response = await api.getUsers();

      print("USERS RESPONSE:");
      print(response.data);

      final List<dynamic> data = response.data;

      setState(() {
        users = data
            .map(
              (user) => UserModel.fromJson(user),
            )
            .toList();

        isLoading = false;
      });
    } catch (e) {
      print("LOAD USERS ERROR:");
      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.gray,

      appBar: AppBar(
        title: const Text("LazyText"),
        backgroundColor: TColor.gray,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : users.isEmpty
              ? const Center(
                  child: Text(
                    "No users found",
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return UserTile(
                      user: users[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                            username: users[index].fullname,
                                  receiverId: users[index].id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}