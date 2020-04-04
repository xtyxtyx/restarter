void main() async {
  var number = 0;
  while (true) {
    number++;
    print(number);
    await Future.delayed(Duration(seconds: 1));
  }
}
