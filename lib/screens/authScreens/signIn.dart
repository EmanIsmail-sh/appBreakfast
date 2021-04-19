import 'package:dio/dio.dart';
import '../../models/library.dart';
import '../../models/errorDialog.dart';
import '../../models/toastMessage.dart';
import '../../providers/auth.dart';
import '../../widgets/buttonWidget.dart';
import '../../widgets/textFormFieldWidget.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _signInform = GlobalKey<FormState>();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  Future<void> _submitLogin() async {
    try {
      print(_authData['email']);
      print(_authData['password']);
      if (!_signInform.currentState.validate()) {
        return;
      }
      _saveForm();
      _showLoading();
      await _sendUserDataToLogin();
    } on DioError catch (error) {
      print(error);
      _handleError(error);
    } catch (error) {
      print('login error');
      throw error;
    }
    _hideLoading();
  }

  void _saveForm() {
    final FormState userform = _signInform.currentState;
    userform.save();
  }

  void _handleError(DioError error) {
    var errorMessage = 'حدث خطأ ما';
    if (error.response.statusCode == 401) {
      errorMessage = 'خطأ في الايميل او كلمه السر';
    }
    errorMessage = 'حدث خطأ ما';
    ErrorDialog.showErrorDialog(errorMessage, context);
  }

  Future _sendUserDataToLogin() async {
     print('_sendUserDataToLogin');
    final res = await Provider.of<Auth>(context, listen: false)
        .login(_authData['email'], _authData['password']);
        print('res $res');
    if (res.statusCode == 200) {
      print('succ ${res.statusCode}');
      actionAfterLoginSuccessflly();
    }
   print('res $res');
  }

  void actionAfterLoginSuccessflly() {
    ToastMessage.showToast('تم تسجيل الدخول بنجاح');
    // Navigator.of(context).pushReplacementNamed(ConsultingListScreen.routeName);
  }

  void _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  void _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var pageTitle = Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                'فطرني',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.bodyText1.fontFamily,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: [
            // pageTitle,
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 70),
            //   child: Image(image: AssetImage('assets/taco.png'),
            //   height: 250,
            //   alignment: Alignment.bottomCenter,
            //   fit: BoxFit.cover,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 211),
              child: Container(
                height: size.height - 211,
          
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                

                  ),
                  color: Colors.white,
                ),
              ),
            ),
            ListView(
              children: [ 
                // pageTitle,
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 90),
              child: Image(image: AssetImage('assets/taco.png',),
              height: 250,
              alignment: Alignment.bottomCenter,
              fit: BoxFit.cover,
              
              ),
            ),
            pageTitle,
                Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30, top: 50),
                  child: Form(
                    key: _signInform,
                    // autovalidateMode:AutovalidateMode.always ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildEmail(),
                        SizedBox(
                          height: 20.0,
                        ),
                        buildPassword(),
                        SizedBox(
                          height: 30.0,
                        ),
                        if (_isLoading)
                          CircularProgressIndicator()
                        else
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: buildLoginButton(),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ButtonWidget buildLoginButton() {
    return ButtonWidget(
      title: 'تسجيل الدخول',
      hasBorder: false,
      onTap: _submitLogin,
    );
  }

  TextFormFieldWidget buildPassword() {
    return TextFormFieldWidget(
      fieldlabelText: 'كلمه السر',
      prefixIconData: Icons.lock_open,
      obscureText: true,
      inputType: TextInputType.visiblePassword,
      onChangeField: (value) {
        _authData['password'] = value;
      },
      maxLine: 1,
      validate: (value) {
        if (value.isEmpty) {
          return 'هذا الحقل الزامي';
        }
        return null;
      },
    );
  }

  TextFormFieldWidget buildEmail() {
    return TextFormFieldWidget(
      fieldlabelText: 'البريد الالكتروني',
      prefixIconData: Icons.mail,
      inputType: TextInputType.emailAddress,
      onChangeField: (value) {
        _authData['email'] = value;
      },
      validate: (value) {
        if (value.isEmpty || !value.contains('@')) {
          return 'غير صحيح!';
        }
        return null;
      },
    );
  }
}
