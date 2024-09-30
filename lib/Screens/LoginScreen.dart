import 'package:employee_attendance_track/Screens/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Constant/Url.dart';
import '../Model/LoginModel.dart';
import '../Services/getData.dart';
import '../Theme/Colors.dart';
import 'package:uuid/uuid.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginModel loginModel = LoginModel();
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  bool isloading = false;
  bool _isPasswordVisible = false; // New boolean for password visibility

  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
  }

  void Refresh() {
    print("Refreshing...");
    setState(() {
      isloading = true;
    });
    SAPGetData(
      remarks: 'Remarks',
      result: 'Result',
      url:
          "https://${AppConstant.url}-plt-bi-farms-manager.cfapps.ap11.hana.ondemand.com/com.plt.bi.farms_manager/DF_EMPLOYEE_ROLESet?\$filter= EmployeeEmailID eq '${_email.replaceAll(' ', '').toLowerCase()}' and AppActivity eq 'LOGIN' and AppID eq 'PLT-BI-DETD' and UUID eq '1234' and DeviceModel eq '111' and OSVersion eq '11' and AppVersion eq '${AppConstant.prdVersion}'",
      userName: _email,
      password: _password,
      showSnackBar: true,
      context: context,
      onDataRecieved: (data) {
        loginModel = LoginModel.fromJson(data);
        debugPrint('data received api of login : ${data}');
        String? employeeName = loginModel.results!.first.employeeEmailID;
        String? employeeId = loginModel.results!.first.employeeID;
        String? segment = loginModel.results!.first.employeeSegmentText;
        String? name = loginModel.results!.first.employeeName;
        String? role = loginModel.results!.first.role;
        print(_email);
        print(_password);

        passEmployeeData(employeeId!, segment!, name!, role!, employeeName!);

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

  void LogoutApi() {
    print("LogOut Called");
    setState(() {
      isloading = true;
    });
    SAPGetData(
      remarks: 'Remarks',
      result: 'Result',
      url:
          "https://${AppConstant.url}-plt-bi-farms-manager.cfapps.ap11.hana.ondemand.com/com.plt.bi.farms_manager/DF_EMPLOYEE_ROLESet?\$filter= EmployeeEmailID eq '${_email.replaceAll(' ', '').toLowerCase()}' and AppActivity eq 'LOGOUT' and AppID eq 'PLT-BI-DETD' and UUID eq '1234' and DeviceModel eq '111' and OSVersion eq '11' and AppVersion eq '${AppConstant.prdVersion}'",
      userName: _email,
      password: _password,
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

  void passEmployeeData(String employeeId, String segment, String name,
      String role, String employeeName) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(
          employeeName: employeeName,
          employeeId: employeeId,
          segment: segment,
          name: name,
          Role: role,
          email: _email,
          password: _password,
        ),
      ),
    );
  }

  void saveUserCredentials(String email, String password) async {
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'password', value: password);
  }

  void logout() async {
    await storage.delete(key: 'email');
    await storage.delete(key: 'password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              LogoutApi();
            },
            icon: Icon(Icons.power_settings_new_outlined)),
        backgroundColor: Colors.white,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'Login Screen',
              style: GoogleFonts.sourceSans3(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Image.asset(
                    'assets/image/PoweredBy.png',
                    width: 70,
                    height: 70,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      padding: EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF074D81).withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.person,
                                color: SAPColors.primaryButtonColor,
                              ),
                              labelText: 'Email ID',
                            ),
                            style: GoogleFonts.sourceSans3(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              });
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            obscureText:
                                !_isPasswordVisible, // Toggle password visibility
                            decoration: InputDecoration(
                              icon: Icon(
                                Icons.lock,
                                color: SAPColors.primaryButtonColor,
                              ),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            style: GoogleFonts.sourceSans3(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: TextButton(
                onPressed: () {
                  if (!isloading && _formKey.currentState!.validate()) {
                    print("Form is valid, attempting login...");
                    Refresh();
                    saveUserCredentials(_email,
                        _password); // Save credentials on successful login
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey;
                      }
                      return SAPColors.primaryButtonColor;
                    },
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: SAPColors.primaryButtonColor,
                      ),
                    ),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Visibility(
                      visible: !isloading,
                      child: Text(
                        'Log In',
                        style: GoogleFonts.sourceSans3(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isloading,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
