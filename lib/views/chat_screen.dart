import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/chat_view_model.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChatViewModel>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50), // Adjust the height as needed
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10), // Rounded bottom edges
          ),
          child: AppBar(
            title: Center(
              child: const Text(
                '_SM-AI_',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 24, // Adjust font size for better impact
                  color: Colors.white, // White text for contrast
                ),
              ),
            ),
            centerTitle: true,
            elevation: 4,
            backgroundColor: Colors.deepPurpleAccent, // Solid background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(15), // Ensures rounded corners on the bottom
              ),
            ),
          ),
        ),
      ),


      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    Theme.of(context).colorScheme.background,
                  ],
                ),
              ),
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: viewModel.messages.length,
                itemBuilder: (context, index) {
                  final message = viewModel.messages.reversed.toList()[index];
                  return ChatBubble(message: message);
                },
              ),
            ),
          ),
          _buildInputArea(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, ChatViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onSubmitted: (value) => _sendMessage(context, viewModel),
            ),
          ),
          const SizedBox(width: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).colorScheme.primary, Colors.deepPurpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  blurRadius: 8,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: viewModel.isLoading
                  ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Icon(Icons.send, color: Colors.white, size: 24),
              onPressed: viewModel.isLoading
                  ? null
                  : () => _sendMessage(context, viewModel),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(BuildContext context, ChatViewModel viewModel) {
    if (_controller.text.isNotEmpty) {
      viewModel.sendMessage(_controller.text);
      _controller.clear();
    }
  }
}
