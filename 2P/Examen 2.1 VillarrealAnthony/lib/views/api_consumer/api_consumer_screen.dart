import 'package:flutter/material.dart';
import '../../models/post_model.dart';
import '../../viewmodels/api_consumer_viewmodel.dart';
import 'package:provider/provider.dart';

class ApiConsumerScreen extends StatelessWidget {
  const ApiConsumerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ApiConsumerViewModel>(context, listen: false);

    return Scaffold(
      body: FutureBuilder<List<Post>>(
        future: viewModel.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(posts[index].title),
                    subtitle: Text(posts[index].body),
                    leading: CircleAvatar(
                      child: Text(posts[index].id.toString()),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}