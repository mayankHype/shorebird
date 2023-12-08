import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shorebird/feature/location/location_service.dart';
import 'package:shorebird/sandbox/listview/widget/bottomBar.dart';
import 'package:shorebird/sandbox/util/SharedPrefrence.dart';
import 'package:url_launcher/url_launcher.dart';





class GridViewTest extends StatefulWidget {
  const GridViewTest({super.key});

  @override
  State<GridViewTest> createState() => _GridViewTestState();
}

class _GridViewTestState extends State<GridViewTest> {
  List<City>? _cityList;
  City? _currentCity;

  @override
  void initState() {
    super.initState();
    var data = DemoData();
    _cityList = data.getCities();
    _currentCity = _cityList![1];
  }

  void _handleCityChange(City city) {
    setState(() {
      this._currentCity = city;
    });
  }
  List<IconData> icons=[
    Icons.home,
    Icons.search,
    Icons.add,
    Icons.person
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: SharedStorage.instance.city==null?Text("Select",
          style: Styles.appHeader,
        ):Row(
          children: [
            Text(SharedStorage.instance!.city.toString(),
              style: Styles.appHeader.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
              ),

            ),
            RotatedBox(quarterTurns:1,child: Icon(Icons.chevron_right),)
          ],
        ),

        actions: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: ()async{

       var loc=SharedStorage.instance.location;
       var latitude=loc!.split('+')[0];
       var longitude=loc!.split('+')[1];
              String origin = '${loc!.split('+')[0]},${loc!.split('+')[1]}';
              String destination = '${double.tryParse(latitude)! + 0.002},${double.tryParse(longitude)! - 0.002}';



              final Uri _url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving&dir_action=navigate');

              await launchUrl(
                _url,
                mode: LaunchMode.externalApplication,
              );
                  },
                  icon:Icon(Icons.local_offer_outlined)),
              SizedBox(width: 5,),
              Text("Offers",
                style: Styles.appHeader.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                ),

              ),

            ],
          ),
          SizedBox(width: 10,),
        ],
      ),

      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [

            Text(
              'Choose your city',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: Styles.appHeader,
              maxLines: 2,
            ),
            Expanded(child: GridView.builder(
                itemCount: _cityList!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  childAspectRatio: 16/13

                ),
                itemBuilder: (context,i){
                  final data=_cityList![i];
                  return GestureDetector(
                    onTap: (){
                      SharedStorage.instance.saveCity(data.name);
                    },
                    child: Container(
                    height: 50,
                      decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),

                        image: DecorationImage(
                            fit: BoxFit.fill,

                            image: NetworkImage(data.description))
                      ),

                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,

                      colors: [
                        Colors.black,

                        Colors.grey.withOpacity(0.2),

                      ]
                    )
                            ),
                          ),
                          Align(alignment: Alignment.bottomCenter,
                          child: Text(data.name,

                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700
                          ),
                          ),
                          ),
                        ],
                      ),
                    ),
                  );
                }))

            // Image.network("https://i.etsystatic.com/14058895/r/il/99bf9f/1233826558/il_570xN.1233826558_r819.jpg"),
            //
            // TravelCardList(
            //   cities: _cityList,
            //   onCityChange: _handleCityChange,
            // ),

          ],
        ),
      ),
    );
  }
}



class Styles {
  static const double hzScreenPadding = 18;

  static final TextStyle baseTitle = TextStyle(fontSize: 11, fontFamily: 'DMSerifDisplay', );
  static final TextStyle baseBody = TextStyle(fontSize: 11, fontFamily: 'OpenSans');

  static final TextStyle appHeader = baseTitle.copyWith(color: Colors.black, fontSize: 36, height: 1);

  static final TextStyle cardTitle = baseTitle.copyWith(height: 1, color: Color(0xFF1a1a1a), fontSize: 25);
  static final TextStyle cardSubtitle = baseBody.copyWith(color: Color(0xFF666666), height: 1.5, fontSize: 12);
  static final TextStyle cardAction =
  baseBody.copyWith(color: Color(0xFFa6998b), fontSize: 10, height: 1, fontWeight: FontWeight.w600, letterSpacing: 0.1);

  static final TextStyle hotelsTitleSection = baseBody.copyWith(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold, height: 2);
  static final TextStyle hotelTitle = baseBody.copyWith(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600);
  static final TextStyle hotelPrice = baseBody.copyWith(color: Color(0xff4d4d4d), fontSize: 13);
  static final TextStyle hotelScore = baseBody.copyWith(color: Color(0xff0e0e0e));
  static final TextStyle hotelData = baseBody.copyWith(color: Colors.grey[700]);
}





class City {
  final String name;
  final String title;
  final String description;
  final Color color;
  final List<Hotel> hotels;

  City({
    required this.title,
    required   this.name,
    required   this.description,
    required    this.color,
    required  this.hotels,
  });
}

