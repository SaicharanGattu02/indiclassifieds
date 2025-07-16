import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavouriteItem {
  final String name;
  final String date;
  final String price;
  final String imageUrl;

  FavouriteItem({
    required this.name,
    required this.date,
    required this.price,
    required this.imageUrl,
  });
}

class FavouritesScreen extends StatelessWidget {
  final List<FavouriteItem> items = [
    FavouriteItem(
      name: 'Apple AirPods Pro',
      date: '21 Jan 2025',
      price: '₹ 8,999',
      imageUrl: 'assets/appleipod.png',
    ),
    FavouriteItem(
      name: 'JBL Charge 2 Speaker',
      date: '20 Dec 2025',
      price: '₹ 6,499',
      imageUrl: 'assets/soundspeaker.png',
    ),
    FavouriteItem(
      name: 'PlayStation Controller',
      date: '14 Nov 2024',
      price: '₹ 1,299',
      imageUrl: 'assets/gamepad.png',
    ),
    FavouriteItem(
      name: 'Nexus Mountain Bike',
      date: '05 Oct 2023',
      price: '₹ 9,100',
      imageUrl: 'assets/cycleride.png',
    ),
    FavouriteItem(
      name: 'Wildcraft Ranger Tent',
      date: '30 Sep 2022',
      price: '₹ 999',
      imageUrl: 'assets/cycleride.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Favourites',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item.imageUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff616161)
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        item.date,
                        style: TextStyle(
                          fontSize: 12,

                          color: Color(0xff898989),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        item.price,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,

                            color: Color(0xff616161),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}