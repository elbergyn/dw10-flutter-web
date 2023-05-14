import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../models/payment_type_model.dart';
import '../../repositories/payment_type/payment_type_repository.dart';
part 'payment_type_controller.g.dart';

enum PaymentTypeStateStatus {
  initial,
  loading,
  loaded,
  error,
  addOrUpdatePayment,
  saved,
}

class PaymentTypeController = PaymentTypeControllerBase
    with _$PaymentTypeController;

abstract class PaymentTypeControllerBase with Store {
  final PaymentTypeRepository _paymentTypeRepository;

  @readonly
  var _status = PaymentTypeStateStatus.initial;

  @readonly
  var _paymentTypes = <PaymentTypeModel>[];

  @readonly
  String? _errorMessage;

  @readonly
  bool? _filterEnabled;

  PaymentTypeModel? paymentTypeSelected;

  PaymentTypeControllerBase(this._paymentTypeRepository);

  @action
  void changeFilter(bool? enabled) => _filterEnabled = enabled;

  @action
  Future<void> loadPayment() async {
    try {
      _status = PaymentTypeStateStatus.loaded;
      _paymentTypes = await _paymentTypeRepository.findAll(_filterEnabled);
      _status = PaymentTypeStateStatus.loaded;
    } on Exception catch (e, s) {
      log('Erro ao carregar as formas de pagamento', error: e, stackTrace: s);
      _status = PaymentTypeStateStatus.error;
      _errorMessage = 'Erro ao carregar as formas de pagamento';
    }
  }

  @action
  Future<void> addPayment() async {
    _status = PaymentTypeStateStatus.loaded;
    await Future.delayed(const Duration(seconds: 0));
    paymentTypeSelected = null;
    _status = PaymentTypeStateStatus.addOrUpdatePayment;
  }

  @action
  Future<void> editPayment(PaymentTypeModel payment) async {
    _status = PaymentTypeStateStatus.loaded;
    await Future.delayed(const Duration(seconds: 0));
    paymentTypeSelected = payment;
    _status = PaymentTypeStateStatus.addOrUpdatePayment;
  }

  @action
  Future<void> savePayment({
    int? id,
    required String name,
    required String acronym,
    required bool enabled,
  }) async {
    try {
      _status = PaymentTypeStateStatus.loading;
      final paymentTypeModel = PaymentTypeModel(
        id: id,
        name: name,
        acronym: acronym,
        enabled: enabled,
      );

      await _paymentTypeRepository.save(paymentTypeModel);
      _status = PaymentTypeStateStatus.saved;
    } on Exception catch (e, s) {
      log(
        'Erro ao salvar os dados do tipo de pagmaento',
        error: e,
        stackTrace: s,
      );
      _errorMessage = 'Erro ao salvar os dados do tipo de pagmaento';
      _status = PaymentTypeStateStatus.error;
    }
  }
}
