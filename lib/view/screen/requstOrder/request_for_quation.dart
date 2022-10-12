import 'dart:io';
import 'dart:convert';
import 'package:emdad/view/screen/requstOrder/progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class RequestForQuatation extends StatefulWidget {
  const RequestForQuatation({Key key}) : super(key: key);

  @override
  _RequestForQuatationState createState() => _RequestForQuatationState();
}

class _RequestForQuatationState extends State<RequestForQuatation> {
  //late File imageFile;

  TextEditingController _purchaseTextController = TextEditingController();
  TextEditingController _quantityTextController = TextEditingController();
  TextEditingController _piecesTextController = TextEditingController();
  TextEditingController _selectCategoryTextController = TextEditingController();
  TextEditingController _specificationTextController = TextEditingController();
  TextEditingController _shipToTextController = TextEditingController();
  TextEditingController _expectedPriceTextController = TextEditingController();
  TextEditingController _deliveryTextController = TextEditingController();
  TextEditingController _otherContactToTextController = TextEditingController();
  TextEditingController _linksTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;

  String value;

  List<String> _values = <String>[];

  String _categoryItem;
  List<String> _categoryItems = <String>[];

  File image1FromGallery;
  File image2FromGallery;
  File image3FromGallery;

  @override
  void initState() {
    _values.addAll([
      "Pieces",
      "Bags",
      "Boxes",
      "Carton/Cartons",
      "Case/Cases",
      "Cozen/Cozens",
      "Gallon/Gallons",
      "Gram/Grams",
      "Liter/Liters",
      "Pack/Packs",
      "Pairs",
      "Parcel/Parcels",
      "Set/Sets",
    ]);
    value = _values.elementAt(0);

    _categoryItems.addAll([
      "Consumer Electronics",
      "Men's Fashion",
      "Women's Fashion",
      "Shoes and Accessories",
      "Watches & Accessories",
      "Babe's & Toys",
      "Health & Beauty",
      "Home & Lifestyle",
      "Stationary, Sport & Outdoors",
    ]);
    _categoryItem = _categoryItems.elementAt(0);
    // signupRequestModel = SignUpRequestModel();
    super.initState();
  }

  void _onChanged(String value) {
    setState(() {
      value = value;
    });
  }