class Hotel {
  final String name;
  double rate;
  final int reviews;
  final int price;

  Hotel(this.name, { required this.reviews, required  this.price}) : rate = 5.0;
}

class DemoData {
  List<City> _cities = [
    City(
        name: 'Haldwani',
        title: 'Haldwani',
        description: 'https://yugo.com/resource/blob/440256/c8041fdb4cf4e5eb2d566f1e00fc1056/video-placeholder-image-data.png',
        color: Color(0xffdee5cf),
        hotels: [
          Hotel('Hotel Bologna', reviews: 201, price: 120),
          Hotel('Tree House', reviews: 85, price: 98),
          Hotel('Allegroitalia Pisa Tower Plaza', reviews: 128, price: 119),
        ]), City(
        name: 'Haldwani',
        title: 'Haldwani',
        description: 'https://yugo.com/resource/blob/440256/c8041fdb4cf4e5eb2d566f1e00fc1056/video-placeholder-image-data.png',
        color: Color(0xffdee5cf),
        hotels: [
          Hotel('Hotel Bologna', reviews: 201, price: 120),
          Hotel('Tree House', reviews: 85, price: 98),
          Hotel('Allegroitalia Pisa Tower Plaza', reviews: 128, price: 119),
        ]), City(
        name: 'Haldwani',
        title: 'Haldwani',
        description: 'https://yugo.com/resource/blob/440256/c8041fdb4cf4e5eb2d566f1e00fc1056/video-placeholder-image-data.png',
        color: Color(0xffdee5cf),
        hotels: [
          Hotel('Hotel Bologna', reviews: 201, price: 120),
          Hotel('Tree House', reviews: 85, price: 98),
          Hotel('Allegroitalia Pisa Tower Plaza', reviews: 128, price: 119),
        ]), City(
        name: 'Haldwani',
        title: 'Haldwani',
        description: 'https://yugo.com/resource/blob/440256/c8041fdb4cf4e5eb2d566f1e00fc1056/video-placeholder-image-data.png',
        color: Color(0xffdee5cf),
        hotels: [
          Hotel('Hotel Bologna', reviews: 201, price: 120),
          Hotel('Tree House', reviews: 85, price: 98),
          Hotel('Allegroitalia Pisa Tower Plaza', reviews: 128, price: 119),
        ]),
    City(
        name: 'Haldwani',
        title: 'Haldwani',
        description: 'https://yugo.com/resource/blob/440256/c8041fdb4cf4e5eb2d566f1e00fc1056/video-placeholder-image-data.png',
        color: Color(0xffdee5cf),
        hotels: [
          Hotel('Hotel Bologna', reviews: 201, price: 120),
          Hotel('Tree House', reviews: 85, price: 98),
          Hotel('Allegroitalia Pisa Tower Plaza', reviews: 128, price: 119),
        ]),
    City(
        name: 'Kathgodam',
        title: 'Kathgodam',
        description: 'https://www.euttaranchal.com/tourism/photos/kathgodam-railway-station-7176622.jpg',
        color: Color(0xffdaf3f7),
        hotels: [
          Hotel('Hotel Estilo Budapest', reviews: 762, price: 87),
          Hotel('Danubius Hotel', reviews: 3122, price: 196),
          Hotel('Golden Budapest Condominium', reviews: 213, price: 217),
        ]),
    City(
        name: 'Nanital',
        title: 'Nanital',
        description: 'https://static.toiimg.com/thumb/92198781/Nainital.jpg?width=1200&height=900',
        color: Color(0xfff9d9e2),
        hotels: [
          Hotel('InterContinental London Hotel', reviews: 1624, price: 418),
          Hotel('Brick Lane Hotel', reviews: 101, price: 101),
          Hotel('Park Villa Boutique House', reviews: 161, price: 128),
        ]),
    City(
        name: 'Nanital',
        title: 'Nanital',
        description: 'https://static.toiimg.com/thumb/92198781/Nainital.jpg?width=1200&height=900',
        color: Color(0xfff9d9e2),
        hotels: [
          Hotel('InterContinental London Hotel', reviews: 1624, price: 418),
          Hotel('Brick Lane Hotel', reviews: 101, price: 101),
          Hotel('Park Villa Boutique House', reviews: 161, price: 128),
        ]),  City(
        name: 'Nanital',
        title: 'Nanital',
        description: 'https://static.toiimg.com/thumb/92198781/Nainital.jpg?width=1200&height=900',
        color: Color(0xfff9d9e2),
        hotels: [
          Hotel('InterContinental London Hotel', reviews: 1624, price: 418),
          Hotel('Brick Lane Hotel', reviews: 101, price: 101),
          Hotel('Park Villa Boutique House', reviews: 161, price: 128),
        ]),
  ];

  List<City> getCities() => _cities;
  List<Hotel> getHotels(City city) => city.hotels;
}
