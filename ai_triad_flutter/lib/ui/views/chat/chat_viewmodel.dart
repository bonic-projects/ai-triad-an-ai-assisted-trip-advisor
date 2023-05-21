import 'package:ai_triad/app/app.dialogs.dart';
import 'package:ai_triad/models/hotel.dart';
import 'package:ai_triad/models/travelModes.dart';
import 'package:ai_triad/models/trip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../services/firestore_service.dart';
import '../../../services/gpt_service.dart';
import '../../../services/user_service.dart';

class ChatMessage {
  final String content;
  final bool isUser;

  ChatMessage({required this.content, required this.isUser});
}

// Define the questions and their corresponding text
const Map<int, String> questions = {
  1: 'date',
  2: 'travelStart',
  3: 'travelDestination',
  4: 'budget',
  5: 'accommodationType',
  6: 'needTourGuide',
  7: 'soloTravel',
  8: 'travelMode',
};

const Map<String, String> questionTexts = {
  'date': 'When do you want to travel?',
  'travelStart': 'Where are you travelling from?',
  'travelDestination': 'Where do you want to go?',
  'budget': 'What is your budget for the trip?',
  'accommodationType': 'What type of accommodation do you prefer?',
  'needTourGuide': 'Do you need a tour guide for your trip? (Yes/No)',
  'soloTravel': 'Are you planning a solo trip? (Yes/No)',
  'travelMode': 'How do you plan to travel?',
};

class ChatViewModel extends BaseViewModel {
  final log = getLogger('ChatViewModel');

  final _userService = locator<UserService>();
  final _firestoreService = locator<FirestoreService>();
  final _dialogService = locator<DialogService>();
  final _gptService = locator<GptChatService>();

  List<ChatMessage> messages = [];
  TextEditingController messageController = TextEditingController();

