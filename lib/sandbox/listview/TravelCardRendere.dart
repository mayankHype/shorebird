import 'package:flutter/material.dart';
import 'GridViewTest.dart';


class TravelCardRenderer extends StatelessWidget {
  final double offset;
  final double cardWidth;
  final double cardHeight;
  final City city;

  const TravelCardRenderer(this.offset, {Key? key, this.cardWidth = 250, required this.city,required this.cardHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(top: 8),
      child: Stack(
        // overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
          // Card background color & decoration
          Container(
            margin: EdgeInsets.only(top: 30, left: 12, right: 12, bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4 * offset.abs()),
                BoxShadow(color: Colors.black12, blurRadius: 10 + 6 * offset.abs()),
              ],
            ),
          ),
          // City image, out of card by 15px
          Positioned(top: -15, child: _buildCityImage()),
          // City information
          _buildCityData()
        ],
      ),
    );
  }

  Widget _buildCityImage() {
    double maxParallax = 30;
    double globalOffset = offset * maxParallax * 2;
    double cardPadding = 28;
    double containerWidth = cardWidth - cardPadding;
    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(
        //   fit: BoxFit.fill,
        //     colorFilter: ColorFilter.mode(Colors.grey, BlendMode.colorBurn),
        //     filterQuality: FilterQuality.low,
        //     image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-nIpREIykE7YoosaXTOp-qHY0BoqscicOyA&usqp=CAU",
        //
        //     ))
      ),
      height: cardHeight,
      width: containerWidth,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // _buildPositionedLayer(city.description, containerWidth * .8, maxParallax * .1, globalOffset),
          // _buildPositionedLayer(city.description, containerWidth * .9, maxParallax * .6, globalOffset),
          _buildPositionedLayer(city.description, containerWidth * .9, maxParallax, globalOffset),
        ],
      ),
    );
  }

  Widget _buildCityData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // The sized box mock the space of the city image
        SizedBox(width: double.infinity, height: cardHeight * .57),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(city.title, style: Styles.cardTitle, textAlign: TextAlign.center),
        ),


      ],
    );
  }

  Widget _buildPositionedLayer(String path, double width, double maxOffset, double globalOffset) {
    double cardPadding = 24;
    double layerWidth = cardWidth - cardPadding;
    return Positioned(
        left: ((layerWidth * .5) - (width / 2) - offset * maxOffset) + globalOffset,
        bottom: cardHeight * .45,
        child: Image.network(
          path,
          width: width,

        ));
  }
}
