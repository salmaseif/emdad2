import 'package:emdad/view/screen/requstOrder/request_for_quation.dart';
import 'package:flutter/material.dart';

class RequestQuotation extends StatefulWidget {
  const RequestQuotation({Key key}) : super(key: key);

  @override
  _RequestQuotationState createState() => _RequestQuotationState();
}

class _RequestQuotationState extends State<RequestQuotation> {
  TextEditingController _productTextController = TextEditingController();
  TextEditingController _quantityTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _value;

  List<String> _values = <String>[];

  @override
  void initState() async {
    super.initState();
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
    _value = _values.elementAt(0);
    // signupRequestModel = SignUpRequestModel();
  }

  void _onChanged(String value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Fill in what you are looking for!",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Text(
                "The more specific your information,the more accracy we can match your req to theright suppliers.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            //For First Name text Field
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: TextFormField(
                // onSaved: (input) => signupRequestModel.password = input,
                  controller: _productTextController,
                style: TextStyle(color: Colors.black),
                // obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 15.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "What Are You Looking For",
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
            // for Last name Text Field
            Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: TextFormField(
                // onSaved: (input) => signupRequestModel.password = input,
                  controller: _quantityTextController,
                style: TextStyle(color: Colors.black),
                // obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 15.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 1.0),
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
            //For Email Textfield
            Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, left: 10, right: 10, bottom: 10),
              child: Container(
                //width: 150,
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ));
                        }).toList(),
                        isDense: true,
                        onChanged: (String value) {
                          _onChanged(value);
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
            //Request Button
            Padding(
              padding: const EdgeInsets.only(top: 25.0, left: 10, right: 10),
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
                    if(validateAndSave()) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new RequestForQuatation()));
                    }

                  },
                  minWidth: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Text(
                    "REQUEST FOR QUOTATION",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 270,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(1.0), BlendMode.softLight),
                      image: AssetImage("assets/images/get_quote.jpeg"),
                      fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Get Quotes from your',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        children: const <TextSpan>[
                          TextSpan(
                              text: ' Custom Request',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Let the right wholesaler fulfill your Demands",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "30000+",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "5000+",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "1000+",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "RFQs",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Active Wholeseler",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Indrustries",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    //REQUEST FOR QUOTATION Button
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 25.0, left: 10, right: 10),
                    //   child: Material(
                    //     // borderRadius: BorderRadius.circular(28.0),
                    //     // color: Colors.blue.withOpacity(0.8),
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(25.0)),
                    //     color: Colors.blue[900],
                    //     elevation: 2.0,
                    //     //   highlightElevation: 2,
                    //     child: MaterialButton(
                    //       onPressed: () {
                    //         // Navigator.push(
                    //         //     context,
                    //         //     MaterialPageRoute(
                    //         //         builder: (context) =>
                    //         //         new BottomNavigationDataItems()));
                    //       },
                    //       minWidth: MediaQuery.of(context).size.width,
                    //       height: 50,
                    //       child: Text(
                    //         "REQUEST FOR QUOTATION",
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(
                    //             color: Colors.white,
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: 17.0),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
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
