import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWordState extends StatefulWidget {
  RandomWordState({Key key}) : super(key: key);

  _RandomWordStateState createState() => _RandomWordStateState();
}

class _RandomWordStateState extends State<RandomWordState> {

  final _suggestions=[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = new Set<WordPair>();
  Widget _buildRow(WordPair pair){
    final alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style:_biggerFont
      ),
      trailing: Icon(
        alreadySaved?Icons.favorite:Icons.favorite_border,
        color: alreadySaved?Colors.red:null,
      ),
      onTap: (){
        setState(() {
          if(alreadySaved){
            _saved.remove(pair); 
          }else{
            _saved.add(pair); 
          }
         
        });
      },
    );
  }

  Widget _buildSuggestions(){
    // return ListView(
    //   padding: EdgeInsets.all(16.0),
    //   children: <Widget>[

    //   ],
    // );

    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemBuilder: (context,i){
        if(i.isOdd){
          return Divider();
        }
        final index = i~/2;
        if(index>= _suggestions.length){
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final wordPair = new WordPair.random();
    return _buildSuggestions();
  }
}

class Demo1 extends StatelessWidget {

  final wordPair = new WordPair.random();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RandomWordState(),
    );
  }
}