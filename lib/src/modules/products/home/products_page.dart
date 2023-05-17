import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../../core/ui/helpers/debouncer.dart';
import '../../../core/ui/helpers/loader.dart';
import '../../../core/ui/helpers/messages.dart';
import '../../../core/ui/widgets/base_header.dart';
import 'products_controller.dart';
import 'widgets/product_item.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> with Loader, Messages {
  final controller = Modular.get<ProductsController>();
  late final ReactionDisposer statusDisposer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      statusDisposer = reaction((_) => controller.status, (status) async {
        switch (status) {
          case ProductStateStatus.initial:
            break;
          case ProductStateStatus.loading:
            showLoader();
            break;
          case ProductStateStatus.loaded:
            hideLoader();
            break;
          case ProductStateStatus.error:
            hideLoader();
            showError(controller.errorMessage ?? 'Erro ao buscar os produtos');
            break;
          case ProductStateStatus.addOrUpdateProduct:
            hideLoader();

            var uri = '/products/detail';
            final productSelected = controller.productSelected;

            if(controller.productSelected != null){
              uri += '?id=${productSelected?.id}';
            }

            await Modular.to.pushNamed(uri);
            controller.loadProducts();
            break;
        }
      });
      controller.loadProducts();
    });
    super.initState();
  }

  @override
  void dispose() {
    statusDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(milliseconds: 500);

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.only(left: 40, top: 40, right: 40),
      child: Column(
        children: [
          BaseHeader(
            title: 'ADMINISTRAR PRODUTOS',
            buttonLabel: 'ADICIONAR PRODUTOS',
            buttonPressed: controller.addProduct,
            searchChange: (value) {
              debouncer.call(() {
                controller.filterByName(value);
              });
            },
          ),
          const SizedBox(
            height: 50,
          ),
          Observer(
            builder: (_) {
              return Expanded(
                child: GridView.builder(
                  itemCount: controller.products.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 280,
                    mainAxisSpacing: 20,
                    maxCrossAxisExtent: 280,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return ProductItem(product: controller.products[index]);
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
