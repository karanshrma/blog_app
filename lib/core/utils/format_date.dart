import 'package:intl/intl.dart';

String formatDateByddMMMYYYY(DateTime dateTime){
  return DateFormat("d MMM , yyyy").format(dateTime);

}