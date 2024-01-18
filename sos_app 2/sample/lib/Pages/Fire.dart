import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirePage extends StatelessWidget {
  Future<void> _makeEmergencyCall() async {
    const url = 'tel:911';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _sendMessageWithLocation() async {
    try {
      // Check if location service is enabled
      if (!(await Geolocator.isLocationServiceEnabled())) {
        Fluttertoast.showToast(
          msg: "Please enable location services on your device.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
        return;
      }

      // Check if location permission is granted
      final LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Request location permission
        await Geolocator.requestPermission();
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Construct a message with the location information
      String message =
          'Emergency! My current location is: Latitude ${position.latitude}, Longitude ${position.longitude}';

      // Construct an "sms" URL to open the SMS app
      String smsUrl = 'sms:?body=$message';

      // Launch the SMS app
      if (await canLaunch(smsUrl)) {
        await launch(smsUrl);
      } else {
        throw 'Could not launch $smsUrl';
      }
    } catch (e) {
      print('Error sending SMS: $e');
      // Handle the error as needed
    }
  }

  Widget buildImageWithLink({required String imageUrl, required String link}) {
    return GestureDetector(
      onTap: () {
        launch(link);
      },
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fire',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/fire.jpg', // Replace with your image file path
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              SizedBox(
                height: 200.0,
                child: CarouselSlider(
                  items: [
                    buildImageWithLink(
                      imageUrl: 'assets/fie1.jpg',
                      link: 'https://bharatifire.com/Firefite_manage_fire.php',
                    ),
                    buildImageWithLink(
                      imageUrl: 'assets/fie2.jpg',
                      link: 'https://www.accuweather.com/en/lk/sri-lanka-weather',
                    ),
                    buildImageWithLink(
                      imageUrl: 'assets/fie3.jpg',
                      link: 'https://www.dailymirror.lk/',
                    ),
                    buildImageWithLink(
                      imageUrl: 'assets/fie4.jpg',
                      link: 'http://www.dmc.gov.lk/index.php?lang=en',
                    ),
                  ],
                  options: CarouselOptions(
                    height: 200.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'This is the Fire Emergency Page',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _makeEmergencyCall,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                      ),
                      child: Text(
                        'Call Emergency (911)',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _sendMessageWithLocation,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20),
                      ),
                      child: Text(
                        'Send Location Message',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
