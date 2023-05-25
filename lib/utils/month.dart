class Month{

  Month();

  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  String get currentMonth {
    return months[DateTime.now().month-1];
  }

}