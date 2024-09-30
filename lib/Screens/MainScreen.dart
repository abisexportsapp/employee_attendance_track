import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:employee_attendance_track/Screens/LoginScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:xml/xml.dart';
import '../Constant/Url.dart';
import '../Model/LiveTrackingModel.dart';
import '../Services/getData.dart';
import 'dart:ui' as ui;

import '../Widget/drawer_header_widget.dart';

class MainScreen extends StatefulWidget {
  final String employeeId;
  final String employeeName;
  final String segment;
  final String name;
  final String Role;
  final String email;
  final String password;
  const MainScreen({
    Key? key,
    required this.employeeId,
    required this.employeeName,
    required this.segment,
    required this.name,
    required this.Role,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  LiveTrekingModel liveTrekingModel = LiveTrekingModel();
  late GoogleMapController mapController;
  List<Marker> markers = [];
  List<Polyline> polylines = [];
  DateRange? selectedDateRange;
  String appBarTitle = 'Employee Dashboard';
  bool isLoadingData = false;
  bool isLiveLoadind = false;
  bool isSatelliteView = false;
  String? plannedTraceDetails = '';
  String? Distance = '';
  String selectedEmployeId = "";
  BitmapDescriptor? customMarkerIcon;
  BitmapDescriptor? lastMarkerIcon;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    selectedDateRange = DateRange(DateTime.now(), DateTime.now());
    print('here is employee id${widget.employeeId}');
    fetchData(widget.employeeId);
    loadCustomMarkerIcon();
    loadLastMarkerIcon();
  }

  Future<void> loadLastMarkerIcon() async {
    lastMarkerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/image/red.png',
    );
  }

