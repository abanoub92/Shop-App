
/*
 * 'implements' give us the functions of 
 * class to refactor it and used in our 
 * custom class. 
 */
class HttpException implements Exception {

  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}