import 'package:flutter/material.dart';
import 'package:emdad/provider/search_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/custom_themes.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatelessWidget {
  final String hintText;
  final Function onTextChanged;
  final Function onClearPressed;
  final Function onSubmit;
  final bool isSeller;
  SearchWidget({@required this.hintText, this.onTextChanged, @required this.onClearPressed, this.onSubmit, this.isSeller= false});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController(text: Provider.of<SearchProvider>(context).searchText);
    return Stack(children: [
      ClipRRect(
        child: Container(
          height: isSeller? 50 : 80 + MediaQuery.of(context).padding.top,
          width: MediaQuery.of(context).size.width,
        ),
      ),

      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(width : MediaQuery.of(context).size.width,
          height: isSeller? 50 : 60,
          alignment: Alignment.center,
          child: Row(children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.PADDING_SIZE_SMALL),
                        bottomLeft: Radius.circular(Dimensions.PADDING_SIZE_SMALL))
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT, horizontal: Dimensions.PADDING_SIZE_SMALL),
                  child: TextFormField(
                    controller: _controller,
                    onFieldSubmitted: (query) {
                      onSubmit(query);
                    },
                    onChanged: (query) {
                      onTextChanged(query);
                    },
                    textInputAction: TextInputAction.search,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: hintText,
                      isDense: true,
                      hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                      border: InputBorder.none,
                      //prefixIcon: Icon(Icons.search, color: ColorResources.getColombiaBlue(context), size: Dimensions.ICON_SIZE_DEFAULT),
                      suffixIcon: Provider.of<SearchProvider>(context).searchText.isNotEmpty ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          onClearPressed();
                          _controller.clear();
                        },
                      ) : _controller.text.isNotEmpty ? IconButton(
                        icon: Icon(Icons.clear, color: ColorResources.getChatIcon(context)),
                        onPressed: () {
                          onClearPressed();
                          _controller.clear();
                        },
                      ) : null,
                    ),
                  ),
                ),

              ),
            ),
            InkWell(
              onTap: (){
                Provider.of<SearchProvider>(context, listen: false).saveSearchAddress( _controller.text.toString());
                Provider.of<SearchProvider>(context, listen: false).searchProduct( _controller.text.toString(), context);
              },
              child: Container(
                width: 55,height: 55,decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.PADDING_SIZE_SMALL),
                      bottomLeft: Radius.circular(Dimensions.PADDING_SIZE_SMALL))
              ),
                child: Icon(Icons.search, color: Theme.of(context).cardColor, size: Dimensions.ICON_SIZE_SMALL),
              ),
            ),
            SizedBox(width: 10),
          ]),
        ),
      ),
    ]);
  }
}
