class AttendanceModel {
  List<Results>? results;

  AttendanceModel({this.results});

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? employeeEmailID;
  String? employeeID;
  String? employeeName;
  String? counter;
  String? date;
  String? dAY;
  String? attendancein;
  String? attendanceout;
  String? lotnumber;
  String? checkin;
  String? checkout;
  String? purposeVisit;
  String? purpose;
  String? remarks;
  bool? result;
  String? farmerName;
  String? allowanceperkm;
  String? totalAllowance;
  String? latitude;
  String? longitude;
  String? kilometerstravelled;
  String? kilometersclaimed;

  Results(
      {this.employeeEmailID,
      this.employeeID,
      this.employeeName,
      this.counter,
      this.date,
      this.dAY,
      this.attendancein,
      this.attendanceout,
      this.lotnumber,
      this.checkin,
      this.checkout,
      this.purposeVisit,
      this.purpose,
      this.remarks,
      this.result,
      this.farmerName,
      this.allowanceperkm,
      this.totalAllowance,
      this.latitude,
      this.longitude,
      this.kilometerstravelled,
      this.kilometersclaimed});

  Results.fromJson(Map<String, dynamic> json) {
    employeeEmailID = json['EmployeeEmailID'];
    employeeID = json['EmployeeID'];
    employeeName = json['EmployeeName'];
    counter = json['Counter'];
    date = json['Date'];
    dAY = json['DAY'];
    attendancein = json['Attendancein'];
    attendanceout = json['Attendanceout'];
    lotnumber = json['Lotnumber'];
    checkin = json['Checkin'];
    checkout = json['Checkout'];
    purposeVisit = json['PurposeVisit'];
    purpose = json['purpose'];
    remarks = json['Remarks'];
    result = json['result'];
    farmerName = json['FarmerName'];
    allowanceperkm = json['Allowanceperkm'];
    totalAllowance = json['TotalAllowance'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    kilometerstravelled = json['Kilometerstravelled'];
    kilometersclaimed = json['Kilometersclaimed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmployeeEmailID'] = this.employeeEmailID;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['Counter'] = this.counter;
    data['Date'] = this.date;
    data['DAY'] = this.dAY;
    data['Attendancein'] = this.attendancein;
    data['Attendanceout'] = this.attendanceout;
    data['Lotnumber'] = this.lotnumber;
    data['Checkin'] = this.checkin;
    data['Checkout'] = this.checkout;
    data['PurposeVisit'] = this.purposeVisit;
    data['purpose'] = this.purpose;
    data['Remarks'] = this.remarks;
    data['result'] = this.result;
    data['FarmerName'] = this.farmerName;
    data['Allowanceperkm'] = this.allowanceperkm;
    data['TotalAllowance'] = this.totalAllowance;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['Kilometerstravelled'] = this.kilometerstravelled;
    data['Kilometersclaimed'] = this.kilometersclaimed;
    return data;
  }
}
