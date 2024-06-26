import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../blocs/posts_event.dart';
import '../blocs/posts_state.dart';
import '../blocs/posts_bloc.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final _postsBloc = Modular.get<PostsBloc>();

  @override
  void initState() {
    super.initState();
    _postsBloc.add(FetchPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Postagens"),
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
          bloc: _postsBloc,
          builder: (context, state) {
            if (state is PostsError) {
              return Center(
                child: Text(state.message),
              );
            }

            if (state is PostsLoaded) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Modular.to.pushNamed(
                            "/comments/${state.data[index].id.toString()}");
                      },
                      child: Container(
                        color: Colors.grey.shade200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration:
                                    const BoxDecoration(color: Colors.green),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      color: Colors.green.shade700,
                                      child: const Icon(
                                        Icons.subject,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6),
                                      child: Text(
                                        'POSTAGEM',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.data[index].title!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(state.data[index].body!),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            );
          }),
    );
  }
}
