import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  final int customerId;
  final String? customerName;

  const ChatPage({super.key, required this.customerId, this.customerName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late WebSocketChannel channel;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  List<Map<String, dynamic>> pendingMessages = [];
  bool isLoading = true;
  bool isSendingMessage = false;

  @override
  void initState() {
    super.initState();
    fetchChatHistory();
    connectWebSocket();
  }

  Future<void> fetchChatHistory() async {
    setState(() => isLoading = true);
    final url = Uri.parse('http://10.0.2.2:8000/chat/history/${widget.customerId}');
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body)['chat'];
        setState(() {
          messages = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
        _scrollToBottom();
      } else {
        throw Exception('Lỗi khi tải lịch sử chat: ${res.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void connectWebSocket() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:8000/ws/chat/${widget.customerId}'),
    );

    channel.stream.listen(
          (msg) {
        print('Received WebSocket message: $msg'); // Debug log
        Map<String, dynamic> message;
        try {
          message = jsonDecode(msg);
        } catch (e) {
          print('Error decoding WebSocket message: $e');
          message = {
            'Content': msg.toString(),
            'IsFromAdmin': true,
            'CreatedAt': DateTime.now().toIso8601String(),
            'MessageID': null,
          };
        }

        if (message['CustomerID'] == widget.customerId) {
          setState(() {
            final messageId = message['MessageID'];
            if (messageId != null &&
                !messages.any((m) => m['MessageID'] == messageId)) {
              messages.add(message);
              print('Added message to messages: $message');
            }
            pendingMessages.removeWhere((pending) => pending['Content'] == message['Content']);
            print('Pending messages after removal: $pendingMessages');
          });
          _scrollToBottom();
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi kết nối WebSocket: $error'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      },
      onDone: () {
        print('WebSocket connection closed');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kết nối WebSocket đã đóng'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      },
    );
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty || isSendingMessage) return;

    setState(() => isSendingMessage = true);

    final msg = {
      'CustomerID': widget.customerId,
      'Content': _controller.text,
      'IsFromAdmin': false,
      'CreatedAt': DateTime.now().toIso8601String(),
      'MessageID': null,
    };

    try {
      print('Sending message: $msg'); // Debug log
      channel.sink.add(jsonEncode(msg));
      setState(() {
        pendingMessages.add({...msg, 'IsPending': true});
        print('Added to pendingMessages: $pendingMessages');
      });
      _controller.clear();
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi gửi tin nhắn: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() => isSendingMessage = false);
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        print('ScrollController not attached');
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allMessages = [...messages, ...pendingMessages];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.customerName != null
              ? 'Chat với Admin (${widget.customerName})'
              : 'Chat với Admin (ID: ${widget.customerId})',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : allMessages.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có tin nhắn nào',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: allMessages.length,
              itemBuilder: (context, index) {
                final msg = allMessages[index];
                final isAdmin = msg['IsFromAdmin'] ?? false;
                final isPending = msg['IsPending'] ?? false;
                final timestamp = msg['CreatedAt'] != null
                    ? DateTime.parse(msg['CreatedAt']).toLocal()
                    : DateTime.now();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Align(
                    alignment: isAdmin ? Alignment.centerLeft : Alignment.centerRight,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isAdmin
                            ? Colors.grey[200]
                            : (isPending ? Colors.blue[50] : Colors.blue[100]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment:
                        isAdmin ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                        children: [
                          Text(
                            msg['Content'] ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: isPending ? Colors.grey[600] : Colors.black,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.clip,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      suffixIcon: isSendingMessage
                          ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                          : null,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: isSendingMessage ? Colors.grey : Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: isSendingMessage ? null : _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(Icons.send, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}