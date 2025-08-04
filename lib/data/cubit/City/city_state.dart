import '../../../model/SelectCityModel.dart';


abstract class SelectCity {}

class SelectCityInitially extends SelectCity {}

class SelectCityLoading extends SelectCity {}

class SelectCityLoaded extends SelectCity {
  SelectCityModel selectCityModel;
  SelectCityLoaded(this.selectCityModel);
}

class SelectCityFailure extends SelectCity {
  String error;
  SelectCityFailure(this.error);
}
