import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BusPage extends StatefulWidget {
  const BusPage({super.key});

  @override
  State<BusPage> createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> {
  final List<Map<String, dynamic>> buses = [
    {
      "name": "Hạnh Phúc",
      "route": "TP.HCM → Cần Thơ",
      "departureTime": DateTime(2025, 10, 1, 7, 0),
      "duration": "3h 30m",
      "price": 120000,
      "busType": "Sleeper",
      "seatsAvailable": 15,
      "status": "On Time",
    },
    {
      "name": "An Bình",
      "route": "Hà Nội → Hải Phòng",
      "departureTime": DateTime(2025, 10, 1, 8, 30),
      "duration": "2h 15m",
      "price": 90000,
      "busType": "Seater",
      "seatsAvailable": 20,
      "status": "On Time",
    },
    {
      "name": "Minh Quân",
      "route": "Đà Nẵng → Huế",
      "departureTime": DateTime(2025, 10, 1, 6, 0),
      "duration": "2h 0m",
      "price": 75000,
      "busType": "Seater",
      "seatsAvailable": 10,
      "status": "Boarding",
    },
    {
      "name": "Sao Mai",
      "route": "TP.HCM → Vũng Tàu",
      "departureTime": DateTime(2025, 10, 1, 5, 30),
      "duration": "2h 30m",
      "price": 80000,
      "busType": "Sleeper",
      "seatsAvailable": 12,
      "status": "On Time",
    },
    {
      "name": "Phương Trang",
      "route": "TP.HCM → Đà Lạt",
      "departureTime": DateTime(2025, 10, 1, 9, 0),
      "duration": "6h 0m",
      "price": 200000,
      "busType": "Sleeper",
      "seatsAvailable": 8,
      "status": "On Time",
    },
    {
      "name": "Thành Bưởi",
      "route": "Cần Thơ → TP.HCM",
      "departureTime": DateTime(2025, 10, 1, 10, 0),
      "duration": "3h 45m",
      "price": 130000,
      "busType": "Seater",
      "seatsAvailable": 18,
      "status": "On Time",
    },
    {
      "name": "Hoàng Long",
      "route": "Hà Nội → Thanh Hóa",
      "departureTime": DateTime(2025, 10, 1, 7, 30),
      "duration": "3h 15m",
      "price": 110000,
      "busType": "Sleeper",
      "seatsAvailable": 14,
      "status": "Boarding",
    },
    {
      "name": "Mai Linh",
      "route": "Nha Trang → TP.HCM",
      "departureTime": DateTime(2025, 10, 1, 8, 0),
      "duration": "7h 0m",
      "price": 220000,
      "busType": "Sleeper",
      "seatsAvailable": 10,
      "status": "On Time",
    },
    {
      "name": "Kim Chi",
      "route": "Đà Nẵng → Quảng Ngãi",
      "departureTime": DateTime(2025, 10, 1, 6, 30),
      "duration": "2h 45m",
      "price": 85000,
      "busType": "Seater",
      "seatsAvailable": 16,
      "status": "On Time",
    },
    {
      "name": "Vân Nam",
      "route": "Hà Nội → Lào Cai",
      "departureTime": DateTime(2025, 10, 1, 9, 30),
      "duration": "5h 30m",
      "price": 180000,
      "busType": "Sleeper",
      "seatsAvailable": 9,
      "status": "On Time",
    },
  ];

  String search = "";
  String sortBy = "time";
  bool isLoading = false;
  String? selectedRouteFilter;

  List<Map<String, dynamic>> _getFilteredAndSortedBuses() {
    var filteredBuses = buses.where((bus) {
      if (selectedRouteFilter != null) {
        return bus["route"] == selectedRouteFilter;
      }
      return bus["name"].toLowerCase().contains(search.toLowerCase()) ||
          bus["route"].toLowerCase().contains(search.toLowerCase());
    }).toList();

    filteredBuses.sort((a, b) {
      if (sortBy == "price") {
        return a["price"].compareTo(b["price"]);
      }
      return a["departureTime"].compareTo(b["departureTime"]);
    });

    return filteredBuses;
  }

  @override
  Widget build(BuildContext context) {
    final filteredBuses = _getFilteredAndSortedBuses();
    final uniqueRoutes = buses.map((bus) => bus["route"]).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Xe Khách",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade700, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "time", child: Text("Sort by Time")),
              const PopupMenuItem(value: "price", child: Text("Sort by Price")),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) => setState(() {
                  search = value;
                  selectedRouteFilter = null;
                }),
                decoration: InputDecoration(
                  hintText: "Search by bus name or route...",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: search.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() {
                      search = "";
                      selectedRouteFilter = null;
                    }),
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: uniqueRoutes.map((route) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(route),
                    selected: selectedRouteFilter == route,
                    onSelected: (selected) {
                      setState(() {
                        selectedRouteFilter = selected ? route : null;
                      });
                    },
                    selectedColor: Colors.orange.shade100,
                    checkmarkColor: Colors.orange.shade700,
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredBuses.isEmpty
                  ? const Center(child: Text("No buses found"))
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredBuses.length,
                itemBuilder: (context, index) {
                  final bus = filteredBuses[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Selected ${bus["name"]}"),
                            backgroundColor: Colors.orange.shade700,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.directions_bus,
                              size: 40,
                              color: Colors.orange.shade700,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bus["name"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    bus["route"],
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        "Dep: ${DateFormat('HH:mm').format(bus["departureTime"])}",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade50,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          bus["duration"],
                                          style: TextStyle(
                                            color: Colors.orange.shade700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Type: ${bus["busType"]} • Seats: ${bus["seatsAvailable"]}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Status: ${bus["status"]}",
                                    style: TextStyle(
                                      color: bus["status"] == "On Time"
                                          ? Colors.green.shade600
                                          : Colors.orange.shade600,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              children: [
                                Text(
                                  NumberFormat.currency(
                                    locale: 'vi_VN',
                                    symbol: 'VND',
                                    decimalDigits: 0,
                                  ).format(bus["price"]),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Booking ${bus["name"]}"),
                                        backgroundColor: Colors.orange.shade700,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: const Text("Book"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "© 2025 Trần Bảo Duy. All rights reserved.",
                style: TextStyle(
                  color: Colors.blue.shade900.withOpacity(0.7),
                  fontSize: 15,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}