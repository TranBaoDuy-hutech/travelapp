import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

import 'admin_analysis_page.dart';

class AdminChatPage extends StatefulWidget {
  const AdminChatPage({super.key});

  @override
  State<AdminChatPage> createState() => _AdminChatPageState();
}

class _AdminChatPageState extends State<AdminChatPage> {
  static const String baseUrl = "http://10.0.2.2:8000";
  static const String wsUrl = "ws://10.0.2.2:8000";

  List customers = [];
  List messages = [];
  int? selectedCustomerId;
  String? selectedCustomerName;
  WebSocketChannel? channel;
  TextEditingController msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/admin/chat/customers"));
      if (res.statusCode == 200) {
        setState(() {
          customers = jsonDecode(res.body);
        });
      } else {
        print("Lỗi load customers: ${res.statusCode}");
      }
    } catch (e) {
      print("Lỗi load customers: $e");
    }
  }

  Future<void> fetchMessages(int customerId) async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/chat/history/$customerId"));
      if (res.statusCode == 200) {
        setState(() {
          messages = jsonDecode(res.body)["chat"];
        });
      } else {
        print("Lỗi load messages: ${res.statusCode}");
      }
    } catch (e) {
      print("Lỗi load messages: $e");
    }
  }

  void connectWebSocket(int customerId) {
    channel?.sink.close();
    channel = WebSocketChannel.connect(
      Uri.parse("$wsUrl/ws/chat/$customerId"),
    );

    channel!.stream.listen((data) {
      final msg = jsonDecode(data);
      setState(() {
        messages.add(msg);
      });
    });
  }

  void selectCustomer(int id, String name) {
    setState(() {
      selectedCustomerId = id;
      selectedCustomerName = name;
      messages = [];
    });
    fetchMessages(id);
    connectWebSocket(id);
  }

  void sendMessage() {
    if (msgController.text.isEmpty || channel == null) return;
    final msg = {
      "Content": msgController.text,
      "IsFromAdmin": true,
      "CustomerID": selectedCustomerId,
      "UserID": 1,
    };
    channel!.sink.add(jsonEncode(msg));
    msgController.clear();
  }

  Future<void> _showAnalysisDialog() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/chat/analysis/summary"));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final sentiment = data['sentiment'] as Map<String, dynamic>;
        final category = data['category'] as Map<String, dynamic>;

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("📊 Tổng hợp phân tích"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Cảm xúc:", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...sentiment.entries.map((e) => Text("${e.key}: ${e.value}")),
                    const SizedBox(height: 12),
                    const Text("Phân loại chủ đề:", style: TextStyle(fontWeight: FontWeight.bold)),
                    ...category.entries.map((e) => Text("${e.key}: ${e.value}")),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Đóng"),
                )
              ],
            );
          },
        );
      } else {
        print("Lỗi phân tích: ${res.statusCode}");
      }
    } catch (e) {
      print("Lỗi phân tích: $e");
    }
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Nếu chưa chọn khách hàng → hiển thị danh sách
    if (selectedCustomerId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("👥 Danh sách khách hàng"),
          backgroundColor: Colors.blue,
        ),
        body: ListView.builder(
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final customer = customers[index];
            final id = customer['CustomerID'];
            final userName = customer['UserName'] ?? 'Khách $id';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    userName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(userName),
                subtitle: Text("ID: $id"),
                onTap: () => selectCustomer(id, userName),
              ),
            );
          },
        ),
      );
    }

    // Nếu đã chọn khách hàng → hiển thị full màn hình chat
    return Scaffold(
      appBar: AppBar(
        title: Text("💬 Chat với $selectedCustomerName"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selectedCustomerId = null;
              selectedCustomerName = null;
              messages = [];
              channel?.sink.close();
            });
          },
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            tooltip: "Phân tích khách này",
            onPressed: () {
              if (selectedCustomerId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminAnalysisPage(customerId: selectedCustomerId), // 👈 truyền id
                  ),
                );
              }
            },
          ),
        ],


      ),

      body: Column(
        children: [
          // Nội dung chat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isAdmin = msg['IsFromAdmin'] ?? false;

                // Cảm xúc
                String? sentiment = msg['Sentiment'];
                IconData? sentimentIcon;
                Color sentimentColor = Colors.grey;

                if (sentiment == 'Tích cực') {
                  sentimentIcon = Icons.sentiment_satisfied_alt;
                  sentimentColor = Colors.green;
                } else if (sentiment == 'Tiêu cực') {
                  sentimentIcon = Icons.sentiment_dissatisfied;
                  sentimentColor = Colors.red;
                } else if (sentiment == 'Trung lập') {
                  sentimentIcon = Icons.sentiment_neutral;
                  sentimentColor = Colors.grey;
                }

                // Phân loại
                String? category = msg['Category'];

                return Align(
                  alignment:
                  isAdmin ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: isAdmin ? Colors.blue[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['Content'] ?? '',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87),
                        ),
                        if (!isAdmin && (sentiment != null || category != null))
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (sentimentIcon != null)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(sentimentIcon,
                                          color: sentimentColor, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        sentiment ?? '',
                                        style: TextStyle(
                                            color: sentimentColor,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                if (category != null)
                                  Text(
                                    "📌 $category",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.deepPurple),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Ô nhập tin nhắn
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgController,
                    decoration: InputDecoration(
                      hintText: "Nhập tin nhắn...",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
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
