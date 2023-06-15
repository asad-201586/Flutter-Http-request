import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Http Request"),
          backgroundColor: Colors.green,
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[200],
        floatingActionButton: FloatingActionButton(
          onPressed: fetchData,
          child: const Icon(Icons.add),
        ),
        body: users.isNotEmpty
            ? ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final name =
                      user["name"]["first"] + " " + user["name"]["last"];
                  final email = user["email"];
                  final imageUrl = user["picture"]["thumbnail"];
                  return ListTile(
                    title: Text(name),
                    subtitle: Text(user["email"]),
                    leading: CircleAvatar(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(imageUrl),
                      ),
                    ),
                  );
                },
              )
            : Text("No data found!"));
  }

  void fetchData() async {
    print("data fetching!");
    const url = "https://randomuser.me/api/?results=100";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final statusCode = response.statusCode;

    if (statusCode == 200) {
      print("data found!");
      final body = response.body;
      final json = jsonDecode(body);

      setState(() {
        users = json["results"];
      });

      print("user data found: ${users.length}");
    }
  }
}
