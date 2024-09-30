class LoginModel {
  List<Results>? results;

  LoginModel({this.results});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  String? role;
  String? roleText;
  String? employeeSegment;
  String? employeeSegmentText;
  String? uUID;
  String? appID;
  String? appActivity;
  String? deviceModel;
  String? oSVersion;
  bool? result;
  String? remarks;
  String? appVersion;

  Results(
      {this.employeeEmailID,
      this.employeeID,
      this.employeeName,
      this.role,
      this.roleText,
      this.employeeSegment,
      this.employeeSegmentText,
      this.uUID,
      this.appID,
      this.appActivity,
      this.deviceModel,
      this.oSVersion,
      this.result,
      this.remarks,
      this.appVersion});

  Results.fromJson(Map<String, dynamic> json) {
    employeeEmailID = json['EmployeeEmailID'];
    employeeID = json['EmployeeID'];
    employeeName = json['EmployeeName'];
    role = json['Role'];
    roleText = json['RoleText'];
    employeeSegment = json['EmployeeSegment'];
    employeeSegmentText = json['EmployeeSegmentText'];
    uUID = json['UUID'];
    appID = json['AppID'];
    appActivity = json['AppActivity'];
    deviceModel = json['DeviceModel'];
    oSVersion = json['OSVersion'];
    result = json['Result'];
    remarks = json['Remarks'];
    appVersion = json['AppVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EmployeeEmailID'] = this.employeeEmailID;
    data['EmployeeID'] = this.employeeID;
    data['EmployeeName'] = this.employeeName;
    data['Role'] = this.role;
    data['RoleText'] = this.roleText;
    data['EmployeeSegment'] = this.employeeSegment;
    data['EmployeeSegmentText'] = this.employeeSegmentText;
    data['UUID'] = this.uUID;
    data['AppID'] = this.appID;
    data['AppActivity'] = this.appActivity;
    data['DeviceModel'] = this.deviceModel;
    data['OSVersion'] = this.oSVersion;
    data['Result'] = this.result;
    data['Remarks'] = this.remarks;
    data['AppVersion'] = this.appVersion;
    return data;
  }
}
