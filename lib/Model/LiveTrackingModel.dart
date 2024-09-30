import 'dart:convert';

class LiveTrekingModel {
  List<Results> results = [];

  LiveTrekingModel();

  LiveTrekingModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (results != null) {
      data['results'] = results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String mobileNumber = '';
  String employeeID = '';
  String workDate = '';
  String shipmentNumber = '';
  String businessPartner = '';
  bool geoTraceEnabled = false;
  String traceFrequencyMin = '';
  String geoLat = '';
  String geoLon = '';
  String placemark = '';
  String actionType = '';
  bool beginTrip = false;
  bool endTrip = false;
  String plannedTraceDetails = '';
  String actualTraceDetails = '';
  String totalPlannedKM = '';
  String totalPlannedTime = '';
  String totalActualKM = '';
  String totalActualTime = '';
  bool tripCompleted = false;
  bool result = false;
  String remarks = '';
  List<Map<String, dynamic>> plannedTraceDetailsList = [];

  Results();

  Results.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['MobileNumber'].toString();
    employeeID = json['EmployeeID'].toString();
    workDate = json['WorkDate'].toString();
    shipmentNumber = json['ShipmentNumber'].toString();
    businessPartner = json['BusinessPartner'].toString();
    geoTraceEnabled = json['GeoTraceEnabled'];
    traceFrequencyMin = json['TraceFrequencyMin'].toString();
    geoLat = json['GeoLat'].toString();
    geoLon = json['GeoLon'].toString();
    placemark = json['Placemark'].toString();
    actionType = json['ActionType'].toString();
    beginTrip = json['BeginTrip'];
    endTrip = json['EndTrip'];
    plannedTraceDetails = json['PlannedTraceDetails'].toString();
    if (json['PlannedTraceDetails'] != null &&
        json['PlannedTraceDetails'] != '') {
      plannedTraceDetailsList = List<Map<String, dynamic>>.from(
          jsonDecode(json['PlannedTraceDetails']));
    }
    actualTraceDetails = json['ActualTraceDetails'].toString();
    totalPlannedKM = json['TotalPlannedKM'].toString();
    totalPlannedTime = json['TotalPlannedTime'].toString();
    totalActualKM = json['TotalActualKM'].toString();
    totalActualTime = json['TotalActualTime'].toString();
    tripCompleted = json['TripCompleted'];
    result = json['Result'];
    remarks = json['Remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['MobileNumber'] = mobileNumber;
    data['EmployeeID'] = employeeID;
    data['WorkDate'] = workDate;
    data['ShipmentNumber'] = shipmentNumber;
    data['BusinessPartner'] = businessPartner;
    data['GeoTraceEnabled'] = geoTraceEnabled;
    data['TraceFrequencyMin'] = traceFrequencyMin;
    data['GeoLat'] = geoLat;
    data['GeoLon'] = geoLon;
    data['Placemark'] = placemark;
    data['ActionType'] = actionType;
    data['BeginTrip'] = beginTrip;
    data['EndTrip'] = endTrip;
    data['PlannedTraceDetails'] = plannedTraceDetails;
    data['ActualTraceDetails'] = actualTraceDetails;
    data['TotalPlannedKM'] = totalPlannedKM;
    data['TotalPlannedTime'] = totalPlannedTime;
    data['TotalActualKM'] = totalActualKM;
    data['TotalActualTime'] = totalActualTime;
    data['TripCompleted'] = tripCompleted;
    data['Result'] = result;
    data['Remarks'] = remarks;
    data['PlannedTraceDetails'] =
        plannedTraceDetailsList.map((x) => x).toList();
    return data;
  }
}
