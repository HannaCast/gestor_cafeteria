//cliente que se va conectar a nuestro backend
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'failure.dart';

class ApiClient {
    //cliente
   final http.Client _client;
    //url base
   final Uri baseUrl;
   //control de tiempo de conexion
   final Duration timeout;
   //clase client
    ApiClient({
        http.Client? client,
        String? baseUrl,
        this.timeout = const Duration(seconds: 10)
    }): _client = client ?? http.Client(), baseUrl = Uri.parse(baseUrl ?? const String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:800'));

    //como voy a tratar a los post, get, patch, delete
    Future<dynamic> get(String path) => _send('GET', path);
    Future<dynamic> post(String path, Object body) => _send('POST', path, body);
    Future <dynamic> patch(String path, Object body) => _send('PATCH', path, body);
    Future <dynamic> delete(String path) => _send('DELETE', path);

    //funcion SEND -> Mandar la peticion al servicio, esperar una respuesta y adecuadarla para flutter

    Future<dynamic> _send(String method, String path, [Object? body]) async {
        //request: va a armar la peticion con la inyeccion de los headers
        final request = http.Request(method, baseUrl.resolve(path))..headers['Content-Type'] = 
        'application/json';

    if(body != null) request.body = json.encode(body);

    //variable para guardar la respuesta del servicio 
    final http.Response response;
    //el response se va a tratar segun el caso con el servicio respondio
    try{
        response = await _client.send(request).then(http.Response.fromStream).timeout
        (timeout);
    } on http.ClientException{
        throw const NetworkFailure();
    } on TimeoutException{
        throw const NetworkFailure();
    }

    final decoded = _tryDecode(response);
    final code = response.statusCode;

    if(code >= 200 && code < 300) return decoded;
    throw _failurePara(code, decoded);
    
    }

    Failure _failurePara(int code, dynamic decoded) {
        final detail = _detalle(decoded);
        switch (code) {
            case 404:
                return NotFoundFailure(_mensaje(detail));
            case 409:
                return ConflictFailure(_mensaje(detail));
            case 422:
                return ValidationFailure(_campos(detail));
            case >= 500 && <= 599:
                return ServerFailure(code);
            default:
                return UnexpectedFailure(code, _mensaje(detail));
        }
    }

    dynamic _detalle(dynamic decoded) {
        if (decoded is Map && decoded['detail'] != null) return decoded['detail'];
        return null;
    }

    String _mensaje(dynamic detail) {
        if (detail is String && detail.isNotEmpty) return detail;
        return 'Error inesperado';
    }

    Map<String, String> _campos(dynamic detail) {
        final fields = <String, String>{};
        if (detail is! List) return fields;
        for (final item in detail) {
            if (item is! Map) continue;
            final loc = item['loc'];
            final msg = item['msg'];
            if (loc is! List || loc.length < 2 || msg is! String) continue;
            final clave = loc[1];
            if (clave is String) fields[clave] = msg;
        }
        return fields;
    }


    
dynamic _tryDecode(http.Response response){
    if(response.bodyBytes.isEmpty) return null;

    try{
        return json.decode(utf8.decode(response.bodyBytes));
    } on FormatException{
        return null;
    }
}
}
