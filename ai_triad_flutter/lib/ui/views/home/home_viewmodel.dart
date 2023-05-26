import 'package:ai_triad/app/app.dialogs.dart';
import 'package:ai_triad/app/app.locator.dart';
import 'package:ai_triad/app/app.logger.dart';
import 'package:ai_triad/app/app.router.dart';
import 'package:ai_triad/models/appuser.dart';
import 'package:ai_triad/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final log = getLogger('HomeViewModel');

  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  // final _bottomSheetService = locator<BottomSheetService>();

  final _userService = locator<UserService>();
  bool get hasUser => _userService.hasLoggedInUser;
  AppUser? get user => _userService.user;

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    setBusy(true);
    // await Future.delayed(const Duration(seconds: 1));
    if (hasUser) {
      if (user == null) {
        await _userService.fetchUser();
      }
      setBusy(false);
    }
  }

  void openChatView() {
    _navigationService.navigateToChatView();
  }

  void openHotelAddView() {
    _navigationService.navigateToAddHotelView();
  }

  void openTravelModesAddView() {
    _navigationService.replaceWithAddTravelModesView();
  }

  void openProfileView() {
    _navigationService.replaceWithProfileView();
  }

  void openTripView() {
    _navigationService.navigateToTripView();
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      // description: 'Give stacked $_counter stars on Github',
    );
  }

  void logout() {
    _userService.logout();
    _navigationService.replaceWithLoginRegisterView();
  }
}
