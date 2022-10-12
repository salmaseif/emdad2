import 'package:emdad/provider/auth_provider.dart';
import 'package:emdad/utility/styles.dart';
import 'package:emdad/view/screen/tread_info/treadInfo.dart';
import 'package:flutter/material.dart';
import 'package:emdad/data/model/response/address_model.dart';
import 'package:emdad/localization/language_constrants.dart';
import 'package:emdad/provider/location_provider.dart';
import 'package:emdad/provider/order_provider.dart';
import 'package:emdad/provider/profile_provider.dart';
import 'package:emdad/utility/color_resources.dart';
import 'package:emdad/utility/dimensions.dart';
import 'package:emdad/view/basewidget/button/custom_button.dart';
import 'package:emdad/view/basewidget/custom_app_bar.dart';
import 'package:emdad/view/basewidget/my_dialog.dart';
import 'package:emdad/view/basewidget/textfield/custom_textfield.dart';
import 'package:emdad/view/screen/address/select_location_screen.dart';
import 'package:geolocator/geolocator.dart';


import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';


class AddFirstAddressScreen extends StatefulWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel address;
  final bool isBilling;
  AddFirstAddressScreen({this.isEnableUpdate = false, this.address, this.fromCheckout = false, this.isBilling});

  @override
  State<AddFirstAddressScreen> createState() => _AddFirstAddressScreenState();
}

