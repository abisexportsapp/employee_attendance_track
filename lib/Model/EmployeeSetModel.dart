class EmployeeSetModel {
  List<Results>? results;

  EmployeeSetModel({this.results});

  EmployeeSetModel.fromJson(Map<String, dynamic> json) {
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
  String? employeeID;
  String? employeeName;
  String? employeeRole;
  String? employeeLocation;
  String? employeeSegment;
  String? employeeEmail;
  String? latitude;
  String? longitude;
  String? emplatitude;
  String? emplongitude;
  String? result;
  String? remarks;

  Results(
      {this.employeeID,
      this.employeeName,
      this.employeeRole,
      this.employeeLocation,
      this.employeeSegment,
      this.employeeEmail,
      this.latitude,
      this.longitude,
      this.emplatitude,
      this.emplongitude,
      this.result,
      this.remarks});

  Results.fromJson(Map<String, dynamic> json) {
    employeeID = json['EmployeeID'];
    employeeName = json['EmployeeName'];
    employeeRole = json['EmployeeRole'];
    employeeLocation = json['EmployeeLocation'];
    employeeSegment = json['EmployeeSegment'];
    employeeEmail = json['EmployeeEmail'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    emplatitude = json['emplatitude'];
    emplongitude = json['emplongitude'];
    result = json['result'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['EmployeeRole'] = this.employeeRole;
    data['EmployeeLocation'] = this.employeeLocation;
    data['EmployeeSegment'] = this.employeeSegment;
    data['EmployeeEmail'] = this.employeeEmail;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['emplatitude'] = this.emplatitude;
    data['emplongitude'] = this.emplongitude;
    data['result'] = this.result;
    data['remarks'] = this.remarks;
    return data;
  }
}
