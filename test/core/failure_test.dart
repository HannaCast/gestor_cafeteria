import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/core/failure.dart';

void main() {
  group('NetworkFailure', () {
    test('tiene el mensaje por defecto', () {
      const failure = NetworkFailure();

      expect(failure.message, 'No se pudo conectar al servidor');
    });

    test('es un Failure y un Exception', () {
      const failure = NetworkFailure();

      expect(failure, isA<Failure>());
      expect(failure, isA<Exception>());
    });
  });

  group('ServerFailure', () {
    test('guarda el statusCode y tiene el mensaje por defecto', () {
      const failure = ServerFailure(503);

      expect(failure.statusCode, 503);
      expect(failure.message, 'Error del servidor');
    });

    test('es un Failure', () {
      expect(const ServerFailure(500), isA<Failure>());
    });
  });

  group('NotFoundFailure', () {
    test('guarda el mensaje recibido', () {
      const failure = NotFoundFailure('Producto no encontrado');

      expect(failure.message, 'Producto no encontrado');
      expect(failure, isA<Failure>());
    });
  });

  group('ConflictFailure', () {
    test('guarda el mensaje recibido', () {
      const failure = ConflictFailure('El producto ya existe');

      expect(failure.message, 'El producto ya existe');
      expect(failure, isA<Failure>());
    });
  });

  group('ValidationFailure', () {
    test('guarda los campos y tiene el mensaje por defecto', () {
      const fields = {'nombre': 'Es obligatorio', 'precio': 'Debe ser mayor a 0'};
      const failure = ValidationFailure(fields);

      expect(failure.message, 'Error de validacion');
      expect(failure.fields, fields);
      expect(failure.fields['nombre'], 'Es obligatorio');
    });

    test('acepta un mapa de campos vacío', () {
      const failure = ValidationFailure({});

      expect(failure.fields, isEmpty);
      expect(failure, isA<Failure>());
    });
  });

  group('UnexpectedFailure', () {
    test('guarda el statusCode y el mensaje recibidos', () {
      const failure = UnexpectedFailure(418, 'Algo salió mal');

      expect(failure.statusCode, 418);
      expect(failure.message, 'Algo salió mal');
      expect(failure, isA<Failure>());
    });
  });

  group('Failure (clase sellada)', () {
    String describir(Failure failure) => switch (failure) {
          NetworkFailure() => 'red',
          ServerFailure(:final statusCode) => 'servidor $statusCode',
          NotFoundFailure() => 'no encontrado',
          ConflictFailure() => 'conflicto',
          ValidationFailure(:final fields) => 'validacion ${fields.length}',
          UnexpectedFailure(:final statusCode) => 'inesperado $statusCode',
        };

    test('el switch exhaustivo cubre todos los subtipos', () {
      expect(describir(const NetworkFailure()), 'red');
      expect(describir(const ServerFailure(500)), 'servidor 500');
      expect(describir(const NotFoundFailure('x')), 'no encontrado');
      expect(describir(const ConflictFailure('x')), 'conflicto');
      expect(describir(const ValidationFailure({'a': 'b'})), 'validacion 1');
      expect(describir(const UnexpectedFailure(999, 'x')), 'inesperado 999');
    });

    test('se puede lanzar y capturar como Exception', () {
      expect(
        () => throw const NotFoundFailure('No existe'),
        throwsA(
          isA<NotFoundFailure>().having((f) => f.message, 'message', 'No existe'),
        ),
      );
    });
  });
}
