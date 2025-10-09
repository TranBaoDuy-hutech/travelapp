import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FlightPage extends StatefulWidget {
  const FlightPage({super.key});

  @override
  State<FlightPage> createState() => _FlightPageState();
}

class _FlightPageState extends State<FlightPage> {
  final List<Map<String, dynamic>> flights = [
    {
      "airline": "Vietnam Airlines",
      "flightNo": "VN123",
      "from": "Hà Nội",
      "to": "TP. HCM",
      "departureTime": DateTime(2025, 10, 1, 8, 30),
      "arrivalTime": DateTime(2025, 10, 1, 10, 45),
      "price": 1500000,
      "gate": "12",
      "status": "On Time"
    },
    {
      "airline": "VietJet Air",
      "flightNo": "VJ456",
      "from": "Hà Nội",
      "to": "Đà Nẵng",
      "departureTime": DateTime(2025, 10, 1, 9, 0),
      "arrivalTime": DateTime(2025, 10, 1, 10, 20),
      "price": 900000,
      "gate": "8",
      "status": "On Time"
    },
    {
      "airline": "Bamboo Airways",
      "flightNo": "QH789",
      "from": "TP. HCM",
      "to": "Phú Quốc",
      "departureTime": DateTime(2025, 10, 1, 7, 15),
      "arrivalTime": DateTime(2025, 10, 1, 8, 50),
      "price": 1200000,
      "gate": "15",
      "status": "Boarding"
    },
    {
      "airline": "Vietnam Airlines",
      "flightNo": "VN234",
      "from": "Đà Nẵng",
      "to": "Hà Nội",
      "departureTime": DateTime(2025, 10, 1, 11, 0),
      "arrivalTime": DateTime(2025, 10, 1, 12, 20),
      "price": 950000,
      "gate": "5",
      "status": "Delayed"
    },
    {
      "airline": "VietJet Air",
      "flightNo": "VJ567",
      "from": "TP. HCM",
      "to": "Hà Nội",
      "departureTime": DateTime(2025, 10, 1, 13, 30),
      "arrivalTime": DateTime(2025, 10, 1, 15, 50),
      "price": 1600000,
      "gate": "7",
      "status": "On Time"
    },
    {
      "airline": "Bamboo Airways",
      "flightNo": "QH890",
      "from": "Đà Nẵng",
      "to": "TP. HCM",
      "departureTime": DateTime(2025, 10, 1, 14, 10),
      "arrivalTime": DateTime(2025, 10, 1, 15, 35),
      "price": 1100000,
      "gate": "3",
      "status": "On Time"
    },
    {
      "airline": "Vietnam Airlines",
      "flightNo": "VN345",
      "from": "Hà Nội",
      "to": "Phú Quốc",
      "departureTime": DateTime(2025, 10, 1, 16, 0),
      "arrivalTime": DateTime(2025, 10, 1, 18, 30),
      "price": 1800000,
      "gate": "10",
      "status": "On Time"
    },
    {
      "airline": "VietJet Air",
      "flightNo": "VJ678",
      "from": "Phú Quốc",
      "to": "TP. HCM",
      "departureTime": DateTime(2025, 10, 1, 8, 45),
      "arrivalTime": DateTime(2025, 10, 1, 10, 15),
      "price": 1000000,
      "gate": "9",
      "status": "Boarding"
    },
    {
      "airline": "Bamboo Airways",
      "flightNo": "QH901",
      "from": "Hà Nội",
      "to": "Đà Nẵng",
      "departureTime": DateTime(2025, 10, 1, 17, 30),
      "arrivalTime": DateTime(2025, 10, 1, 18, 50),
      "price": 950000,
      "gate": "6",
      "status": "On Time"
    },
    {
      "airline": "Vietnam Airlines",
      "flightNo": "VN456",
      "from": "TP. HCM",
      "to": "Đà Nẵng",
      "departureTime": DateTime(2025, 10, 1, 19, 0),
      "arrivalTime": DateTime(2025, 10, 1, 20, 20),
      "price": 1300000,
      "gate": "14",
      "status": "On Time"
    },
  ];


  String search = "";
  String sortBy = "time";
  bool isLoading = false;
  String? selectedFilter;

  String _calculateDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  List<Map<String, dynamic>> _getFilteredAndSortedFlights() {
    var filteredFlights = flights.where((flight) {
      if (selectedFilter != null) {
        return flight["from"] == selectedFilter || flight["to"] == selectedFilter;
      }
      return flight["from"].toLowerCase().contains(search.toLowerCase()) ||
          flight["to"].toLowerCase().contains(search.toLowerCase()) ||
          flight["airline"].toLowerCase().contains(search.toLowerCase());
    }).toList();

    filteredFlights.sort((a, b) {
      if (sortBy == "price") {
        return a["price"].compareTo(b["price"]);
      }
      return a["departureTime"].compareTo(b["departureTime"]);
    });

    return filteredFlights;
  }

  @override
  Widget build(BuildContext context) {
    final filteredFlights = _getFilteredAndSortedFlights();
    final uniqueLocations = flights
        .map((f) => [f["from"], f["to"]])
        .expand((element) => element)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chuyến Bay"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade700, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() {
                search = value;
                selectedFilter = null;
              }),
              decoration: InputDecoration(
                hintText: "Search by airline, departure, or destination...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: search.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() {
                    search = "";
                    selectedFilter = null;
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
              children: uniqueLocations.map((location) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(location),
                  selected: selectedFilter == location,
                  onSelected: (selected) {
                    setState(() {
                      selectedFilter = selected ? location : null;
                    });
                  },
                  selectedColor: Colors.blue.shade100,
                  checkmarkColor: Colors.blue.shade700,
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredFlights.isEmpty
                ? const Center(child: Text("No flights found"))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredFlights.length,
              itemBuilder: (context, index) {
                final flight = filteredFlights[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      // TODO: Implement flight details navigation
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.blue.shade700,
                            child: Text(
                              flight["airline"][0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${flight["from"]} → ${flight["to"]}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'vi_VN',
                                        symbol: 'VND',
                                        decimalDigits: 0,
                                      ).format(flight["price"]),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      "${DateFormat('HH:mm').format(flight["departureTime"])} - ${DateFormat('HH:mm').format(flight["arrivalTime"])}",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius:
                                        BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _calculateDuration(
                                          flight["departureTime"],
                                          flight["arrivalTime"],
                                        ),
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Flight: ${flight["flightNo"]} • Gate: ${flight["gate"]}",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Status: ${flight["status"]}",
                                  style: TextStyle(
                                    color: flight["status"] == "On Time"
                                        ? Colors.green.shade600
                                        : Colors.orange.shade600,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }
}