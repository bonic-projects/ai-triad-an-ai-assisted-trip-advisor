import 'package:ai_triad/app/app.router.dart';
import 'package:ai_triad/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:ai_triad/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 1));

    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic

    if (_userService.hasLoggedInUser) {
      _navigationService.replaceWithHomeView();
    } else {
      _navigationService.replaceWithLoginRegisterView();
    }
  }
}
