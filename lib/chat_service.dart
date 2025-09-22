import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  final String apiUrl = "http://10.0.2.2:8000"; // IP backend
  WebSocketChannel? _channel;

  // Kết nối WebSocket
  void connect(int customerId) {
    _channel = WebSocketChannel.connect(
      Uri.parse("$apiUrl/ws/chat/$customerId"),
    );
  }

  // Ngắt kết nối
  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  // Stream tin nhắn nhận từ server
  Stream get messagesStream {
    if (_channel == null) {
      throw Exception("WebSocket chưa kết nối");
    }
    return _channel!.stream;
  }

  // Gửi tin nhắn
  void sendMessage({
    required int customerId,
    int? userId,
    required String content,
    bool isFromAdmin = false,
  }) {
    final msg = jsonEncode({
      "CustomerID": customerId,
      "UserID": userId,
      "Content": content,
      "IsFromAdmin": isFromAdmin,
    });
    _channel?.sink.add(msg);
  }

  // Lấy lịch sử chat (REST)
  Future<List<Map<String, dynamic>>> getHistory(int customerId) async {
    final res = await http.get(Uri.parse("$apiUrl/chat/history/$customerId"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      return List<Map<String, dynamic>>.from(data["chat"].map((msg) => {
        "MessageID": msg["MessageID"],
        "CustomerID": msg["CustomerID"],
        "UserID": msg["UserID"],
        "Content": msg["Content"],
        "CreatedAt": msg["CreatedAt"], // backend dùng CreatedAt
        "IsFromAdmin": msg["IsFromAdmin"] ?? false,
      }));
    } else {
      throw Exception("Lỗi tải lịch sử chat: ${res.statusCode}");
    }
  }

  // Lấy danh sách khách cho Admin
  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    final res = await http.get(Uri.parse("$apiUrl/admin/chat/customers"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return List<Map<String, dynamic>>.from(data.map((c) => {
        "CustomerID": c["CustomerID"],
        "UserName": c["UserName"],
      }));
    } else {
      throw Exception("Lỗi tải danh sách khách: ${res.statusCode}");
    }
  }
}
