String capitalize(String s){
  String a = s.substring(0,1).toUpperCase();
  String b = s.substring(1, s.length).toLowerCase();

  return a+b;


}