class _AddFirstAddressScreenState extends State<AddFirstAddressScreen> with TickerProviderStateMixin{
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  //final TextEditingController _cityController = TextEditingController();
  final TextEditingController _officeNumberController = TextEditingController();
  final TextEditingController _officeBuildController = TextEditingController();
  //final TextEditingController _moreController = TextEditingController();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  //final FocusNode _numberNode = FocusNode();
  //final FocusNode _moreNode = FocusNode();
  //final FocusNode _cityNode = FocusNode();
  //final FocusNode _zipNode = FocusNode();
  final FocusNode _officeNumberNode = FocusNode();
  final FocusNode _officeBuildNode = FocusNode();
  GoogleMapController _controller;
  CameraPosition _cameraPosition;
  bool _updateAddress = true;
  Address _address;
  bool isMorning = true;
  bool isMorningSelected = false;
  int timeSelectedIndex = 0;
  bool timeSelectedIndexOk = false;

  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _address = Address.shipping;
    Provider.of<LocationProvider>(context, listen: false).initializeAllAddressType(context: context);
    Provider.of<LocationProvider>(context, listen: false).updateAddressStatusMessae(message: '');
    Provider.of<LocationProvider>(context, listen: false).updateErrorMessage(message: '');
    _checkPermission(() => Provider.of<LocationProvider>(context, listen: false).getCurrentLocation(context, false, mapController: _controller),context);
    if (widget.isEnableUpdate && widget.address != null) {
      _updateAddress = false;
      Provider.of<LocationProvider>(context, listen: false).updatePosition(CameraPosition(target: LatLng(double.parse(widget.address.latitude), double.parse(widget.address.longitude))), true, widget.address.address, context);
      _contactPersonNameController.text = '';
      _contactPersonNumberController.text = '${widget.address.phone}';
      if (widget.address.addressType == 'Home') {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(0, false);
      } else if (widget.address.addressType == 'Workplace') {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(1, false);
      } else {
        Provider.of<LocationProvider>(context, listen: false).updateAddressIndex(2, false);
      }
    }else {
      if(Provider.of<ProfileProvider>(context, listen: false).userInfoModel!=null){
        _contactPersonNameController.text = '${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName ?? ''}'
            ' ${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.lName ?? ''}';
        _contactPersonNumberController.text = Provider.of<ProfileProvider>(context, listen: false).userInfoModel.phone ?? '';
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    print('====selected shipping or billing==>${_address.toString()}');
    Provider.of<LocationProvider>(context, listen: false).setPickData();
    Provider.of<LocationProvider>(context, listen: false).getCurrentLocation(context, false, mapController: _controller);
    Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
    Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(title: widget.isEnableUpdate ? getTranslated('update_address', context) : getTranslated('add_new_address', context)),
              Consumer<LocationProvider>(
                builder: (context, locationProvider, child) {
                  return Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                child: Stack(
                                  clipBehavior: Clip.none, children: [
                                  GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: CameraPosition(
                                      target: widget.isEnableUpdate
                                          ? LatLng(double.parse(widget.address.latitude) ?? 0.0, double.parse(widget.address.longitude) ?? 0.0)
                                          : LatLng(locationProvider.position.latitude ?? 0.0, locationProvider.position.longitude ?? 0.0),
                                      zoom: 17,
                                    ),
                                    onTap: (latLng) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SelectLocationScreen(googleMapController: _controller)));
                                    },
                                    zoomControlsEnabled: false,
                                    compassEnabled: false,
                                    indoorViewEnabled: true,
                                    mapToolbarEnabled: true,
                                    onCameraIdle: () {
                                      if(_updateAddress) {
                                        locationProvider.updatePosition(_cameraPosition, false, null, context);
                                      }else {
                                        _updateAddress = true;
                                      }
                                    },
                                    onCameraMove: ((_position) => _cameraPosition = _position),
                                    onMapCreated: (GoogleMapController controller) {
                                      _controller = controller;
                                      if (!widget.isEnableUpdate && _controller != null) {
                                        Provider.of<LocationProvider>(context, listen: false).getCurrentLocation(context, true, mapController: _controller);
                                      }
                                    },
                                  ),
                                  locationProvider.loading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme
                                      .of(context).primaryColor))) : SizedBox(),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.center,
                                      height: MediaQuery.of(context).size.height,
                                      child: Icon(
                                        Icons.location_on,
                                        size: 40,
                                        color: Theme.of(context).primaryColor,
                                      )),
                                  Positioned(
                                    bottom: 10,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        _checkPermission(() => locationProvider.getCurrentLocation(context, true, mapController: _controller),context);
                                      },
                                      child: Container(
                                          width: 150,
                                          height: 30,
                                          margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                            color: ColorResources.getChatIcon(context),
                                          ),
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [ Icon(
                                                Icons.my_location,
                                                color: Theme.of(context).primaryColor,
                                                size: 20,
                                              ),
                                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                                Text(
                                                  getTranslated('clickToSelectAutoLocation', context),
                                                  style: robotoRegular.copyWith(color: ColorResources.getTextTitle(context)),
                                                ),
                                              ])
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SelectLocationScreen(googleMapController: _controller)));
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                          color: Colors.white,
                                        ),
                                        child: Icon(
                                          Icons.fullscreen,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                                ),
                              ),
                            ),

                            // for Address Field
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: getTranslated('address_line_02', context),
                              textInputType: TextInputType.streetAddress,
                              textInputAction: TextInputAction.next,
                              focusNode: _addressNode,
                              nextNode: _nameNode,
                              controller: locationProvider.locationController,
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT_ADDRESS),
                            // for Contact Person Name

                            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                          /*
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL , horizontal: Dimensions.PADDING_SIZE_EXTRA_EXTRA_SMALL),
                              child: Text(
                                getTranslated('marketType', context),
                                style: robotoRegular.copyWith(color: ColorResources.getHint(context)),
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isMorning = true;
                                          isMorningSelected = true;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: isMorning ? ColorResources.COLOR_PRIMARY : ColorResources.COLOR_WHITE,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                                offset: Offset(0, 3), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(7)),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 34,
                                              height: 34,
                                              padding: EdgeInsets.only(left: 5, right: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(7),
                                                  color: isMorning
                                                      ? ColorResources.COLOR_WHITE.withOpacity(.25)
                                                      : ColorResources.COLOR_GAINSBORO.withOpacity(.25)),
                                              child: Icon(
                                                Icons.shopping_cart,
                                                color: isMorning ? ColorResources.COLOR_WHITE : ColorResources.COLOR_PRIMARY,
                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(Strings.MARKET,
                                                        style: isMorning
                                                            ? khulaSemiBold.copyWith(
                                                          color: ColorResources.COLOR_WHITE,
                                                        )
                                                            : khulaSemiBold.copyWith(
                                                          color: ColorResources.COLOR_PRIMARY,
                                                        ))))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isMorning = false;
                                          isMorningSelected = true;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: !isMorning ? ColorResources.COLOR_PRIMARY : ColorResources.COLOR_WHITE,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                                offset: Offset(0, 3), // changes position of shadow
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(7)),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 34,
                                              height: 34,
                                              padding: EdgeInsets.only(left: 5, right: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(7),
                                                  color: !isMorning
                                                      ? ColorResources.COLOR_WHITE.withOpacity(.25)
                                                      : ColorResources.COLOR_GAINSBORO.withOpacity(.25)),
                                              child: Icon(
                                                Icons.home,
                                                color: !isMorning ? ColorResources.COLOR_WHITE : ColorResources.COLOR_PRIMARY,
                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(Strings.OFFICE,
                                                        style: !isMorning
                                                            ? khulaSemiBold.copyWith(
                                                          color: ColorResources.COLOR_WHITE,
                                                        )
                                                            : khulaSemiBold.copyWith(
                                                          color: ColorResources.COLOR_PRIMARY,
                                                        ))))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                            isMorning
                                ? StaggeredGridView.countBuilder(
                                  crossAxisCount: 4,
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: isMorning ? AppointmentData.morningData.length : AppointmentData.eveningData.length,
                                  itemBuilder: (BuildContext context, int index) => GestureDetector(
                                  onTap: () {
                                  setState(() {
                                    timeSelectedIndex = index;
                                    timeSelectedIndexOk = true;
                                  });
                                  },
                                    child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 1),
                                        decoration: BoxDecoration(
                                            color: index == timeSelectedIndex ? ColorResources.COLOR_PRIMARY : ColorResources.COLOR_WHITE,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(7)),
                                        child: Text(
                                          isMorning ? AppointmentData.morningData[index].name : AppointmentData.eveningData[index].name,
                                          style: khulaSemiBold.copyWith(color: index == timeSelectedIndex ? ColorResources.COLOR_WHITE : ColorResources.COLOR_GREY),
                                        )
                                    ),
                                  ),
                                  staggeredTileBuilder: (int index) => new StaggeredTile.count(1, 0.45),
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 10.0,
                                )
                                :  Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(right: 10, left: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7)
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: CustomTextField(
                                            hintText: getTranslated('officeBuildNumber', context),
                                            textInputType: TextInputType.name,
                                            focusNode: _officeNumberNode,
                                            nextNode: _officeBuildNode,
                                            isPhoneNumber: false,
                                            capitalization: TextCapitalization.words,
                                            controller: _officeNumberController,
                                          )),
                                      SizedBox(width: 15),
                                      Expanded(
                                          child: CustomTextField(
                                            hintText: getTranslated('officeNumber', context),
                                            focusNode: _officeBuildNode,
                                            capitalization: TextCapitalization.words,
                                            controller: _officeBuildController,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                                // for Contact Person Number

                           */
                          ],
                        ),


                        // الارسال
                        locationProvider.addressStatusMessage != null
                            ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                locationProvider.addressStatusMessage.length > 0 ? CircleAvatar(backgroundColor: Colors.green, radius: 5) : SizedBox.shrink(),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(locationProvider.addressStatusMessage ?? "",
                                    style: Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.green, height: 1),
                                  ),
                                )
                              ],
                            )
                            : Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                locationProvider.errorMessage.length > 0
                                    ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5) : SizedBox.shrink(),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(locationProvider.errorMessage ?? "",
                                    style: Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).primaryColor, height: 1),
                                  ),
                                )
                              ],
                            ),
                        Container(
                          height: 50.0,
                          margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          child: !locationProvider.isLoading ? CustomButton(
                            buttonText: widget.isEnableUpdate ? getTranslated('update_address', context) : getTranslated('save_location', context),
                            onTap: locationProvider.loading ? null : () {
                             /*
                              if(timeSelectedIndexOk == false) {
                                showCustomSnackBar('يجب اختيار نوع النشاط', context, isError: false);
                               } else if (isMorningSelected == false){
                                showCustomSnackBar('يجب إختيار النشاط والضغط مره أخرى للتأكد', context, isError: false);
                              } else {

                              */
                                AddressModel addressModel = AddressModel(
                                  addressType: locationProvider.getAllAddressType[locationProvider.selectAddressIndex],
                                  contactPersonName: 'الاساسيس' ?? '',
                                  phone: Provider.of<ProfileProvider>(context, listen: false).userInfoModel.phone ?? '',
                                  city: locationProvider.getAllAddressType[locationProvider.selectAddressIndex] ?? '',
                                  zip: Provider.of<ProfileProvider>(context, listen: false).userInfoModel.phone ?? '',
                                  isBilling: _address == Address.billing ? 1 : 0,
                                  address: locationProvider.locationController.text ?? '',
                                  latitude: widget.isEnableUpdate ? locationProvider.position.latitude.toString() ?? widget.address.latitude : locationProvider.position.latitude.toString() ?? '',
                                  longitude: widget.isEnableUpdate ? locationProvider.position.longitude.toString() ?? widget.address.longitude : locationProvider.position.longitude.toString() ?? '',
                                );
                                if (widget.isEnableUpdate) {
                                  addressModel.id = widget.address.id;
                                  addressModel.id = widget.address.id;
                                  // addressModel.method = 'put';
                                  locationProvider.updateAddress(context, addressModel: addressModel, addressId: addressModel.id).then((value) {});
                                } else {
                                  locationProvider.addAddress(addressModel, context).then((value) {
                                    if (value.isSuccess) {
                                      Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
                                      if (widget.fromCheckout) {Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
                                        print('fromCheckout::::: fromCheckout');
                                        Provider.of<OrderProvider>(context, listen: false).setAddressIndex(1);
                                        Provider.of<AuthProvider>(context, listen: false).setAddressInfoFinch();
                                        Provider.of<AuthProvider>(context, listen: false).setTreadInfo();
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TreadInfo(start: true)));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text(value.message),
                                            duration: Duration(milliseconds: 600),
                                            backgroundColor: Colors.green));
                                        Provider.of<AuthProvider>(context, listen: false).setTreadInfo();
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TreadInfo(start: true)));
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(value.message),
                                          duration: Duration(milliseconds: 600),
                                          backgroundColor: Colors.red));
                                    }
                                  });
                                }
                             // }
                            },
                          )
                              : Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                              )),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _checkPermission(Function callback, BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied || permission == LocationPermission.whileInUse) {
      InkWell(
          onTap: () async{
            Navigator.pop(context);
            await Geolocator.requestPermission();
            _checkPermission(callback, context);
          },
          child: AlertDialog(content: MyDialog(icon: Icons.location_on_outlined, title: '', description: getTranslated('you_denied', context))));
    }else if(permission == LocationPermission.deniedForever) {
      InkWell(
          onTap: () async{
            Navigator.pop(context);
            await Geolocator.openAppSettings();
            _checkPermission(callback,context);
          },
          child: AlertDialog(content: MyDialog(icon: Icons.location_on_outlined, title: '',description: getTranslated('you_denied', context))));
    }else {
      callback();
    }
  }
}

enum Address { shipping, billing }