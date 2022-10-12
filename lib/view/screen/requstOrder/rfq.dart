import 'package:emdad/view/screen/requstOrder/request_for_quation.dart';
import 'package:flutter/material.dart';

class RFQ extends StatefulWidget {
  const RFQ({Key key}) : super(key: key);

  @override
  _RFQState createState() => _RFQState();
}

class _RFQState extends State<RFQ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.blueAccent,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 70,
        title: Image.asset(
          "assets/images/logo.png",
          scale: 8,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            _rfqTitle(),
            SizedBox(
              height: 10.0,
            ),
            _latestRfq(),
           // SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

  //rfq title
  _rfqTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Latest RFQ:",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Material(
            // borderRadius: BorderRadius.circular(28.0),
            // color: Colors.blue.withOpacity(0.8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: Colors.blue[900],
            elevation: 2.0,
            //   highlightElevation: 2,
            child: MaterialButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        new RequestForQuatation()));
              },
              // minWidth: MediaQuery.of(context).size.width,
              height: 30,
              child: Text(
                "Request For Quotation",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _latestRfq() {
    return Padding(
      padding: const EdgeInsets.only(left:10.0, right: 10.0, top: 10.0, bottom: 20.0),
      child: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Container(
                          height: 100,
                          width: 100,
                          child: Image.asset("assets/images/trade4.jpeg")),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New arrivals",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Container(
                            width: 250,
                            child: Text(
                              "rain bow color shape - square,round,hexagonalglow in dark shape- square,round,hexagonalsize-12.5*12.5*1.5...",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                              maxLines: 2,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 250,
                          child: Text(
                            "Quantity Required：100000 Pieces Date Posted：2021-06-03",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
