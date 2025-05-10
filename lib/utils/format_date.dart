//**
// Receive a date in format: dd/MM/yyyy
// And return a date in format: yyyy/MM/dd
// */
String formatDateToAPI(String date) {
  final splittedDate = date.split("/");
  final formattedDate =
      "${splittedDate[2]}-${splittedDate[1]}-${splittedDate[0]}";
  return formattedDate;
}
