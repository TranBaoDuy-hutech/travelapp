import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GuideAssignmentPage extends StatefulWidget {
  const GuideAssignmentPage({super.key});

  @override
  State<GuideAssignmentPage> createState() => _GuideAssignmentPageState();
}

class _GuideAssignmentPageState extends State<GuideAssignmentPage> {
  bool isLoading = true;
  String? errorMessage;
  List assignments = [];

  @override
  void initState() {
    super.initState();
    fetchAssignments();
  }

  Future<void> fetchAssignments() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response =
      await http.get(Uri.parse('http://10.0.2.2:8000/admin/assignments'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Assignments raw data: $data"); // debug API response
        setState(() {
          assignments = data['data'] ?? [];
          print("Assignments length: ${assignments.length}");
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load assignments");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
        print("Error fetching assignments: $e");
      });
    }
  }

  Future<void> deleteAssignment(int tourId, int guideId) async {
    try {
      final response = await http.delete(
        Uri.parse(
            "http://10.0.2.2:8000/admin/assignments?tour_id=$tourId&guide_id=$guideId"),
      );
      print("Delete response status: ${response.statusCode}");
      print("Delete response body: ${response.body}");
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Xóa thành công")));
        fetchAssignments(); // refresh list
      } else {
        throw Exception("Failed to delete assignment");
      }
    } catch (e) {
      print("Error deleting assignment: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text("Guide Assignments"), backgroundColor: Colors.teal),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text("Error: $errorMessage"))
          : assignments.isEmpty
          ? const Center(child: Text("Chưa có phân công HDV nào"))
          : ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          final a = assignments[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.teal),
              title: Text("${a['GuideName']} (${a['Role']})"),
              subtitle: Text(
                  "Tour: ${a['TourName']} | Ngày: ${a['AssignmentDate']}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () =>
                    deleteAssignment(a['TourID'], a['GuideID']),
              ),
            ),
          );
        },
      ),
    );
  }
}
