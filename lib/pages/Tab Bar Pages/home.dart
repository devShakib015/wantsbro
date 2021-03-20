import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wantsbro/theming/color_constants.dart';

class Home extends StatelessWidget {
  final List<String> images = [
    "https://images.all-free-download.com/images/graphicthumb/small_green_tree_200348.jpg",
    "https://images.all-free-download.com/images/graphiclarge/free_vector_summer_beach_image_48512.jpg",
    "https://images.all-free-download.com/images/graphiclarge/free_vector_graphic_retro_background_147282.jpg",
    "https://images.all-free-download.com/images/graphiclarge/red_world_card_free_vector_graphic_556967.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Swiper(
                itemCount: images.length,
                itemWidth: MediaQuery.of(context).size.width * 0.83,
                layout: SwiperLayout.STACK,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: mainColor,
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
