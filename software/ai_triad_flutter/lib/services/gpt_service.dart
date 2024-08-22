import '../app/app.locator.dart';
import '../app/app.logger.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

import '../constants/app_keys.dart';
import 'firestore_service.dart';

class GptChatService {
  final log = getLogger('GptService');
  final _firestoreService = locator<FirestoreService>();

  late OpenAI openAI;

  void setupGpt(){
    openAI = OpenAI.instance.build(
    token: _firestoreService.data?.apiKey ?? "",
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)),
    enableLog: true);
  }

  Future<String> getGptReply(
    String text, {
    bool isInit = false,
    String? travelStart,
    String? travelDestination,
    String? date,
    String? budget,
    String? accommodationType,
    bool needTourGuide = false,
    bool soloTravel = false,
    String? travelMode,
    int? rate,
    String? hotelName,
    String? travelName,
  }) async {
    ChatCompleteText request;
    if (isInit) {
      // request = ChatCompleteText(messages: [
      //   {
      //     "role": "system",
      //     "content": "You are a helpful assistant for traveller in travelling app."
      //   },
      //   {"role": "user", "content": "Hello! I'm planning a trip."},
      //   {
      //     "role": "user",
      //     "content":
      //         "I am going to travel from $travelStart to $travelDestination."
      //   },
      //   {"role": "user", "content": "My travel date is $date."},
      //   {"role": "user", "content": "My budget is $budget."},
      //   {
      //     "role": "user",
      //     "content": "I chose for $accommodationType accommodation."
      //   },
      //   {
      //     "role": "user",
      //     "content":
      //         "I ${needTourGuide ? 'chose' : 'not chose'} for tour guide."
      //   },
      //   {
      //     "role": "user",
      //     "content": "I traveling ${soloTravel ? 'solo' : 'with team'}."
      //   },
      //   {"role": "user", "content": "My mode of travel is $travelMode."},
      //   {
      //     "role": "user",
      //     "content":
      //         "I have booked my trip for $rate. With hotel $hotelName and travel agency $travelName}"
      //   },
      // ], maxToken: 200, model: ChatModel.gptTurbo0301);
      request = ChatCompleteText(messages: [
        {
          "role": "system",
          "content":
              "You are a helpful assistant for traveller in travelling app."
        },
        {
          "role": "system",
          "content": "travel from $travelStart to $travelDestination."
        },
        {"role": "system", "content": "travel date is $date."},
        {"role": "system", "content": "budget is $budget."},
        {"role": "system", "content": " $accommodationType accommodation."},
        {
          "role": "system",
          "content": "${needTourGuide ? 'chose' : 'not chose'} for tour guide."
        },
        {
          "role": "system",
          "content": "traveling ${soloTravel ? 'solo' : 'with team'}."
        },
        {"role": "system", "content": " mode of travel is $travelMode."},
        {
          "role": "system",
          "content":
              " trip for $rate. with hotel $hotelName and travel agency $travelName}"
        },
        {"role": "user", "content": "Hello!."},
      ], maxToken: 200, model: ChatModel.gptTurbo0301);
    } else {
      // request = ChatCompleteText(messages: [
      //   Map.of({"role": "user", "content": text})
      // ], maxToken: 1000, model: ChatModel.gptTurbo0301);
      request = ChatCompleteText(messages: [
        {
          "role": "system",
          "content":
              "You are a helpful assistant for traveller in travelling app."
        },
        {
          "role": "system",
          "content": "travel from $travelStart to $travelDestination."
        },
        {"role": "system", "content": "travel date is $date."},
        {"role": "system", "content": "budget is $budget."},
        {"role": "system", "content": " $accommodationType accommodation."},
        {
          "role": "system",
          "content": "${needTourGuide ? 'chose' : 'not chose'} for tour guide."
        },
        {
          "role": "system",
          "content": "traveling ${soloTravel ? 'solo' : 'with team'}."
        },
        {"role": "system", "content": " mode of travel is $travelMode."},
        {
          "role": "system",
          "content":
              " trip for $rate. with hotel $hotelName and travel agency $travelName}"
        },
        {"role": "user", "content": text},
      ], maxToken: 200, model: ChatModel.gptTurbo0301);
    }

    try {
      ChatCTResponse? res = await openAI.onChatCompletion(request: request);
      log.i(
          "request ${res?.choices.length} ${res?.choices.first.message?.content}");
      if (res != null && res.choices.isNotEmpty) {
        return res.choices.first.message?.content ?? "Error in text";
      } else {
        return "Error";
      }
    } catch (e) {
      log.e(e);
      return "Error: $e";
    }
  }

  //
  // Future<void> getGptReply(String text, {bool isFirst = false}) async {
  //   log.i(text);
  //   Completion? completion;
  //   try {
  //     completion = await chatGpt.textCompletion(
  //       request: CompletionRequest(
  //         prompt: "hello",
  //         maxTokens: 200,
  //       ),
  //     );
  //   } catch (e) {
  //     log.e("Error: $e");
  //   }
  //
  //   if (completion != null) {
  //     log.i(
  //         "Completion: ${completion.choices!.length} ${completion.choices!.first.text}");
  //   } else {
  //     log.e("Error");
  //   }
  // }
}
