import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class PrecioCalculator {
  static const double densidadOro18k = 15.6;
  static const double densidadOro24k = 19.32;
  static const double densidadPlata950 = 10.1;

  static Future<double> calculatePrice(double volumenCm3, TipoMetal metal) async {
    final densidad = metal == TipoMetal.oro18k ? densidadOro18k : densidadOro24k;
    final pesoGramos = volumenCm3 * densidad;
    final dio = Dio();
    final response = await dio.get(
      'https://api.alltick.co/quote?symbol=${metal == TipoMetal.oro18k ? 'XAU' : 'XAG'}-EUR&api_token=${dotenv.env['ALLTICK_API_KEY']}',
    );
    final precioEURPorGramo = double.parse(response.data['price'].toString()) / 31.1035;
    return pesoGramos * precioEURPorGramo;
  }
}

enum TipoMetal { oro18k, oro24k, plata950 }
