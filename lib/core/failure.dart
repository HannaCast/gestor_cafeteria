//1. Conexion
//2. error servidor
//3. respuestas

//clase sellada para gestionar los estados de fallo

//clase principal -> sellada -> va a saber quienes son todos sus hijos
sealed class Failure implements Exception{
    const Failure(this.message);
    final String message;
}

//1. sin conexion, DNS, timeouts
final class NetworkFailure extends Failure{
    const NetworkFailure() : super("No se pudo conectar al servidor");
}

//2. 5xx servidor no responde
final class ServerFailure extends Failure{
    const ServerFailure(this.statusCode) : super("Error del servidor");
    final int statusCode;
}

//3. 404
final class NotFoundFailure extends Failure{
    const NotFoundFailure(super.message);
}

//4. 409
final class ConflictFailure extends Failure{
    const ConflictFailure(super.message);
}

//5. 422 
final class ValidationFailure extends Failure{
    const ValidationFailure(this.fields) : super("Error de validacion");
    final Map<String,String> fields;
}

//error desconocido
final class  UnexpectedFailure extends Failure{
    const UnexpectedFailure(this.statusCode,super.message);
    final int statusCode;
}