  // Variables to store user answers
  DateTime? date;
  String travelStart = '';
  String travelDestination = '';
  String budget = '';
  String accommodationType = '';
  bool needTourGuide = false;
  bool soloTravel = false;
  String travelMode = '';

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != date) {
      if (date == null) sendMessage(isDate: true);
      date = picked;
      notifyListeners();
    }
  }

  void onModelReady() async {
    final responseContent = await generateResponse();
    addMessage(responseContent, false);
    addMessage("date", true);
  }

  void addMessage(String content, bool isUser) {
    final message = ChatMessage(content: content, isUser: isUser);
    messages.add(message);
    notifyListeners();
  }

  void sendMessage({bool isDate = false}) {
    final messageContent = messageController.text.trim();
    if (messageContent.isNotEmpty || isDate) {
      if (isDate) {
        // Process the message (e.g., validate, save to variables, etc.)
        // processAnswer("date");
      } else {
        addMessage(messageContent, true);
        // Process the message (e.g., validate, save to variables, etc.)
        processAnswer(messageContent);
        // Clear the text field
        messageController.clear();
      }

      // Simulate response delay
      Future.delayed(const Duration(seconds: 1), () async {
        // Generate a response message
        final responseContent = await generateResponse();
        addMessage(responseContent, false);
      });
    }
  }

  void processAnswer(String answer) {
    log.i(messages.length);
    if (messages.length > 20) {
      log.i("Count: ${messages.length}");
      return;
    }
    // Update corresponding variables based on the user's answer
    final userMessages = messages.isNotEmpty
        ? messages.where((element) => element.isUser).toList()
        : [];
    if (questions.containsKey(userMessages.length)) {
      final question = questions[userMessages.length];
      log.i(userMessages.length);
      log.i(question);
      if (question == 'travelStart') {
        travelStart = answer;
      } else if (question == 'travelDestination') {
        travelDestination = answer;
      } else if (question == 'budget') {
        budget = answer;
      } else if (question == 'accommodationType') {
        accommodationType = answer;
      } else if (question == 'needTourGuide') {
        needTourGuide = answer.toLowerCase() == 'yes';
      } else if (question == 'soloTravel') {
        soloTravel = answer.toLowerCase() == 'yes';
      } else if (question == 'travelMode') {
        travelMode = answer;
      }
    }
  }

  Future<String> generateResponse() async {
    if (messages.length > 24) {
      setBusy(true);
      // String res = await _gptService.getGptReply(messages.last.content);
      String aiMsg = await generateChat(msg: messages.last.content);
      setBusy(false);
      return aiMsg;
    }
    // Generate a response based on the current question
    final userMessages = messages.isNotEmpty
        ? messages.where((element) => element.isUser).toList()
        : [];
    if (questions.containsKey(userMessages.length + 1)) {
      final nextQuestion = questions[userMessages.length + 1];
      return '${userMessages.isNotEmpty ? "Great!" : ""} ${questionTexts[nextQuestion]}';
    } else {
      // Perform the query based on collected answers and return the result
      // Replace this with your own query logic
      getFromFirebase();
      return 'Thank you, wait while we prepare plans for you..';
    }
  }

  List<HotelData> hotels = <HotelData>[];
  List<TravelMode> travelModes = <TravelMode>[];
  void getFromFirebase() async {
    log.i(date);
    log.i(travelStart);
    log.i(travelDestination);
    log.i(budget);
    log.i(accommodationType);
    log.i(needTourGuide);
    log.i(soloTravel);
    log.i(travelMode);

    setBusy(true);
    hotels = await _firestoreService.queryHotels(
        to: travelDestination, type: accommodationType);
    travelModes = await _firestoreService.queryTravelModes(
        from: travelStart, to: travelDestination, type: travelMode);
    setBusy(false);

    log.i("Hotels: ${hotels.length} travelModes: ${travelModes.length}");

    if (hotels.isEmpty) {
      addMessage("Sorry there are no hotels available!", false);
      newChat();
    } else if (travelModes.isEmpty) {
      addMessage("Sorry there are no travel modes available!", false);
      newChat();
    } else {
      generateCombinations();
      log.i("Combs: ${combinations.length}");
      if (combinations.isNotEmpty) {
        addMessage("combinations", false);
      } else {
        addMessage("Sorry there are no options for this budget!", false);
        newChat();
      }
    }
  }

  void newChat() async {
    setBusy(true);
    await Future.delayed(const Duration(seconds: 3));
    date = null;
    messages = <ChatMessage>[];
    setBusy(false);
    onModelReady();
  }

  List<Map<String, dynamic>> combinations = [];
  void generateCombinations() {
    combinations = [];

    // Sort hotels and travel modes based on rate in ascending order
    hotels.sort((a, b) => a.rate.compareTo(b.rate));
    travelModes.sort((a, b) => a.rate.compareTo(b.rate));

    // Iterate over hotels and travel modes to form combinations within budget
    for (final hotel in hotels) {
      for (final travelMode in travelModes) {
        final int totalRate = hotel.rate + travelMode.rate;
        if (totalRate <= int.parse(budget)) {
          combinations.add({
            'hotel': hotel,
            'travelMode': travelMode,
          });

          // Break if the maximum number of combinations is reached
          if (combinations.length >= 5) {
            return;
          }
        }
      }
    }
  }

  Map<String, dynamic>? selectedOption;
  int? rate;
  void selectOption(int index) async {
    if (selectedOption == null) {
      addMessage("Option $index", true);
      selectedOption = combinations[index];
      setBusy(true);
      await Future.delayed(const Duration(seconds: 2));
      setBusy(false);
      rate = selectedOption!['hotel'].rate + selectedOption!['travelMode'].rate;
      addMessage("Total amount to be payed is ₹$rate", false);
      addMessage("payment", true);
    }
  }

  void makePayment() async {
    DialogResponse? res = await _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: "Make payment",
      description: "Total amount to be paid: ₹$rate",
    );
    setBusy(true);
    await Future.delayed(const Duration(seconds: 2));
    setBusy(false);
    if (res != null) {
      if (res.confirmed) {
        _firestoreService.addTrip(Trip(
            date: date!,
            from: travelStart,
            to: travelDestination,
            budget: int.parse(budget),
            accommodationType: accommodationType,
            needTourGuide: needTourGuide,
            soloTravel: soloTravel,
            travelMode: travelMode,
            userId: _userService.user!.id,
            hotelId: selectedOption!['hotel'].id,
            hotelName: selectedOption!['hotel'].name,
            travelModeId: selectedOption!['travelMode'].id,
            travelAgency: selectedOption!['travelMode'].name,
            paymentMade: rate!));
        addMessage("Thank you!. You have made a payment of ₹$rate", false);
        addMessage("Visit ur trips to see the updates!", false);
        addMessage(
            "Preparing you trip.. Ask me if you want know anything more about your trip..",
            false);
        setBusy(true);
        String aiMsg = await generateChat();
        setBusy(false);

        addMessage(aiMsg, false);
      } else {
        addMessage("Payment canceled.. Starting again.", false);
        setBusy(true);
        await Future.delayed(const Duration(seconds: 2));
        setBusy(false);
        newChat();
      }
    }
    // log.i(messages.length);
  }

  Future<String> generateChat({String? msg}) {
    return _gptService.getGptReply(msg ?? "",
        isInit: msg == null,
        date: DateFormat('dd MMM, yyyy').format(date!),
        travelStart: travelStart,
        travelDestination: travelDestination,
        budget: budget,
        accommodationType: accommodationType,
        needTourGuide: needTourGuide,
        soloTravel: soloTravel,
        travelMode: travelMode,
        hotelName: selectedOption!['hotel'].name,
        travelName: selectedOption!['travelMode'].name,
        rate: rate!);
  }
}
