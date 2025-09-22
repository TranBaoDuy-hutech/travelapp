import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingPage extends StatefulWidget {
  final Map<String, dynamic> tour;
  const BookingPage({Key? key, required this.tour}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  int _numGuests = 1;
  DateTime? _selectedDate;
  String _specialRequests = "";
  bool _isLoading = false;

  String formatPrice(dynamic price) {
    final formatter = NumberFormat("#,##0", "vi_VN");
    final parsed = double.tryParse(price.toString()) ?? 0;
    return "${formatter.format(parsed)} VND";
  }

  double get totalPrice {
    final price = double.tryParse(widget.tour["Price"].toString()) ?? 0;
    return price * _numGuests;
  }

  Future<void> confirmBooking() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      if (_selectedDate!.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ngày khởi hành không hợp lệ")),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final bookingData = {
          "CustomerID": globals.currentCustomer!.customerID,
          "TourID": widget.tour['TourID'],
          "BookingDate": _selectedDate!.toIso8601String(),
          "NumberOfPeople": _numGuests,
          "TotalPrice": totalPrice,
          "SpecialRequests": _specialRequests.isEmpty ? null : _specialRequests,
        };

        final response = await http.post(
          Uri.parse("http://10.0.2.2:8000/bookings"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(bookingData),
        );

        if (response.statusCode != 200) {
          throw Exception("Lỗi đặt tour: ${response.body}");
        }

        final resJson = jsonDecode(response.body);
        final bookingID = resJson["BookingID"];
        final emailSent = resJson["EmailSent"] ?? true;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "🎉 Đặt tour thành công!\nMã Booking: $bookingID\n" +
                  (emailSent
                      ? "✉️ Email xác nhận đã được gửi."
                      : "⚠️ Email xác nhận chưa gửi được."),
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Lỗi: $e\nEmail có thể chưa gửi được.")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")),
      );
    }
  }

  Widget buildSectionCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tour = widget.tour;
    final customer = globals.currentCustomer;

    return Scaffold(
      appBar: AppBar(
        title: Text("Đặt Tour: ${tour['TourName']}"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Thông tin khách hàng
                  buildSectionCard(title: "👤 Thông tin khách hàng", children: [
                    Text("Tên: ${customer!.userName}"),
                    Text("Email: ${customer.email}"),
                    Text("Số điện thoại: ${customer.phone ?? '-'}"),
                  ]),

                  // Thông tin tour
                  buildSectionCard(title: "🗺️ Thông tin tour", children: [
                    Text("Địa điểm: ${tour['Location'] ?? '-'}"),
                    Text("Giá: ${formatPrice(tour['Price'])} / khách"),
                    Text("Thời gian: ${tour['DurationDays'] ?? '-'} ngày"),
                    Text("Điểm xuất phát: ${tour['DepartureLocation'] ?? '-'}"),
                    Text("Khách sạn: ${tour['HotelName'] ?? '-'}"),
                    Text("Phương tiện: ${tour['Transportation'] ?? '-'}"),
                  ]),

                  // Form đặt tour
                  buildSectionCard(title: "📝 Chi tiết đặt tour", children: [
                    // số khách
                    TextFormField(
                      initialValue: '10',
                      decoration: InputDecoration(
                        labelText: "Số khách",
                        prefixIcon: const Icon(Icons.people, color: Colors.teal),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Vui lòng nhập số khách";
                        }
                        final n = int.tryParse(val);
                        if (n == null || n < 10) return "Phải là số >= 10";
                        if (n > 50) return "Số khách tối đa là 50";
                        return null;

                      },
                      onChanged: (val) {
                        final n = int.tryParse(val) ?? 1;
                        setState(() => _numGuests = n.clamp(1, 50));
                      },
                    ),
                    const SizedBox(height: 16),

                    // chọn ngày
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      tileColor: Colors.teal[50],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      title: Text(_selectedDate == null
                          ? "Chọn ngày khởi hành"
                          : "Ngày: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}"),
                      trailing:
                      const Icon(Icons.calendar_today, color: Colors.teal),
                      onTap: _isLoading
                          ? null
                          : () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                          DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() => _selectedDate = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // yêu cầu đặc biệt
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Yêu cầu đặc biệt",
                        hintText: "VD: Yêu cầu phòng gần cửa sổ",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (val) => _specialRequests = val,
                    ),
                  ]),

                  // Tổng giá
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.deepOrangeAccent]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        "💰 Tổng giá: ${formatPrice(totalPrice)}",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nút xác nhận
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        backgroundColor: Colors.teal,
                      ),
                      onPressed: _isLoading ? null : confirmBooking,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("✅ Xác nhận đặt tour"),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
