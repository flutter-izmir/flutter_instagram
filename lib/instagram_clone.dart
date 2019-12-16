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
              title: Text('asd'),
              icon: Icon(
                Icons.person,
                color: Colors.black,
              )),
          BottomNavigationBarItem(
              title: Text('asdd'),
              icon: Icon(
                Icons.person,
                color: Colors.black,
              )),
          BottomNavigationBarItem(
              title: Text('ass'),
              icon: Icon(
                Icons.person,
                color: Colors.black,
              )),
          BottomNavigationBarItem(
              title: Text('ddsa'),
              icon: Icon(
                Icons.person,
                color: Colors.black,
              )),
          BottomNavigationBarItem(
              title: Text('fgas'),
              icon: Icon(
                Icons.person,
                color: Colors.black,
              )),
        ],
      ),
    );
  }
}

class BuildPost extends StatelessWidget {
  final PostModel postModel;

  const BuildPost({Key key, this.postModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildPostTop(),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2.5,
          child: Image.network(
            postModel.postImageUrl,
            fit: BoxFit.fill,
          ),
        ),
        _buildPostBottom(),
      ],
    );
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
                backgroundImage: NetworkImage(postModel.profileImageUrl),
              ),
              SizedBox(
                width: 15,
              ),
              Text(postModel.name),
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
              icon: postModel.likes.contains('my_current_uid')
                  ? Icon(Icons.favorite, color: Colors.red)
                  : Icon(Icons.favorite_border),
              onPressed: () {
                if (postModel.likes.contains('my_current_uid')) {
                  postModel.likes.remove('my_current_uid');
                  postModel.reference.updateData({
                    'likes': postModel.likes,
                    'likeCount': FieldValue.increment(1),
                  });
                } else {
                  postModel.likes.add('my_current_uid');
                  postModel.reference.updateData({
                    'likes': postModel.likes,
                    'likeCount': FieldValue.increment(-1),
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.comment),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.subdirectory_arrow_left),
              onPressed: () {
                Firestore.instance.collection('posts').add(postModel.toJson());
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: Text(
            '${postModel.likeCount} likes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
