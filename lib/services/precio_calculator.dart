import 'package:dio/dio.dart';
import 'package:jewelcraft_ai/core/api_keys.dart';
import 'package:jewelcraft_ai/models/tipo_metal.dart';

class PrecioCalculator {
  static Future<double> calculatePrice(double volumenCm3, TipoMetal metal) async {
    final densidad = switch (metal) {
      TipoMetal.oro18k   => 15.6,
      TipoMetal.oro16k   => 14.9,
      TipoMetal.oro14k   => 14.0,
      TipoMetal.oro10k   => 11.6,
      TipoMetal.oro8k    => 10.4,
      TipoMetal.plata975 => 10.2,
      TipoMetal.plata950 => 10.1,
      TipoMetal.plata    => 10.0,
    };

    final pesoGramos = volumenCm3 * densidad;

    final symbol = switch (metal) {
      TipoMetal.oro18k ||
      TipoMetal.oro16k ||
      TipoMetal.oro14k ||
      TipoMetal.oro10k ||
      TipoMetal.oro8k   => 'XAU',
      TipoMetal.plata975 ||
      TipoMetal.plata950 ||
      TipoMetal.plata    => 'XAG',
    };

    final dio = Dio();
    final response = await dio.get(
      'https://api.alltick.co/quote?symbol=$symbol-EUR&api_token=${await ApiKeys.alltick}',
    );

    final precioEURPorGramo = double.parse(response.data['price'].toString()) / 31.1035;
    return pesoGramos * precioEURPorGramo;
  }
}