  void _onChangedCategory(String categoryItem) {
    setState(() {
      _categoryItem = categoryItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetupForQuatation(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetupForQuatation(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: Icon(Icons.menu),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        toolbarHeight: 70,
        title: Image.asset(
          "assets/images/logo.png",
          scale: 8,
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
                //  _scaffoldState.currentState.openDrawer();
              },
              // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Stack(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/ecommerce.jpeg',
              ),
            ),
          ),
          height: double.infinity,
          width: double.infinity,
        ),
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.blue,
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.blue[800].withOpacity(0.8),
                    Colors.blue[800].withOpacity(0.8),
                  ],
                  stops: [
                    0.0,
                    1.0
                  ])),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 50,
                  ),
                  child: Material(
                    elevation: 10,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30.0, left: 10.0, right: 10.0),
                              child: Center(
                                child: Text(
                                  "The more specific your information, the more accurately we can match your request to the right suppliers.",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 10),
                              child: Text(
                                "*Purchase：",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            // SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10, right: 10),
                              child: TextFormField(
                                // onSaved: (input) => signupRequestModel.password = input,
                                controller: _purchaseTextController,
                                style: TextStyle(color: Colors.black),
                                // obscureText: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 18.0, horizontal: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: "What are you looking for",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "This field is Required.";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      "*Quantity：",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10, right: 10),
                              child: TextFormField(
                                // onSaved: (input) => signupRequestModel.password = input,
                                controller: _quantityTextController,
                                style: TextStyle(color: Colors.black),
                                obscureText: false,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 18.0, horizontal: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: "Quantity",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "This field is Required.";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, left: 10, right: 10, bottom: 10),
                              child: Container(
                                //width: 150,
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.0,
                                        style: BorderStyle.solid,
                                        color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                ),
                                child: new DropdownButtonHideUnderline(
                                  child: new Column(
                                    children: <Widget>[
                                      new DropdownButtonFormField(
                                        // onSaved: (input) => signupRequestModel.church = input,
                                        isExpanded: true,
                                        // dropdownColor: Colors.blue,
                                        iconEnabledColor: Colors.black,
                                        hint: Text(
                                          "Pieces",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0),
                                        ),
                                        //value: _value,
                                        items: _values.map((String value) {
                                          return new DropdownMenuItem(
                                              value: value,
                                              child: new Text(
                                                " $value",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              ));
                                        }).toList(),
                                        isDense: true,
                                        onChanged: (String value) {
                                          _onChanged(value);
                                          setState(() {
                                            _piecesTextController.text = value;
                                          });
                                        },
                                        // validator: (value) {
                                        //   if (value.isEmpty) {
                                        //     return "The password doesnot match";
                                        //   }
                                        //   return null;
                                        // },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      "*Category：",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, left: 10, right: 10, bottom: 10),
                              child: Container(
                                //width: 150,
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.0,
                                        style: BorderStyle.solid,
                                        color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                ),
                                child: new DropdownButtonHideUnderline(
                                  child: new Column(
                                    children: <Widget>[
                                      new DropdownButtonFormField(
                                        // onSaved: (input) => signupRequestModel.church = input,
                                        isExpanded: true,
                                        // dropdownColor: Colors.blue,
                                        iconEnabledColor: Colors.black,
                                        hint: Text(
                                          "Select Category",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.0),
                                        ),
                                        value: _categoryItem,
                                        items: _categoryItems
                                            .map((String categoryItem) {
                                          return new DropdownMenuItem(
                                              value: categoryItem,
                                              child: new Text(
                                                " $categoryItem",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              ));
                                        }).toList(),
                                        isDense: true,

                                        onChanged: (String categoryItem) {
                                          setState(() {
                                            _selectCategoryTextController.text =
                                                categoryItem;
                                          });
                                          _onChangedCategory(categoryItem);
                                        },
                                        // validator: (value) {
                                        //   if (value.isEmpty) {
                                        //     return "The password doesnot match";
                                        //   }
                                        //   return null;
                                        // },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 15.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      "*Specifications：",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10, right: 10),
                              child: TextFormField(
                                minLines: 8,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                // onSaved: (input) => signupRequestModel.password = input,
                                controller: _specificationTextController,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 18.0, horizontal: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText:
                                      "Details Specification is helpfull for more quotes",
                                  hintMaxLines: 2,
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "This field is Required.";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      "Pictures：",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Material(
                                    elevation: 10,
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(15),
                                    child: InkWell(
                                      onTap: () {
                                        _getImage1FromGallery();
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        // child:  Image.asset("assets/images/beauty.jpeg", fit: BoxFit.cover,),
                                        child: image1FromGallery != null
                                            ? Image.file(image1FromGallery)
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    size: 25,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    "Upload",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 17),
                                                  )
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    elevation: 10,
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(15),
                                    child: InkWell(
                                      onTap: () {
                                        _getImage2FromGallery();
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        child: image2FromGallery != null
                                            ? Image.file(image2FromGallery)
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    size: 25,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    "Upload",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 17),
                                                  )
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    elevation: 10,
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(15),
                                    child: InkWell(
                                      onTap: () {
                                        _getImage3FromGallery();
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        child: image3FromGallery != null
                                            ? Image.file(image3FromGallery)
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    size: 25,
                                                    color: Colors.grey,
                                                  ),
                                                  Text(
                                                    "Upload",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 17),
                                                  )
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Container(
                            //   alignment: Alignment.center,
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: <Widget>[
                            //       // _decideImageView(),
                            //       RaisedButton(
                            //         color: Colors.greenAccent,
                            //         onPressed: () {
                            //           _getFromGallery();
                            //         },
                            //         child: Text("PICK FROM GALLERY"),
                            //       ),
                            //       Container(
                            //         height: 40.0,
                            //       ),
                            //       RaisedButton(
                            //         color: Colors.lightGreenAccent,
                            //         onPressed: () {
                            //           _getFromCamera();
                            //         },
                            //         child: Text("PICK FROM CAMERA"),
                            //       )
                            //     ],
                            //   ),
                            // ),

                            SizedBox(
                              height: 15.0,
                            ),

                            SizedBox(
                              height: 15.0,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      "*Ship to：",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10, right: 10),
                              child: TextFormField(
                                // onSaved: (input) => signupRequestModel.password = input,
                                controller: _shipToTextController,
                                style: TextStyle(color: Colors.black),
                                //obscureText: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 18.0, horizontal: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: "Enter Country/City/State",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "This field is Required.";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      "Expected price：",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10, right: 10),
                              child: TextFormField(
                                // onSaved: (input) => signupRequestModel.password = input,
                                controller: _expectedPriceTextController,
                                style: TextStyle(color: Colors.black),
                               // obscureText: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 18.0, horizontal: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: "Expected Price",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      "Expected delivery time：",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10, right: 10),
                              child: TextFormField(
                                // onSaved: (input) => signupRequestModel.password = input,
                                controller: _deliveryTextController,
                                style: TextStyle(color: Colors.black),
                               // obscureText: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 18.0, horizontal: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: "Expected Delivery time",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 15.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      "Other contacts：",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10, right: 10),
                              child: TextFormField(
                                // onSaved: (input) => signupRequestModel.password = input,
                                controller: _otherContactToTextController,
                                style: TextStyle(color: Colors.black),
                               // obscureText: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 18.0, horizontal: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: "Phone/Viber/WhatsApp",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 15.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      "Links：",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10, right: 10),
                              child: TextFormField(
                                // onSaved: (input) => signupRequestModel.password = input,
                                controller: _linksTextController,
                                style: TextStyle(color: Colors.black),
                                //obscureText: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 18.0, horizontal: 15.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: "Product Links",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 25.0, left: 10, right: 10),
                              child: Material(
                                // borderRadius: BorderRadius.circular(28.0),
                                // color: Colors.blue.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0)),
                                color: Colors.blue[900],
                                elevation: 2.0,
                                //   highlightElevation: 2,
                                child: MaterialButton(
                                  onPressed: () {
                                    if (validateAndSave()) {
                                      setState(() {
                                        isApiCallProcess = true;
                                      });
                                      _requestQuatation(
                                          _purchaseTextController.text,
                                          _quantityTextController.text
                                              .toString(),
                                          _piecesTextController.text,
                                          _selectCategoryTextController.text
                                              .toString(),
                                          _specificationTextController.text,
                                          _shipToTextController.text,
                                      _expectedPriceTextController.text,
                                        _deliveryTextController.text,
                                        _otherContactToTextController.text,
                                        _linksTextController.text,

                                      );
                                    }
                                  },
                                  minWidth: MediaQuery.of(context).size.width,
                                  height: 50,
                                  child: Text(
                                    "SUBMIT",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  /// Get from gallery
  Future _getImage1FromGallery() async {
    try {
      final image = await ImagePicker().getImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageData = File(image.path);
      setState(() {
        this.image1FromGallery = imageData;
      });
    } on PlatformException catch (e) {
      print("Faild to Get Image : $e");
    }
  }

  Future _getImage2FromGallery() async {
    try {
      final image = await ImagePicker().getImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageData = File(image.path);
      setState(() {
        this.image2FromGallery = imageData;
      });
    } on PlatformException catch (e) {
      print("Faild to Get Image : $e");
    }
  }

  Future _getImage3FromGallery() async {
    try {
      final image = await ImagePicker().getImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageData = File(image.path);
      setState(() {
        this.image3FromGallery = imageData;
      });
    } on PlatformException catch (e) {
      print("Faild to Get Image : $e");
    }
  }

  /// Get from camera
  // _getFromCamera() async {
  //   PickedFile pickedFile = (await ImagePicker().getImage(
  //     source: ImageSource.camera,
  //     maxWidth: 1800,
  //     maxHeight: 1800,
  //   ))!;
  //   setState(() {
  //     imageFromGallery = pickedFile as File;
  //   });
  //   if (pickedFile != null) {
  //     File imageFile = File(pickedFile.path);
  //   }
  // }

  // _decideImageView() {
  //   if (imageFromGallery == null) {
  //     return Text("No Image Selected");
  //   } else {
  //     Image.file(
  //       imageFromGallery!,
  //       width: 200,
  //       height: 200,
  //     );
  //   }
  // }
  var jsonResponse;

  void _requestQuatation(
      String purchase,
      String quantity,
      String unit,
      String categoryId,
      String specifications,
      String shipTo,
      String expectedPrice,
      String expectedDelTime,
      String otherContact,
      String link,
      ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String loginToken = preferences.getString("login_token");

    var header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $loginToken'
    };

    var data = {
      'purchase': purchase,
      'category_id': categoryId,
      'quantity': quantity,
      'unit': unit,
      'specifications': specifications,
      'ship_to': shipTo,
      'expected_price': expectedPrice,
      'expected_del_time': expectedDelTime,
      'other_contact': otherContact,
      'link': link,


    };
    var url = 'https://seller.sastowholesale.com/api/quotation';
    var res = await http.post(Uri.parse(url), body: data, headers: header);
    print(json.decode(res.body));
    var body = json.decode(res.body);

    if (body['message'] == 'success') {
      setState(() {
        isApiCallProcess = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(body['message'],
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        action: SnackBarAction(
            label: 'Close',
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar()),
      ));
    } else {
      setState(() {
        isApiCallProcess = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(body['message'],
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        action: SnackBarAction(
            label: 'Close',
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar()),
      ));
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
