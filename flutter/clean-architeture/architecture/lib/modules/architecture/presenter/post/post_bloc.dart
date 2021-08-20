
import 'package:architecture/modules/architecture/domain/usercases/post_usercase.dart';
import 'package:architecture/modules/architecture/presenter/post/states/post_state.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class PostBloc extends Bloc<String, PostState> {

  final PostUsercase usercase;

  PostBloc(this.usercase) : super(PostStateStart());

  @override
  Stream<PostState> mapEventToState(String event) async* {
    yield PostStateLoading();
    final result = await usercase.call(event);
    yield result.fold((l) => PostStateError(l), (r) => PostStateSuccess(r));
  }

  @override
  Stream<Transition<String, PostState>> transformEvents(Stream<String> events, transitionFn) {
    return super.transformEvents(events.debounceTime(Duration(microseconds: 800)), transitionFn);
  }
  
}