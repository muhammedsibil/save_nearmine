import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:file_selector/file_selector.dart' hide XFile;
// hides to test if share_plus exports XFile

import 'package:image_picker/image_picker.dart'
    hide XFile; // hides to test if share_plus exports XFile
import 'package:share_plus/share_plus.dart';

import '../../../../../../utility/utility.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class Review extends StatefulWidget {
  const Review(
      {super.key,
      required this.name,
      required this.shopName,
      required this.category,
      required this.shopNumber,
      required this.city,
      required this.subCity,
      required this.productId});
  final String name;
  final String shopName;
  final String category;
  final String shopNumber;
  final String city;
  final String subCity;
  final String productId;
  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  @override
  Widget build(BuildContext context) {
    Map producutData = {
      'name': widget.name,
      'shopName': widget.shopNumber,
      'category': widget.category,
      'shopNumber': widget.shopNumber,
      'city': widget.city,
      'subCity': widget.subCity,
      'productId': widget.productId,
    };
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              var child;
              return DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.70,
                  minChildSize: 0.40,
                  maxChildSize: 1,
                  builder: (context, scrollController) {
                    child ??= Stack(
                      children: [
                        SingleChildScrollView(
                          controller: scrollController,
                          // physics: AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: SizedBox(
                              height: ScreenSize.size.height,
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 8.0),
                                  ReviewPage(
                                      productId: widget.productId,
                                      productData: producutData,
                                      scrollController: scrollController),

                                  // Container(
                                  //   height: 56,
                                  //   color: Colors.red,
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black.withOpacity(0.1),
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 190,
                                  child: Text("Reviews",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close,
                                      color: Colors.black54)),
                            ],
                          ),
                        ),
                      ],
                    );
                    return child;
                  });
            });
      },
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "5.3",
                style: Business.headline6
                    .copyWith(fontSize: 16, color: Colors.black54),
              ),
              Icon(Icons.star_outline, color: Colors.black54),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "Rate review",
            style: TextStyle(fontSize: 10, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class ReviewPage extends StatefulWidget {
  const ReviewPage({
    super.key,
    required this.scrollController,
    required this.productId,
    required this.productData,
  });
  final ScrollController scrollController;
  final String productId;
  final Map productData;
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final commentController = TextEditingController();
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ReviewModel>>(
      stream: getReviews(widget.productId,widget.productData),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final reviews = snapshot.data!;

        return Expanded(
          child: ListView(
            controller: widget.scrollController,
            // physics: NeverScrollableScrollPhysics(),
            children: [
              // Allow the user to add a new review
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      maxRating: 5,
                      itemSize: 32,
                      allowHalfRating: true,
                      unratedColor: Colors.grey[400],
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (newRating) {
                        setState(() {
                          rating = newRating;
                        });
                      },
                    ),
                    Container(
                      height: 50,
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(hintText: 'Leave a review'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        addReview(commentController.text, rating,
                            widget.productId, widget.productData);
                        commentController.clear();
                        setState(() {
                          rating = 0;
                        });
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),

              // Show each review
              for (var review in reviews)
                ListTile(
                  title: Text(review.comment),
                  subtitle: Text(review.timestamp.toString()),
                  trailing: RatingBar.builder(
                    initialRating: review.rating,
                    minRating: 1,
                    maxRating: 5,
                    itemSize: 24,
                    allowHalfRating: true,
                    unratedColor: Colors.grey[400],
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      updateReview(review.id, rating, widget.productId,widget.productData);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class ReviewModel {
  final String id;
  final String comment;
  final double rating;
  final DateTime timestamp;

  ReviewModel({
    required this.id,
    required this.comment,
    required this.rating,
    required this.timestamp,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      comment: data['comment'],
      rating: data['rating'],
      timestamp: data['timestamp'].toDate(),
    );
  }
}


Future<void> addReview(
    String comment, double rating, String productId, Map productData) async {
  final reviewsRef = FirebaseFirestore.instance
      .collection('Place')
      .doc(productData['city'])
      .collection('SubCity')
      .doc(productData['subCity'])
      .collection('Shop')
      .doc(productData['shopNumber'])
      .collection('Category')
      .doc(productData['category'])
      .collection("Product")
      .doc(productId)
      .collection("Reviews");
  await reviewsRef.add({
    'comment': comment,
    'rating': rating,
    'timestamp': Timestamp.now(),
  });
}

// Update an existing review in Firestore
Future<void> updateReview(
    String reviewId, double newRating, String productId,Map productData) async {
  final reviewsRef = FirebaseFirestore.instance
      .collection('Place')
      .doc(productData['city'])
      .collection('SubCity')
      .doc(productData['subCity'])
      .collection('Shop')
      .doc(productData['shopNumber'])
      .collection('Category')
      .doc(productData['category'])
      .collection("Product")
      .doc(productId)
      .collection("Reviews");
  await reviewsRef.doc(reviewId).update({'rating': newRating});
}

// Get a stream of all reviews from Firestore
Stream<List<ReviewModel>> getReviews(String productId,Map productData) {
  final reviewsRef = FirebaseFirestore.instance
      .collection('Place')
      .doc(productData['city'])
      .collection('SubCity')
      .doc(productData['subCity'])
      .collection('Shop')
      .doc(productData['shopNumber'])
      .collection('Category')
      .doc(productData['category'])
      .collection("Product")
      .doc(productId)
      .collection("Reviews");
  return reviewsRef
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs
        .map((doc) => ReviewModel.fromFirestore(doc))
        .toList();
  });
}


/// Widget for displaying a preview of images




