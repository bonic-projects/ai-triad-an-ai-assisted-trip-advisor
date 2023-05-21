import 'package:ai_triad/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../models/appuser.dart';
import '../../../models/trip.dart';
import '../../../services/firestore_service.dart';
import '../../../services/user_service.dart';

class TripViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  AppUser? get user => _userService.user;
  final _navigationService = locator<NavigationService>();
  final _firestoreService = locator<FirestoreService>();

  void openHomeView() {
    _navigationService.replaceWithHomeView();
  }

  void openProfileView() {
    _navigationService.replaceWithProfileView();
  }

  void logout() {
    _userService.logout();
    _navigationService.replaceWithLoginRegisterView();
  }

  List<Trip> _upcomingTrips = [];
  List<Trip> _pastTrips = [];

  List<Trip> get upcomingTrips => _upcomingTrips;
  List<Trip> get pastTrips => _pastTrips;

  Future<void> fetchTrips() async {
    setBusy(true);

    // Fetch trips for the current user
    final userId = _userService.user!.id;
    final trips = await _firestoreService.fetchUserTrips(userId);

    // Sort trips into upcoming and past trips based on the date
    final currentDate = DateTime.now();
    _upcomingTrips =
        trips.where((trip) => trip.date.isAfter(currentDate)).toList();
    _pastTrips =
        trips.where((trip) => trip.date.isBefore(currentDate)).toList();

    setBusy(false);
  }
}
