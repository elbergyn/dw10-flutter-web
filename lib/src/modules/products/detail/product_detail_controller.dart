import 'dart:developer';
import 'dart:typed_data';

import 'package:mobx/mobx.dart';

import '../../../models/product_model.dart';
import '../../../repositories/products/product_repository.dart';

part 'product_detail_controller.g.dart';

enum ProductDetailStateStatus {
  initial,
  loading,
  loaded,
  error,
  errorLoadProduct,
  deleted,
  uploaded,
  saved,
}

class ProductDetailController = ProductDetailControllerBase
    with _$ProductDetailController;

abstract class ProductDetailControllerBase with Store {
  final ProductRepository _productRepository;

  @readonly
  var _status = ProductDetailStateStatus.initial;

  @readonly
  String? _errorMessage;

  @readonly
  String? _imagePath;

  ProductDetailControllerBase(this._productRepository);

  @readonly
  ProductModel? _productModel;

  @action
  Future<void> uploadImageProduct(Uint8List file, String filename) async {
    _status = ProductDetailStateStatus.loading;
    _imagePath = await _productRepository.uploadImageProduct(file, filename);
    _status = ProductDetailStateStatus.loaded;
  }

  @action
  Future<void> save(String name, double price, String description) async {
    try {
      _status = ProductDetailStateStatus.loading;
      final productModel = ProductModel(
        id: _productModel?.id,
        name: name,
        description: description,
        price: price,
        enabled: true,
        image: _imagePath!,
      );
      _status = ProductDetailStateStatus.saved;

      await _productRepository.save(productModel);
    } catch (e, s) {
      log('Erro ao salvar produto', error: e, stackTrace: s);
      _status = ProductDetailStateStatus.error;
      _errorMessage = 'Erro ao salvar o produto';
    }
  }

  @action
  Future<void> loadProduct(int? id) async {
    try {
      _status = ProductDetailStateStatus.loading;
      _productModel = null;
      _imagePath = null;
      if (id != null) {
        _productModel = await _productRepository.getProduct(id);
        _imagePath = _productModel!.image;
      }
      _status = ProductDetailStateStatus.loaded;
    } catch (e, s) {
      log('Erro ao carregar o produto', error: e, stackTrace: s);
      _status = ProductDetailStateStatus.errorLoadProduct;
      _errorMessage = 'Erro ao carregar o produto';
    }
  }
}
