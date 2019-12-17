import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/post_model.dart';

void main() => runApp(InstagramApp());

class InstagramApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(iconTheme: IconThemeData(color: Colors.black)),
      home: InstagramHome(),
    );
  }
}

class InstagramHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Instagram',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BuildPost(
                      postModel: PostModel.fromSnapshot(
                          snapshot.data.documents.elementAt(index)),
                    );
                  },
                );
              } else {
                return Text('Error');
              }
              return Text('Error');
          }
          return Text('Error');
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              title: Container(),
              icon: Icon(
                Icons.home,
                color: Colors.black,
              )),
          BottomNavigationBarItem(
              title: Container(),
              icon: Icon(
                Icons.search,
                color: Colors.black,
              )),
          BottomNavigationBarItem(
              title: Container(),
              icon: Icon(
                Icons.add_box,
                color: Colors.black,
              )),
          BottomNavigationBarItem(
              title: Container(),
              icon: Icon(
                Icons.favorite_border,
                color: Colors.black,
              )),
          BottomNavigationBarItem(
              title: Container(),
              icon: Icon(
                Icons.person,
                color: Colors.black,
              )),
        ],
      ),
    );
  }
}

class BuildPost extends StatefulWidget {
  final PostModel postModel;

  const BuildPost({Key key, this.postModel}) : super(key: key);

  @override
  _BuildPostState createState() => _BuildPostState();
}

class _BuildPostState extends State<BuildPost> {
  double size = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildPostTop(),
        GestureDetector(
          onDoubleTap: () async {
            animateIcon();
            handleLike();
            await Future.delayed(Duration(milliseconds: 900));
            animateIcon();
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2.5,
                child: Image.network(
                  widget.postModel.postImageUrl,
                  fit: BoxFit.fill,
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.bounceInOut,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(Icons.favorite, color: Colors.white),
                ),
                width: size,
                height: size,
              )
            ],
          ),
        ),
        _buildPostBottom(),
      ],
    );
  }

  void animateIcon() {
    if (size == 100.0) {
      setState(() {
        size = 0.0;
      });
    } else {
      setState(() {
        size = 100.0;
      });
    }
  }

  _buildPostTop() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(widget.postModel.profileImageUrl),
              ),
              SizedBox(
                width: 15,
              ),
              Text(widget.postModel.name),
            ],
          ),
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  _buildPostBottom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: widget.postModel.likes.contains('my_current_uid')
                  ? Icon(Icons.favorite, color: Colors.red)
                  : Icon(Icons.favorite_border),
              onPressed: handleLike,
            ),
            IconButton(
              icon: Icon(Icons.comment),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.subdirectory_arrow_left),
              onPressed: () {
                Firestore.instance
                    .collection('posts')
                    .add(widget.postModel.toJson());
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: Text(
            '${widget.postModel.likeCount} likes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void handleLike() {
    if (widget.postModel.likes.contains('my_current_uid')) {
      widget.postModel.likes.remove('my_current_uid');
      widget.postModel.reference.updateData({
        'likes': widget.postModel.likes,
        'likeCount': FieldValue.increment(-1),
      });
    } else {
      widget.postModel.likes.add('my_current_uid');
      widget.postModel.reference.updateData({
        'likes': widget.postModel.likes,
        'likeCount': FieldValue.increment(1),
      });
    }
  }
}
