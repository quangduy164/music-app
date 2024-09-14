import 'package:meta/meta.dart';

@immutable
class RegisterState{
  final bool isValidEmail;
  final bool isValidPassword;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isValidEmailAndPassword => isValidEmail && isValidPassword;

  //Contructor
  RegisterState(
      {required this.isValidEmail,
        required this.isValidPassword,
        required this.isSubmitting,
        required this.isSuccess,
        required this.isFailure
      });
  //Với mỗi đối tượng có thể tạo ra bởi phương thức static hoặc factory
  factory RegisterState.initial(){
    return RegisterState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }
  //Trạng thái loading
  factory RegisterState.loading(){
    return RegisterState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false);
  }
  factory RegisterState.success(){
    return RegisterState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false);
  }
  factory RegisterState.failure(){
    return RegisterState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true);
  }
  //Nhân bản trạng thái
  RegisterState cloneWith({
    bool? isValidEmail,
    bool? isValidPassword,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure}){
    return RegisterState(
        isValidEmail: isValidEmail ?? this.isValidEmail,//Nếu isValidEmail đưa vào ==null thì lấy giá trị cũ
        isValidPassword: isValidPassword ?? this.isValidPassword,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure);
  }
  //Nhân bản đối tượng và cập nhật đối tượng
  RegisterState cloneAndUpdate({
    bool? isValidEmail,
    bool? isValidPassword
  }){
    return cloneWith(
        isValidEmail: isValidEmail,
        isValidPassword: isValidPassword
    );
  }

}