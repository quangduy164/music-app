class Validators{
  static isValidEmail(String email){
    final regularExpression =  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return regularExpression.hasMatch(email);
  }
  static isValidPassword(String password){
    return password.length >= 5;
  }
}