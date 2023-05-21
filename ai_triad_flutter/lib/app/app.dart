import 'package:ai_triad/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:ai_triad/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:ai_triad/ui/views/home/home_view.dart';
import 'package:ai_triad/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:ai_triad/ui/views/login/login_view.dart';
import 'package:ai_triad/ui/views/settings/settings_view.dart';
import 'package:ai_triad/services/firestore_service.dart';
import 'package:ai_triad/services/user_service.dart';
import 'package:ai_triad/ui/views/profile/profile_view.dart';
import 'package:ai_triad/ui/views/register/register_view.dart';
import 'package:ai_triad/ui/bottom_sheets/alert/alert_sheet.dart';
import 'package:ai_triad/services/rtdb_service.dart';
import 'package:ai_triad/ui/views/login_register/login_register_view.dart';
import 'package:ai_triad/ui/views/chat/chat_view.dart';
import 'package:ai_triad/ui/views/add_hotel/add_hotel_view.dart';
import 'package:ai_triad/ui/views/add_travel_modes/add_travel_modes_view.dart';

import '../services/gpt_service.dart';
import 'package:ai_triad/ui/views/trip/trip_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: ProfileView),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: LoginRegisterView),
    MaterialRoute(page: ChatView),
    MaterialRoute(page: AddHotelView),
    MaterialRoute(page: AddTravelModesView),
    MaterialRoute(page: TripView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: FirebaseAuthenticationService),
    LazySingleton(classType: FirestoreService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: RtdbService),
    LazySingleton(classType: GptChatService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    StackedBottomsheet(classType: AlertSheet),
// @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
