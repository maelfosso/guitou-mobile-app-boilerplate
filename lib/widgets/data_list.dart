import 'package:flutter/cupertino.dart';
import 'package:guitou/models/data_model.dart';
import 'package:guitou/widgets/data_item.dart';
import 'package:provider/provider.dart';

class DataList extends StatelessWidget {

  static const String pageId = '/data_list_page';

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return DataItem(dataIndex: index);
      },
      itemCount: Provider.of<DataModel>(context).datasCount,
    );
  }
}