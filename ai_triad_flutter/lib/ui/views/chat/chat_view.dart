import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

import 'chat_viewmodel.dart';

class ChatView extends StackedView<ChatViewModel> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ChatViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          if (viewModel.isBusy)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/views/home.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: viewModel.messages.length,
                itemBuilder: (context, index) {
                  final message = viewModel.messages.reversed.toList()[index];
                  if (message.content == "payment") {
                    return Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: viewModel.makePayment,
                                child: const Text(
                                  "Pay now!",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (message.content == "combinations") {
                    return Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Choose an option",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  viewModel.combinations.map((combination) {
                                return GestureDetector(
                                  onTap: () {
                                    viewModel.selectOption(viewModel
                                        .combinations
                                        .indexOf(combination));
                                  },
                                  child: Card(
                                    elevation: 2,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Option ${viewModel.combinations.indexOf(combination) + 1}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            'Hotel: ${combination['hotel'].name}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                              'Place: ${combination['hotel'].place}'),
                                          Text(
                                              'Rate: ₹${combination['hotel'].rate}'),
                                          Text(
                                            'Travel Mode: ${combination['travelMode'].name}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                              'Rate: ₹${combination['travelMode'].rate}'),
                                          // Display other details as needed
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (message.content == "date") {
                    return Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: GestureDetector(
                          onTap: () => viewModel.selectDate(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                viewModel.date == null
                                    ? "Pick a date"
                                    : DateFormat('dd MMM, yyyy')
                                        .format(viewModel.date!),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  // else if(message.content == 'Where are you travelling from?')
                  // return //
                  else {
                    return ChatMessageTile(
                      content: message.content,
                      isUser: message.isUser,
                    );
                  }
                },
              ),
            ),
            const Divider(),
            const ChatInputField(),
          ],
        ),
      ),
    );
  }

  @override
  ChatViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ChatViewModel();

  @override
  void onViewModelReady(ChatViewModel viewModel) => viewModel.onModelReady();
}

class ChatMessageTile extends StatelessWidget {
  final String content;
  final bool isUser;

  const ChatMessageTile(
      {super.key, required this.content, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: isUser ? Colors.black : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Text(
          content,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class ChatInputField extends ViewModelWidget<ChatViewModel> {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context, ChatViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.words,
              controller: viewModel.messageController,
              decoration: const InputDecoration(
                hintText: 'Type your message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: viewModel.sendMessage,
          ),
        ],
      ),
    );
  }
}
