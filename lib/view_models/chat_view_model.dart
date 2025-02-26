import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/api_service.dart';

class ChatViewModel extends ChangeNotifier {
  final List<Message> _messages = [];
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    // Add user message
    _addUserMessage(text);

    try {
      _isLoading = true;
      notifyListeners();

      // Get bot response
      final response = await _apiService.sendMessage(text);
      _addBotMessage(response);
    } catch (e) {
      _addBotMessage('Sorry, I encountered an error. Please try again.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _addUserMessage(String text) {
    _messages.add(Message(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  void _addBotMessage(String text) {
    _messages.add(Message(
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }
}