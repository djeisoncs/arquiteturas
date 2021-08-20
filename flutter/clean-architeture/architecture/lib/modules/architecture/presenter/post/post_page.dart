import 'package:architecture/modules/architecture/presenter/post/post_bloc.dart';
import 'package:architecture/modules/architecture/presenter/post/states/post_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final bloc = Modular.get<PostBloc>();

  @override
  void dispose() {
    super.dispose();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Search"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8, left: 8, top: 8),
            child: TextField(
              onChanged: bloc.add,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Search...",
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: bloc,
                builder: (context, snapshot) {
                  final state = bloc.state;

                  if (state is PostStateStart) {
                    return Center(
                      child: Text("Digite um texto"),
                    );
                  }

                  if (state is PostStateError) {
                    return Center(
                      child: Text("Houve um erro"),
                    );
                  }

                  if (state is PostStateLoading) {
                    return CircularProgressIndicator();
                  }

                  final list = (state as PostStateSuccess).list;

                  return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (_, id) {
                        final item = list[id];
                        return ListTile(
                          title: Text(item.title ?? ""),
                          subtitle: Text(item.body ?? ""),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
