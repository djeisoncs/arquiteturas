
import 'package:architecture/modules/architecture/domain/usercases/post_usercase.dart';
import 'package:architecture/modules/architecture/presenter/post/states/post_state.dart';
import 'package:bloc/bloc.dart';

class PostBloc extends Bloc<int, PostState> {

  final PostUsercase usercase;

  PostBloc(this.usercase) : super(PostStateStart());

  @override
  Stream<PostState> mapEventToState(int event) async* {
    yield PostStateLoading();
    final result = await usercase.call(event);
    yield result.fold((l) => PostStateError(l), (r) => PostStateSuccess(r));
  }
  
}