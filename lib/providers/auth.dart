import 'package:breakfastApp/apis/apisModel.dart';
import 'package:dio/dio.dart';
import '../models/user.dart';
import '../models/library.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _tokenType;
  Timer _authTimer;
  Map<String, dynamic> _userInformation = {
    'id': null,
    'name': '',
    'email': '',
    'gender': '',
    'phone': '',
    'date_of_birth': '',
    'address': '',
  };
  Map<String, dynamic> get userInformation {
    return _userInformation;
  }

  bool get isAuth {
    return token != null;
  }

  String get gender {
    return userInformation['gender'];
  }

  String get token {
    // if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {  //open comment if ther token rxpire date
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String get tokenType {
    return _tokenType;
  }

  String get userId {
    return _userInformation['id'].toString();
  }

  var dio = Dio();
  // Future<void> register(User newUser) async {
  //   final url = 'https://doctor-tawasol.com/api/register';
  //   Map<String, String> newUserData = prepareUserData(newUser);
  //   try {
  //     Response response = await postNewUser(url, newUserData);
  //     _authenticate(response);
  //   } on DioError catch (e) {
  //     handleResponseError(e);
  //   } catch (error) {
  //     print('reg error');
  //     throw error;
  //   }
  // }

  Map<String, String> prepareUserData(User newUser) {
    var newUserData = {
      'name': newUser.name,
      'email': newUser.email,
      'password': newUser.password,
      'password_confirmation': newUser.password_confirmation,
      'phone': newUser.phone,
      'gender': newUser.gender,
      'date_of_birth': newUser.date_of_birth,
      'address': newUser.address,
      'country_id': newUser.country_id.toString()
    };
    return newUserData;
  }

  Future<Response> postNewUser(
      String url, Map<String, String> newUserData) async {
    final response = await dio.post(url, data: newUserData);
    return response;
  }

  void handleResponseError(DioError e) {
    if (e.response != null) {
      print(e.error);
      print(e.response.statusCode);
      throw DioError(response: e.response);
    } else {
      print(e.request);
      print(e.message);
    }
  }

  Future<Response> login(String email, String password) async {
    print (' login');
    final url = Apis.login;
    Response response = await postUserDataToLogin(url, email, password);
print ('res login $response');
    try {
      _authenticate(response);
    } on DioError catch (e) {
      handleResponseError(e);
    } catch (error) {
      print('login response error');
      throw error;
    }
    return response;
  }

  Future<Response> postUserDataToLogin(
      String url, String email, String password) async {
            print (' postUserDataToLogin $email $password');

    final response =
        await dio.post(url, data: {'email': email, 'password': password});
    print('res postUserDataToLoginfun ${response}');
    return response;
  }

  Future _authenticate(resData) async {
    getUserData(resData);
    // _autoLogout();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    storeUserToken(prefs);
    storeUserInformation(prefs);
  }

  void storeUserInformation(SharedPreferences prefs) {
    final userData = json.encode({
      'id': _userInformation['id'],
      'name': _userInformation['name'],
      'email': _userInformation['email'],
      'gender': _userInformation['gender'],
      // 'phone': _userInformation['phone'],
      // 'date_of_birth': _userInformation['date_of_birth'],
      // 'address': _userInformation['address']
    });
    prefs.setString('userData', userData);
    //todo remove print
    print('userData');
    print(prefs.getString('userData'));
  }

  void storeUserToken(SharedPreferences prefs) {
    final userTokenInfo = json.encode({
      'token': _token,
      'token_type': _tokenType,
      // 'expiryDate': _expiryDate.toIso8601String(),
    });
    prefs.setString('userTokenInfo', userTokenInfo);
    print('userTokenInfo');
    print(prefs.getString('userTokenInfo'));
  }

  void getUserData(resData) {
    var userDataResponse = resData.data;
    print('getUserData$userDataResponse');
    getUserToken(userDataResponse);
    getUserInformation(userDataResponse);
  }

  void getUserToken(userDataResponse) {
    _token = userDataResponse['Access Token'];
    _tokenType = 'Bearer';
    // _expiryDate = DateTime.now().add(
    //   Duration(
    //     seconds: userDataResponse['expires_in'],
    //   ),
    // );
  }

  void getUserInformation(userDataResponse) {
    var data = userDataResponse['User'];
    _userInformation['id'] = data['id'];
    _userInformation['name'] = data['name'];
    _userInformation['email'] = data['email'];
    _userInformation['gender'] = data['flag'];
    // _userInformation['phone'] = data['phone'];
    // _userInformation['date_of_birth'] = data['date_of_birth'];
    // _userInformation['address'] = data['address'];
  }

  Future<void> logout() async {
    resetUserToken();
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    await clearPrefereceData();
  }

  Future clearPrefereceData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void resetUserToken() {
    _token = null;
    _userInformation['id'] = null;
    _expiryDate = null;
    print('_token$_token');
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
      clearPrefereceData();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userTokenInfo')) {
      print('prefs empty');
      return false;
    }
    final extractedUserTokenInfo =
        json.decode(prefs.getString('userTokenInfo')) as Map<String, Object>;

    final extractUserInfo =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    print('extractUserInfo$extractUserInfo');
    print('extractedUserData$extractedUserTokenInfo');
    // final expiryDate = DateTime.parse(extractedUserTokenInfo['expiryDate']);
    // print('expiryDate$expiryDate');
    // if (expiryDate.isBefore(DateTime.now())) {
    //   return false;
    // }
    // geAllDataUserToAutoLogin(
    //     extractedUserTokenInfo, expiryDate, extractUserInfo);
         geAllDataUserToAutoLogin(
        extractedUserTokenInfo, extractUserInfo);
    print('token auto login $token , is auth $isAuth tokenType $tokenType');

    notifyListeners();
    _autoLogout();
    return true;
  }

// do this if expiryDate is done

  // void geAllDataUserToAutoLogin(Map<String, Object> extractedUserTokenInfo,
  //     DateTime expiryDate, Map<String, Object> extractUserInfo) {
  //   _token = extractedUserTokenInfo['token'];
  //   _tokenType = extractedUserTokenInfo['token_type'];
  //   _expiryDate = expiryDate;

  //   _userInformation['id'] = extractUserInfo['id'];
  //   _userInformation['name'] = extractUserInfo['name'];
  //   _userInformation['email'] = extractUserInfo['email'];
  //   _userInformation['gender'] = extractUserInfo['gender'];
  //   _userInformation['phone'] = extractUserInfo['phone'];
  //   _userInformation['date_of_birth'] = extractUserInfo['date_of_birth'];
  //   _userInformation['address'] = extractUserInfo['address'];
  // }

  void geAllDataUserToAutoLogin(Map<String, Object> extractedUserTokenInfo,
      Map<String, Object> extractUserInfo) {
    _token = extractedUserTokenInfo['token'];
    _tokenType = 'Bearer';
    _userInformation['id'] = extractUserInfo['id'];
    _userInformation['name'] = extractUserInfo['name'];
    _userInformation['email'] = extractUserInfo['email'];
    _userInformation['gender'] = extractUserInfo['gender'];
  
  }
}
