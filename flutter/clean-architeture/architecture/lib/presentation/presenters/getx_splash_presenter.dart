import 'package:meta/meta.dart';

import '../../domain/usecases/usercases.dart';
import '../../ui/pages/pages.dart';

import '../mixins/navigation_manager.dart';

class GetxSplashPresenter with NavigationManager implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});


  @override
  Future<void> checkAccont({int durationInSeconds = 2}) async {
    await Future.delayed(Duration(seconds: durationInSeconds));
    try {
      final account = await loadCurrentAccount.load();
      navigateTo = account?.token == null ? '/login' : '/surveys';
    } catch (error) {
      navigateTo = '/login';
    }
  }
}