  Future<void> loadCustomMarkerIcon() async {
    customMarkerIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/image/lightgreen.png',
    );
  }

  Future<void> fetchData(String selectedEmail) async {
    print(selectedEmail);
    setState(() {
      isLoadingData = true;
    });

    String username = widget.email;
    String password = widget.password;
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));

    DateTime thirtyDaysAgo = DateTime.now().subtract(Duration(days: 30));
    String formattedStartDate = DateFormat('dd-MM-yyyy').format(thirtyDaysAgo);

    try {
      final response = await http.get(
        Uri.parse(
          "https://${AppConstant.url}-plt-bi-farms-manager.cfapps.ap11.hana.ondemand.com/emp_attendance/EMP_ATTENDANCESet?\$filter=EmployeeEmailID eq '$selectedEmail'",
        ),
        headers: <String, String>{'authorization': basicAuth},
      );
      if (response.statusCode == 200) {
        final data = xml.XmlDocument.parse(response.body);
        await parseXmlData(data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$error'),
        ),
      );
    } finally {
      setState(() {
        isLoadingData = false;
        polylines.clear();
      });
    }
  }

  Future<void> parseXmlData(xml.XmlDocument data,
      {bool addPolylines = false}) async {
    List<Map<String, dynamic>> markerInfoList = [];

    final entries = data.findAllElements('entry');
    for (var entry in entries) {
      final content = entry.findElements('content').first;
      final properties = content.findElements('m:properties').first;
      final dateElement = properties.findElements('d:Date').first;
      final date = dateElement != null ? dateElement.text : null;
      final checkin = properties.findElements('d:Checkin').first.text;
      final checkout = properties.findElements('d:Checkout').first.text;
      final Attendancein = properties.findElements('d:Attendancein').first.text;
      print(Attendancein);
      if (date != null && date.isNotEmpty) {
        final dateFormat = DateFormat('dd/MM/yyyy');
        final dateTime = dateFormat.parse(date);

        final latitude =
            double.tryParse(properties.findElements('d:latitude').first.text);
        final longitude =
            double.tryParse(properties.findElements('d:longitude').first.text);
        final purposeOfVisit =
            properties.findElements('d:PurposeVisit').first.text;

        if (latitude != null &&
            longitude != null &&
            Attendancein != null &&
            checkin != null) {
          markerInfoList.add({
            'date': date,
            'purposeOfVisit': purposeOfVisit,
            'latitude': latitude,
            'longitude': longitude,
            'checkin': checkin,
            'checkout': checkout,
            'dateTime': dateTime,
            'Attendancein': Attendancein,
          });
        }
      }
    }

    for (int i = 0; i < markerInfoList.length; i++) {
      final info = markerInfoList[i];
      final onTapCallback = () {
        parseXmlDataForOneDay(data, info['dateTime']);
      };
      final BitmapDescriptor icon = await _createCustomMarkerIcon(info['date']);

      // Extracting the day part from the date string
      final day = info['date'].split('/')[0];

      markers.add(
        Marker(
          markerId: MarkerId('$i'),
          position: LatLng(info['latitude'], info['longitude']),
          icon: icon,
          infoWindow: InfoWindow(
            title: 'Date: ${info['date']}',
            snippet:
                'Purpose of Visit: ${info['purposeOfVisit']}, Check-in: ${info['checkin']}, Check-out: ${info['checkout']}, Attendance In: ${info['Attendancein']}',
            onTap: onTapCallback,
          ),
        ),
      );
    }

    if (addPolylines) {
      polylines.clear();

      polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: markerInfoList
              .map((info) => LatLng(info['latitude'], info['longitude']))
              .toList(),
          color: Colors.blue,
          width: 3,
        ),
      );
    }
  }

  Future<BitmapDescriptor> _createCustomMarkerIcon(String date) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Color.fromARGB(230, 184, 53, 129);

    final double radius = 18;

    canvas.drawCircle(Offset(radius, radius), radius, paint);
    final day = date.split('/')[0];

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: day,
        style: TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
    textPainter.textDirection = ui.TextDirection.ltr;
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(radius - textPainter.width / 2, radius - textPainter.height / 2),
    );

    final ui.Image img = await pictureRecorder.endRecording().toImage(50, 50);
    final ByteData? byteData =
        await img.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception("Failed to convert image to byte data");
    }

    return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
  }

  void parseXmlDataForOneDay(xml.XmlDocument data, DateTime selectedDate) {
    List<Map<String, dynamic>> markerInfoList = [];

    final entries = data.findAllElements('entry');
    for (var entry in entries) {
      final content = entry.findElements('content').first;
      final properties = content.findElements('m:properties').first;
      final date = properties.findElements('d:Date').first.text;
      final checkin = properties.findElements('d:Checkin').first.text;
      final checkout = properties.findElements('d:Checkout').first.text;
      final Attendancein = properties.findElements('d:Attendancein').first.text;
      print(Attendancein);
      final dateFormat = DateFormat('dd/MM/yyyy');
      final dateTime = dateFormat.parse(date);

      final latitude =
          double.tryParse(properties.findElements('d:latitude').first.text);
      final longitude =
          double.tryParse(properties.findElements('d:longitude').first.text);
      final purposeOfVisit =
          properties.findElements('d:PurposeVisit').first.text;

      if (latitude != null &&
          longitude != null &&
          checkin != null &&
          Attendancein != null) {
        if (dateTime.isAtSameMomentAs(selectedDate)) {
          markerInfoList.add({
            'date': date,
            'purposeOfVisit': purposeOfVisit,
            'latitude': latitude,
            'longitude': longitude,
            'checkin': checkin,
            'checkout': checkout,
            'dateTime': dateTime,
            'Attendancein': Attendancein,
          });
        }
      }
    }

    setState(() {
      markers.clear();
      polylines.clear();

      if (markerInfoList.isNotEmpty) {
        for (int i = 0; i < markerInfoList.length; i++) {
          final info = markerInfoList[i];
          markers.add(
            Marker(
              markerId: MarkerId('$i'),
              position: LatLng(info['latitude'], info['longitude']),
              infoWindow: InfoWindow(
                  title: 'Date: ${info['date']}',
                  snippet:
                      'Purpose of Visit: ${info['purposeOfVisit']}, Check-in: ${info['checkin']}, Check-out: ${info['checkout']}, Attendancein: ${info['Attendancein']}'),
            ),
          );
        }

        if (markers.length > 1) {
          List<LatLng> polylinePoints = markerInfoList
              .map((info) => LatLng(info['latitude'], info['longitude']))
              .toList();

          polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: polylinePoints,
              color: Colors.blue,
              width: 3,
            ),
          );
        }
      }
    });
  }

  void toggleMapView() {
    setState(() {
      isSatelliteView = !isSatelliteView;
    });
  }

  Future<void> GetData(String employeeID) async {
    setState(() {
      isLiveLoadind = true;
    });

    print(selectedEmployeId);
    String currentDate = DateFormat('yyyyMMdd').format(DateTime.now());
    print(currentDate);
    SAPGetData(
      remarks: 'Remarks',
      result: 'Result',
      url:
          "https://${AppConstant.url}-plt-bi-farms-manager.cfapps.ap11.hana.ondemand.com/com.plt.bi.farms_manager/FM_LOCDETSet?\$filter= EmployeeID eq '${selectedEmployeId}' and WorkDate eq '$currentDate'",
      userName: widget.email,
      password: widget.password,
      showSnackBar: true,
      context: context,
      onDataRecieved: (data) {
        print('data is received $data');
        setState(() {
          liveTrekingModel = LiveTrekingModel.fromJson(data);
          plannedTraceDetails =
              liveTrekingModel.results.first.actualTraceDetails;
          debugPrint('Planned Trace Details are $plannedTraceDetails');
          Distance = liveTrekingModel.results.first.totalActualKM;
          debugPrint(Distance);
          displayLiveTrackingData();
        });
        setState(() {
          isLiveLoadind = false;
        });
      },
      onErrorRecieved: (data) {
        print('Error Received $data');
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data),
            ),
          );
          isLiveLoadind = false;
        });
      },
    );
  }

  // void displayLiveTrackingData() {
  //   if (plannedTraceDetails != null && plannedTraceDetails!.isNotEmpty) {
  //     List<dynamic> traceDetails = json.decode(plannedTraceDetails!);
  //     List<LatLng> markerPositions = [];
  //     markers.clear();
  //     polylines.clear();

  //     for (var detail in traceDetails) {
  //       if (detail is Map<String, dynamic>) {
  //         double? latitude = detail['GEOLAT'];
  //         double? longitude = detail['GEOLON'];
  //         if (latitude != null && longitude != null) {
  //           LatLng position = LatLng(latitude, longitude);
  //           markerPositions.add(position);
  //         }
  //       }
  //     }

  //     if (markerPositions.isNotEmpty) {
  //       markers.add(
  //         Marker(
  //           markerId: MarkerId('firstMarker'),
  //           position: markerPositions.first,
  //           icon:
  //               BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
  //           infoWindow: InfoWindow(
  //             title: 'First Marker ',
  //           ),
  //         ),
  //       );
  //       markers.add(
  //         Marker(
  //           markerId: MarkerId('lastMarker'),
  //           position: markerPositions.last,
  //           icon:
  //               BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //           infoWindow: InfoWindow(
  //             title: 'Last Marker',
  //           ),
  //         ),
  //       );
  //     }

  //     if (markerPositions.length > 1) {
  //       polylines.add(
  //         Polyline(
  //           polylineId: PolylineId('route'),
  //           points: markerPositions,
  //           color: Colors.blue,
  //           width: 3,
  //         ),
  //       );
  //     }
  //   }
  // }

  void displayLiveTrackingData() {
    if (plannedTraceDetails != null && plannedTraceDetails!.isNotEmpty) {
      List<dynamic> traceDetails = json.decode(plannedTraceDetails!);
      List<LatLng> markerPositions = [];
      markers.clear();
      polylines.clear();
      for (var detail in traceDetails) {
        if (detail is Map<String, dynamic>) {
          double? latitude = detail['GEOLAT'];
          double? longitude = detail['GEOLON'];
          if (latitude != null && longitude != null) {
            LatLng position = LatLng(latitude, longitude);
            markerPositions.add(position);
          }
        }
      }
      for (int i = 0; i < markerPositions.length; i++) {
        String time = traceDetails[i]['TIME'];
        String formattedTime =
            '${time.substring(0, 2)}:${time.substring(2, 4)}:${time.substring(4)}';
        BitmapDescriptor icon = customMarkerIcon!;
        if (i == markerPositions.length - 1) {
          icon = lastMarkerIcon!;
        }
        markers.add(
          Marker(
            markerId: MarkerId(i.toString()),
            position: markerPositions[i],
            icon: icon,
            infoWindow: InfoWindow(
              title: formattedTime,
            ),
          ),
        );
      }

      if (markerPositions.length > 1) {
        polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: markerPositions,
            color: Colors.blue,
            width: 3,
          ),
        );
      }
    }
  }

  void LogoutApi() {
    print("LogOut Called");
    setState(() {
      isloading = true;
    });
    SAPGetData(
      remarks: 'Remarks',
      result: 'Result',
      url:
          "https://${AppConstant.url}-plt-bi-farms-manager.cfapps.ap11.hana.ondemand.com/com.plt.bi.farms_manager/DF_EMPLOYEE_ROLESet?\$filter= EmployeeEmailID eq '${widget.email.replaceAll(' ', '').toLowerCase()}' and AppActivity eq 'LOGOUT' and AppID eq 'PLT-BI-DETD' and UUID eq '1234' and DeviceModel eq '111' and OSVersion eq '11' and AppVersion eq '${AppConstant.prdVersion}'",
      userName: widget.email,
      password: widget.password,
      showSnackBar: true,
      context: context,
      onDataRecieved: (data) {
        debugPrint('data received: ${data}');
        setState(() {
          isloading = false;
        });
      },
      onErrorRecieved: (data) {
        print('error received: ${data}');
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data),
            ),
          );
          isloading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                GetData(selectedEmployeId);
              },
              child: isLiveLoadind
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text('Live Tracking'),
            ),
            SizedBox(
              width: 50,
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.directions_run)),
            Text(
              Distance!,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              LogoutApi();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            icon: Icon(Icons.power_settings_new_outlined)),
        title: Row(
          children: [
            Text(
              'Login By:- ${widget.name}',
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w300),
            ),
            SizedBox(width: 120),
            Expanded(
              child: Text(
                ('${appBarTitle} Dashboard'),
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 10),
            buildDateAndCalendarButton(),
            IconButton(
              icon: Icon(Icons.map),
              onPressed: toggleMapView,
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          SingleChildScrollView(
            child: Container(
              width: 300,
              padding: EdgeInsets.all(8.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DrawerItem(
                    onEmailSelected: (email, name, employeeId) {
                      selectedEmployeId = employeeId;
                      setState(() {
                        fetchData(email);
                        print(' this is ${email}');
                        appBarTitle = (name);
                      });
                    },
                    employeeName: widget.name,
                    employeeId: widget.employeeId,
                    segment: widget.segment,
                    Role: widget.Role,
                    isLoading: isLoadingData,
                    email: widget.email,
                    password: widget.password,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(20.5937, 78.9629),
                zoom: 5,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: Set<Marker>.of(markers),
              polylines: Set<Polyline>.of(polylines),
              mapType: isSatelliteView ? MapType.satellite : MapType.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDateAndCalendarButton() {
    return Row(
      children: [
        SizedBox(width: 200),
        Text(
          'From: ${DateFormat('dd-MM-yyyy').format(selectedDateRange!.start)}',
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w300),
        ),
        SizedBox(width: 10),
        Text(
          'To: ${DateFormat('dd-MM-yyyy').format(selectedDateRange!.end)}',
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w300),
        ),
        SizedBox(width: 10),
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () {
            ShowDatePicker(context);
          },
        ),
      ],
    );
  }

  Future<void> ShowDatePicker(BuildContext context) async {
    final DateTime lastAllowedDate = DateTime.now();
    DateTime startDate = selectedDateRange!.start;
    DateTime endDate = selectedDateRange!.end;

    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: lastAllowedDate,
    );

    if (pickedStartDate != null) {
      final DateTime? pickedEndDate = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: pickedStartDate,
        lastDate: lastAllowedDate,
      );

      if (pickedEndDate != null) {
        setState(() {
          startDate = pickedStartDate;
          endDate = pickedEndDate;
          selectedDateRange = DateRange(startDate, endDate);
          parseXmlDataForSelectedRange(startDate, endDate);
        });
      }
    }
  }

  void parseXmlDataForSelectedRange(DateTime startDate, DateTime endDate) {
    List<Marker> filteredMarkers = [];
    for (var marker in markers) {
      final info = marker.infoWindow;
      final snippet = info.snippet!;
      print('Snippet: $snippet');
      final dateStr =
          marker.infoWindow.title!.replaceAll(' ', '').split(':')[1];
      print('Date String: $dateStr');
      final dateTime =
          DateFormat("dd-MM-yyyy").parse(dateStr.replaceAll('/', '-'));
      print('Date Time: $dateTime, Start Date: $startDate, End Date: $endDate');
      if (dateTime != null &&
          dateTime.isAfter(startDate.subtract(Duration(days: 1))) &&
          dateTime.isBefore(endDate.add(Duration(days: 1)))) {
        filteredMarkers.add(marker);
      }
    }

    debugPrint('Filtered Markers: ${filteredMarkers}');
    filteredMarkers.forEach((marker) {});
    setState(() {
      markers.clear();
      markers.addAll(filteredMarkers);
    });
  }
}
