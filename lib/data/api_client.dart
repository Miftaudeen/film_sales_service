import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:f_logs/f_logs.dart';
import 'package:film_sales_service/models/login_data.dart';
import 'package:film_sales_service/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';

enum AuthState { unauthenticated, authenticated, failure }

class ApiClient {
  static final ApiClient _client = ApiClient._internal();
  final baseUrl = "https://film-service-backend.herokuapp.com";
  String _userName;
  static String userToken;
  factory ApiClient() => _client;

  final Dio _http;

  ApiClient._internal()
      : _http = Dio(BaseOptions(
          connectTimeout: 15000,
          receiveTimeout: 15000,
        )) {
    // Set up request interceptor so we can fetch API requests
    // from the cache, if present.
    // This should improve the offline experience significantly.
    _http.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions opts) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final url = "${opts.baseUrl}${opts.path}";
      if (url.startsWith(baseUrl) && opts.method == "GET") {
        final cacheManager = DefaultCacheManager(); //.getInstance();
        final file = await cacheManager.getSingleFile(url,
            headers: opts.headers.cast<String, String>());
        if (file != null) {
          final data = await file.readAsString();
          final json = jsonDecode(data);
          return _http.resolve(json);
        } else {
          return _http.reject(DioError(
            error: "Could not complete request.",
            type: DioErrorType.RESPONSE,
          ));
        }
      }
      return opts;
    }));
  }

  Future<SharedPreferences> _sharedPrefs = SharedPreferences.getInstance();

  Future<bool> get isLoggedIn async {
    if (userToken == null) {
      final prefs = await _sharedPrefs;
      userToken = prefs.getString(UserTokenKey);
    }
    return userToken != null;
  }

  Future<AuthState> login(LoginData data) async {
    final preferences = await _sharedPrefs;
    try {
      final data = await _http
          .post("$baseUrl/api/auth/token/",
              data: FormData.fromMap({
                "username": data.username,
                "password": data.password,
              }))
          .then((res) {
        print(res.statusCode);
        return res.data;
      });
      final token = data["token"];
      final userId = data["user_id"];
      if (token == null || token.isEmpty) {
        return AuthState.failure;
      }
      _userName = data.username;

      await preferences.setString(UserTokenKey, token);
      await preferences.setString(UserIdKey, userId);
      return AuthState.authenticated;
    } on DioError catch (e) {
      if (e?.response?.statusCode == 302) {
        launch(e?.response?.redirects?.first?.location?.path);
      }
      FLog.error(
          className: "ApiClient", text: "Error=${e?.error?.toString() ?? e}");
    }
  }

  logout() async {
    final preferences = await _sharedPrefs;
    _userName = null;
    userToken = null;
    await preferences.clear();
    final cacheManager = DefaultCacheManager();
    await cacheManager.emptyCache();
  }

  Future<User> getProfile() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    final userId = preferences.getInt(UserIdKey);
    return await _http
        .get("$baseUrl/api/users/${userId}/", options: options)
        .then((res) => User.fromJson(res.data))
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<List<Payslip>> getPayslips() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/payslips/", options: options)
        .then((res) {
      print(res);
      return res.data.map<Payslip>((item) {
        print(item);
        return Payslip.fromJson(item);
      }).toList();
    }).catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }

    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary

    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> _requestPermissions() async {
    var permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }

    return permission == PermissionStatus.granted;
  }

  downloadPayslip(String url) async {
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    Directory directory = await _getDownloadDirectory();
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      headers: {"Authorization": "Token $userToken"},
      savedDir: directory.path,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
    if (await _requestPermissions()) {
      FlutterDownloader.open(taskId: taskId);
    }
  }

  Future<List<Loan>> getLoans() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/loans/", options: options)
        .then(
            (res) => res.data.map<Loan>((item) => Loan.fromJson(item)).toList())
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<List<MedicalClaim>> getMedicalClaims() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/medical/claims/", options: options)
        .then((res) => res.data
            .map<MedicalClaim>((item) => MedicalClaim.fromJson(item))
            .toList())
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<List<Leave>> getLeaves() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/leaves/", options: options)
        .then((res) =>
            res.data.map<Leave>((item) => Leave.fromJson(item)).toList())
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<List<Claim>> getClaims() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/claims/", options: options)
        .then((res) =>
            res.data.map<Claim>((item) => Claim.fromJson(item)).toList())
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<List<Overtime>> getOvertimes() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    print(baseUrl);
    return await _http
        .get("$baseUrl/api/overtimes/", options: options)
        .then((res) {
      print(res.data);
      return res.data.map<Overtime>((item) => Overtime.fromJson(item)).toList();
    }).catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<List<SalaryAdvance>> getSalaryAdvances() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/salary/advances/", options: options)
        .then((res) => res.data
            .map<SalaryAdvance>((item) => SalaryAdvance.fromJson(item))
            .toList())
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<List<LeavePlan>> getLeavePlans() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/leave/plans/", options: options)
        .then((res) => res.data
            .map<LeavePlan>((item) => LeavePlan.fromJson(item))
            .toList())
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<List<Employee>> getEmployees() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/employees/", options: options)
        .then((res) =>
            res.data.map<Employee>((item) => Employee.fromJson(item)).toList())
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<List<MedicalProvider>> getMedicalProviders() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/medical/providers/", options: options)
        .then((res) => res.data
            .map<MedicalProvider>((item) => MedicalProvider.fromJson(item))
            .toList())
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<List<Client>> getClients() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/clients/", options: options)
        .then((res) =>
            res.data.map<Client>((item) => Client.fromJson(item)).toList())
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<List<ClientSite>> getClientSites() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/client/sites/", options: options)
        .then((res) => res.data
            .map<ClientSite>((item) => ClientSite.fromJson(item))
            .toList())
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<List<LoanType>> getLoanTypes() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/loan/types/", options: options)
        .then((res) =>
            res.data.map<LoanType>((item) => LoanType.fromJson(item)).toList())
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<List<LeaveType>> getLeaveTypes() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/leave/types/", options: options)
        .then((res) => res.data
            .map<LeaveType>((item) => LeaveType.fromJson(item))
            .toList())
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<List<ClaimType>> getClaimTypes() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/claim/types/", options: options)
        .then((res) => res.data
            .map<ClaimType>((item) => ClaimType.fromJson(item))
            .toList())
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<LeavePlan> planLeave(LeavePlan leavePlan) async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .post("$baseUrl/api/leave/plans/",
            options: options, data: leavePlan.toMap())
        .then((res) => LeavePlan.fromJson(res.data))
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  takeLoan(Loan loan) async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    try {
      return await _http
          .post("$baseUrl/api/loans/", options: options, data: loan.toMap())
          .then((res) => Loan.fromJson(res.data));
    } on DioError catch (e) {
      return (e.response?.data ?? e.response?.statusMessage ?? e.error);
    } on Error catch (_) {
      return _.toString();
    }
  }

  Future<MedicalClaim> addMedicalClaim(MedicalClaim medicalClaim) async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .post("$baseUrl/api/medical/claims/",
            options: options, data: medicalClaim.toMap())
        .then((res) => MedicalClaim.fromJson(res.data))
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  addClaim(Claim claim) async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    try {
      return await _http
          .post("$baseUrl/api/claims/", options: options, data: claim.toMap())
          .then((res) => Claim.fromJson(res.data));
    } on DioError catch (e) {
      return (e.response?.data ?? e.response?.statusMessage ?? e.error);
    } on Error catch (_) {
      return _.toString();
    }
  }

  addOvertime(Overtime overtime) async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    try {
      return await _http
          .post("$baseUrl/api/overtimes/",
              options: options, data: overtime.toMap())
          .then((res) => Overtime.fromJson(res.data));
    } on DioError catch (e) {
      return (e.response?.data ?? e.response?.statusMessage ?? e.error);
    } on Error catch (_) {
      return _.toString();
    }
  }

  addSalaryAdvance(SalaryAdvance salaryAdvance) async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    try {
      return await _http
          .post("$baseUrl/api/salary/advances/",
              options: options, data: salaryAdvance.toMap())
          .then((res) => SalaryAdvance.fromJson(res.data));
    } on DioError catch (e) {
      return (e.response?.data ?? e.response?.statusMessage ?? e.error);
    } on Error catch (_) {
      print(_.toString());
      return _.toString();
    }
  }

  applyForLeave(Leave leave) async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    try {
      Leave result = await _http
          .post("$baseUrl/api/leaves/", options: options, data: leave.toMap())
          .then((res) => Leave.fromJson(res.data));
      return result;
    } on DioError catch (e) {
      return e.response.statusMessage;
    } on Error catch (_) {
      return _.toString();
    }
  }

  Future<List<LeavePolicy>> getLeavePolicies() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/leave/policies/", options: options)
        .then((res) => res.data
            .map<LeavePolicy>((item) => LeavePolicy.fromJson(item))
            .toList())
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }

  Future<List<Pension>> getPensions() async {
    final preferences = await _sharedPrefs;
    final options = Options(headers: {
      "Authorization": "Token $userToken",
      "Accept": "application/json",
    });
    String baseUrl = preferences.getString(BASE_URL) ?? defaultUrl;
    return await _http
        .get("$baseUrl/api/pensions/", options: options)
        .then((res) =>
            res.data.map<Pension>((item) => Pension.fromJson(item)).toList())
        .catchError((e) {
      debugPrint("Error=${e}");
    });
  }
}
