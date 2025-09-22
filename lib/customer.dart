class Customer {
  final int customerID;
  final String userName;
  final String email;
  final String? phone;
  final String? address;
  final String? dateOfBirth;
  final String? gender;

  Customer({
    required this.customerID,
    required this.userName,
    required this.email,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.gender,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerID: json["CustomerID"] ?? 0,
      userName: json["UserName"] ?? "",
      email: json["Email"] ?? "",
      phone: json["Phone"],
      address: json["Address"],
      dateOfBirth: json["DateOfBirth"],
      gender: json["Gender"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "CustomerID": customerID,
      "UserName": userName,
      "Email": email,
      "Phone": phone,
      "Address": address,
      "DateOfBirth": dateOfBirth,
      "Gender": gender,
    };
  }
}
