import 'dart:convert';
import 'dart:developer';
import 'package:xml/xml.dart' as xml;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constant/Url.dart';
import '../Model/EmployeeSetModel.dart';
import 'package:http/http.dart' as http;

class DrawerItem extends StatefulWidget {
  final void Function(String, String, String) onEmailSelected;
  final String employeeName;
  final String employeeId;
  final String segment;
  final String Role;
  final String email;
  final String password;
  final bool isLoading;

  const DrawerItem({
    Key? key,
    required this.onEmailSelected,
    required this.employeeId,
    required this.employeeName,
    required this.segment,
    required this.Role,
    required this.email,
    required this.password,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  EmployeeSetModel employeeSetModel = EmployeeSetModel();
  List<Results> _employees = [];
  List<Results> _filteredEmployees = [];
  bool _isSearching = false;
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData(
      widget.segment,
      widget.employeeId,
      widget.Role,
    );
    _searchController.addListener(() {
      setState(() {
        if (_searchController.text.isEmpty) {
          _isSearching = false;
          _filteredEmployees = [];
          return;
        }
        _isSearching = true;
        _filteredEmployees = _employees
            .where((employee) =>
                employee.employeeID!.contains(_searchController.text))
            .toList();
      });
    });
  }

  void _toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> getData(
    String selectedItem,
    String employeeId,
    String Role,
  ) async {
    _toggleLoading(true);
    String username = widget.email;
    String password = widget.password;
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));

    final response = await http.get(
      Uri.parse(
        "https://${AppConstant.url}-plt-bi-farms-manager.cfapps.ap11.hana.ondemand.com/attendance_service/ZEMPLOYEE_SEGMENTSet?\$filter=EmployeeSegment eq '${widget.segment}'and EmployeeID eq '${widget.employeeId}' and EmployeeRole eq '${widget.Role}'",
      ),
      headers: <String, String>{'authorization': basicAuth},
    );
    if (response.statusCode == 200) {
      final data = xml.XmlDocument.parse(response.body);
      _parseXmlData(data, isEmployeeData: true);
    } else {
      throw Exception('Failed to load data ${response.body}');
    }
    _toggleLoading(false);
  }

  void _parseXmlData(xml.XmlDocument data, {bool isEmployeeData = false}) {
    if (isEmployeeData) {
      List<Results> employees = [];

      data.findAllElements('entry').forEach((entry) {
        var properties = entry
            .findElements('content')
            .single
            .findElements('m:properties')
            .single;

        Results employee = Results(
          employeeID: properties.findElements('d:EmployeeID').single.text,
          employeeName: properties.findElements('d:EmployeeName').single.text,
          employeeRole: properties.findElements('d:EmployeeRole').single.text,
          employeeLocation:
              properties.findElements('d:EmployeeLocation').single.text,
          employeeSegment:
              properties.findElements('d:EmployeeSegment').single.text,
          employeeEmail: properties.findElements('d:EmployeeEmail').single.text,
          latitude: properties.findElements('d:latitude').single.text,
          longitude: properties.findElements('d:longitude').single.text,
          emplatitude: properties.findElements('d:emplatitude').single.text,
          emplongitude: properties.findElements('d:emplongitude').single.text,
        );

        employees.add(employee);
      });

      setState(() {
        _employees = employees;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search by Employee ID',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: [
              SizedBox(height: 10),
            ],
          ),
          if (_isSearching)
            ..._filteredEmployees.map((employee) {
              return ListTile(
                title: Text('Employee Name : ${employee.employeeName}'
                    // 'Employee ID: ${employee.employeeID}',
                    ),
                // subtitle: Text('Employee Name : ${employee.employeeName}'),
                onTap: () {
                  if (employee.employeeEmail != null) {
                    widget.onEmailSelected(employee.employeeEmail!,
                        employee.employeeName!, employee.employeeID!);
                    print('${employee.employeeEmail}');
                    print('${employee.employeeName}');
                    print('heeloooo this is called -> ${employee.employeeID}');
                  }
                },
              );
            }).toList(),
          if (_employees.isNotEmpty && !_isSearching)
            ExpansionTile(
              title: Text(
                'List Of Employees',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              children: _employees.map<Widget>((employee) {
                return SingleChildScrollView(
                  child: ExpansionTile(
                    title: Text('${employee.employeeName}'
                        // 'Employee Id: ${employee.employeeID}',
                        ),
                    children: [
                      if (widget.isLoading) CircularProgressIndicator(),
                      ListTile(
                        title: Text(
                          'Email: ${employee.employeeEmail}',
                        ),
                        onTap: () {
                          if (employee.employeeEmail != null) {
                            widget.onEmailSelected(employee.employeeEmail!,
                                employee.employeeName!, employee.employeeID!);
                            print('${employee.employeeEmail}');
                            print(
                                'Second time called -> ${employee.employeeID}');
                          }
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Name: ${employee.employeeName}',
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Role: ${employee.employeeRole}',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
