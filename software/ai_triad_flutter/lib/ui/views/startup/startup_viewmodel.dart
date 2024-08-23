import 'package:ai_triad/app/app.router.dart';
import 'package:ai_triad/services/gpt_service.dart';
import 'package:ai_triad/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:ai_triad/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../services/firestore_service.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();
  final _firestoreService = locator<FirestoreService>();
  final _gptService = locator<GptChatService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    if (_userService.hasLoggedInUser) {
      await _userService.fetchUser();
      await _firestoreService.getAdminData();
      _gptService.setupGpt();
      _navigationService.replaceWithHomeView();
    } else {
      await Future.delayed(const Duration(seconds: 1));
      _navigationService.replaceWithLoginRegisterView();
    }
  }
}
