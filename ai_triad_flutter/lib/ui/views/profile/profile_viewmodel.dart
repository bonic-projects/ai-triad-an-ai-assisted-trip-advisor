import 'package:ai_triad/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../models/appuser.dart';
import '../../../services/user_service.dart';

class ProfileViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  AppUser? get user => _userService.user;
  final _navigationService = locator<NavigationService>();

  void openHomeView() {
    _navigationService.replaceWithHomeView();
  }

  void openTripView() {
    _navigationService.replaceWithTripView();
  }

  void logout() {
    _userService.logout();
    _navigationService.replaceWithLoginRegisterView();
  }
}
