import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:shorebird/feature/location/location_service.dart';
import 'package:shorebird/sandbox/listview/widget/bottomBar.dart';
import 'package:shorebird/sandbox/util/SharedPrefrence.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';





class GridViewTest extends StatefulWidget {
  const GridViewTest({super.key});

  @override
  State<GridViewTest> createState() => _GridViewTestState();
}

class _GridViewTestState extends State<GridViewTest> {


  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
  List<String> generateTimeSlots(DateTime selectedDate,bool pick) {
    List<String> timeSlots = [];
    DateTime currentTime = selectedDate ;
    bool pickUpSame=isSameDate(selectedDate,DateTime.now());
    print(pickUpSame);

    currentTime=pickUpSame==true?DateTime.now():DateTime(currentTime.year, currentTime.month, currentTime.day, 7, 30);

    // Generate time slots until 8:00 PM if pickup and drop dates are the same
    // or until 8:00 PM from 8:00 AM for different pickup and drop dates
    DateTime endTime =DateTime(currentTime.year, currentTime.month, currentTime.day, 20, 30);

    // Round up to the nearest 30-minute interval
    int minutesToAdd =pick==true? 30-(currentTime.minute % 30):60-(currentTime.minute % 30) ;



    DateTime roundedTime =currentTime.add(Duration(minutes: minutesToAdd));

    // Generate time slots
    while (roundedTime.isBefore(endTime)) {
      String formattedTime = "${roundedTime.hour}:${roundedTime.minute.toString().padLeft(2, '0')}";
      timeSlots.add(formattedTime);

      // Move to the next 30-minute interval
      roundedTime = roundedTime.add(Duration(minutes: 30));
    }

    return timeSlots;
  }
  @override
  void initState() {
    super.initState();


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


body: Column(
  children: [
    SizedBox(
      height: 50,
    ),
    GestureDetector(
      onTap: (){
        CalendarFormat _calendarFormat = CalendarFormat.month;
        RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
            .toggledOn; // Can be toggled on/off by longpressing a date
        DateTime _focusedDay = DateTime.now();
        DateTime? _selectedDay;
        DateTime? _rangeStart;
        DateTime? _rangeEnd;
        List<String>? _pickTime;
        List<String>? _endTime;
        String pick="Select";
        String drop="Select";

        String? _selectedOption="Multiday";
        showModalBottomSheet(
            backgroundColor: Colors.white,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height - 30,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    AppBar(
                      leading: IconButton(
                        icon: Icon(
                          Icons.close,
                          size: 22,
                        ),
                        onPressed: () {
Navigator.of(context).pop();
                        },
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      title: Text(
                        " Date",
                        style: Styles.appHeader.copyWith(
                            fontSize:
                           22,
                            fontWeight: FontWeight.w600),
                      ),
                    ),

                    Divider(
                      color: Colors.grey.withOpacity(0.2),
                      height: 10,
                    ),

                    // Padding( padding: const EdgeInsets.all(8.0),
                    // child: Row(
                    //
                    //   children: [
                    //     ChoiceChip(label: Text("Today"), selected: false),
                    //     SizedBox(
                    //       width: ScreenInfo.responsiveWidth(10),
                    //     ),
                    //     ChoiceChip(label: Text("Days"), selected: false)
                    //   ],
                    // ),
                    // ),
                    StatefulBuilder(builder: (context, setState) {
                      return Column(
                        children: [
                          // Row(
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: Text(
                          //         "Renting period?",
                          //         style: Styles.appHeader.copyWith(
                          //             fontWeight: FontWeight.w600,
                          //
                          //       ),
                          //     ),),
                          //
                          //   ],
                          // ),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile(
                                  title: Text('Multiday'),
                                  value: 'Multiday',
                                  groupValue: _selectedOption,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedOption = value;
                                      _rangeSelectionMode=RangeSelectionMode.toggledOn;

                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile(
                                  title: Text('Single day'),
                                  value: 'Singleday',
                                  groupValue: _selectedOption,
                                  onChanged: (value) {
                                    setState(() {

                                      _rangeStart=null;
                                      _rangeEnd=null;
                                      _rangeSelectionMode=RangeSelectionMode.toggledOff;
                                      _selectedOption=value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                       




                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              // height: ScreenInfo.responsiveHeight(250),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.grey
                                          .withOpacity(0.3))),

                              child: Column(
                                children: [
                                  SizedBox(
                                    height:

                                        5,
                                  ),

                                  /// Checkbox


                              TableCalendar(
                               firstDay: DateTime.now(),
                                lastDay: DateTime(2024,12,30),
                                focusedDay: _focusedDay,
                                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                                rangeStartDay: _rangeStart,
                                rangeEndDay: _rangeEnd,
                                calendarFormat: _calendarFormat,

                                rangeSelectionMode: _rangeSelectionMode,
                                onDaySelected: (selectedDay, focusedDay) {

                                    setState(() {
                                      _selectedDay = selectedDay;
                                      _focusedDay = focusedDay;
                                      _rangeStart = null; // Important to clean those
                                      _rangeEnd = null;
                                      _rangeSelectionMode = RangeSelectionMode.toggledOff;
                                      _pickTime=generateTimeSlots(_selectedDay!,true);
                                      _pickTime?.insert(0, 'Select');
                                      _endTime=generateTimeSlots(_selectedDay!, false);
                                      _endTime?.insert(0, 'Select');
                                    });

                                },
                                onRangeSelected: (start, end, focusedDay) {
                                  setState(() {
                                    _selectedDay = null;
                                    _focusedDay = focusedDay;
                                    _rangeStart = start;
                                    _rangeEnd = end;
                                    _rangeSelectionMode = RangeSelectionMode.toggledOn;

                                    _pickTime=generateTimeSlots(_rangeStart!,true);
                                    _pickTime?.insert(0, 'Select');

                                    _endTime=generateTimeSlots(_rangeEnd!, false);
                                    _endTime?.insert(0, 'Select');
                                  });
                                },

                                onPageChanged: (focusedDay) {
                                  _focusedDay = focusedDay;
                                },
                              ),

                                  _rangeStart!=null&&_rangeEnd!=null?  SizedBox(
                                    height:10,
                                  ):SizedBox()
                                ],
                              ),
                            ),
                          ),


                          if(_selectedOption=="Multiday"&&_rangeStart!=null&&_rangeEnd!=null)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black45
                              )
                            ),
                            child: Column(
                              children: [
                               ListTile(
                                 title: Text("PickUp Date"),
                                 subtitle: Text(_rangeStart!.toUtc().toString()),
                                 trailing:DropdownButton<String>(
                                   value: pick,
                                   items: _pickTime!.map((String value) {
                                     return DropdownMenuItem<String>(
                                       value: value,
                                       child: Text(value),
                                     );
                                   }).toList(),
                                   onChanged: (String? newValue) {
                                     setState(() {
                                       pick=newValue!;
                                       // Handle dropdown value change
                                     });
                                   },
                                 ),
                               ),
                                ListTile(
                                  title: Text("Drop Date"),
                                  subtitle: Text(_rangeEnd!.toUtc().toString()),
                                  trailing:DropdownButton<String>(
                                    value: drop,
                                    items: _endTime!.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        drop=newValue!;
                                        // Handle dropdown value change
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),

                         _selectedOption!.toLowerCase()=="Singleday".toLowerCase()&&_selectedDay!=null?
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.black45
                                  )
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text("PickUp Time"),

                                    trailing:DropdownButton<String>(
                                      value: pick,
                                      items: _pickTime!.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          pick=newValue!;
                                          // Handle dropdown value change
                                        });
                                      },
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Drop Time"),

                                    trailing:DropdownButton<String>(
                                      value: drop,
                                      items: _endTime!.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          drop=newValue!;
                                          // Handle dropdown value change
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ):Container()

                        ],
                      );
                    }),
                    Spacer(),

                  ],
                ),
              );
            });
      },
      child: Container(
        height: 40,
        color: Colors.red,
      ),
    ),
    Expanded(
      child: CustomPaint(
      size: Size(double.infinity, 400),
        painter: RPSCustomPainter(),
      
      ),
    ),
  ],
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
class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    // Layer 1

    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;


    Path path_0 = Path();
    path_0.moveTo(size.width*0.4006000,size.height*0.6885937);
    path_0.lineTo(size.width*0.3995100,size.height*0.8654085);
    path_0.lineTo(size.width*0.6005100,size.height*0.8642378);
    path_0.lineTo(size.width*0.6002100,size.height*0.6899038);
    path_0.quadraticBezierTo(size.width*0.5578000,size.height*0.6431242,size.width*0.4949500,size.height*0.6395844);
    path_0.quadraticBezierTo(size.width*0.4421300,size.height*0.6430406,size.width*0.4006000,size.height*0.6885937);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);


    // Layer 1

    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;



    canvas.drawPath(path_0, paint_stroke_0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}


