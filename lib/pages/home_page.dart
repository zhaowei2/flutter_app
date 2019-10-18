
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import '../service/service_mathod.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  
  @override
  bool get wantKeepAlive=>true;

  String homePageContent ='正在获取数据';

  @override
  void initState() {
    print('获取数据------------');
    getHomePageContent().then((val){
      print(val);
      setState(() {
        
      });
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('百姓生活+')
      ),
      // 有listview 不使用
      body:new SingleChildScrollView(
        child: FutureBuilder(
        future: getHomePageContent(),
        builder: (context,snapshot){
          print(111111111111);
          print(snapshot); 
          print(222222222222);
          print(snapshot.hasData);
          if(snapshot.hasData){
            var data=json.decode(snapshot.data.toString());
            print(data['data']);
            // List<Map> swiper =(data['data'])
            List swiper =data['data']['slides'];
            List navigationList = data['data']['category'];
            String adPicture = data['data']['advertesPciture']['PICTURE_ADDRESS'];
            String leaderImage =data['data']['shopInfo']['leaderImage'];
            String leaderPhone =data['data']['shopInfo']['leaderPhone'];
            List recommendList =data['data']['recomend'];
            String floorTitle =data['data']['floorPic']['PICTURE_ADDRESS'];
            // List floorGoodsList =data['data']['floorPic']['floorList'];

           List floorGoodsList=[{
            "image":'http://via.placeholder.com/350x150'
          },{
            "image":'http://via.placeholder.com/350x150'
          },{
            "image":'http://via.placeholder.com/350x150'
          },{
            "image":'http://via.placeholder.com/350x150'
          },];
            return Container(
              child:Column(
                children: <Widget>[
                  SwiperDiy(swiperDateList:swiper),
                  TopNavigator(navigatorList:navigationList),
                  AdBanner(adPicture:adPicture),
                  LeaderPhone(leaderImage: leaderImage,leaderPhone: leaderPhone,),
                  Recommend(recommendList:recommendList),
                  FloorTitle(pictrueAddress:floorTitle),
                  FloorContent(floorGoodsList:floorGoodsList)
                ],
              )
            );
            
          }else{
            print('加载中');
            return Center(
              child: Text('加载宏'),
            );
          }
        },
      )
      )
    );
  }
}

// 首页轮播组件
class  SwiperDiy extends StatelessWidget {
  final List swiperDateList;

  SwiperDiy({Key dey,this.swiperDateList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(400),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          return Image.network("${swiperDateList[index]['img']}",fit: BoxFit.fill,);
        },
        itemCount: 3,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}
// 导航
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({Key key,this.navigatorList}) : super(key: key);
  
  Widget _gridViewItemUI(BuildContext context,item){
    return InkWell(
      onTap: (){
        print('点击导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width:ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if(this.navigatorList.length>10){
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding:EdgeInsets.all(3.0),
        // children: <Widget>[
        //   Text('111111111')
        // ],
        children: navigatorList.map((item){
          return _gridViewItemUI(context, item);
          // return Text('11111111111');
        }).toList(),
      ),
    );
  }
}
// banner图
class AdBanner extends StatelessWidget {
  final String adPicture;
  const AdBanner({Key key,this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture,height:ScreenUtil().setHeight(200),fit: BoxFit.fill),
    );
  }
}
//拨打电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;
  const LeaderPhone({Key key,this.leaderImage,this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: (){
          _launchURL();
        },
        // child: Text(leader/Phone),
        child: Image.network(leaderImage,height:ScreenUtil().setHeight(200),fit: BoxFit.fill),
      ),
    );
  }

  void _launchURL() async{
    String url ='tel:'+leaderPhone;
    print(url);
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'url不能访问';
    }
  }
} 
// 商品推荐类
class Recommend extends StatelessWidget {
  final List recommendList;
  const Recommend({Key key,this.recommendList}) : super(key: key);

  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      padding:EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0) ,
      decoration: BoxDecoration(
        color: Colors.white,
        border:Border(
          bottom: BorderSide(
            width: 0.5,color: Colors.black12
          )
        )
      ),
      child: Text('商品推荐',
        style: TextStyle(color:Colors.pink),
      ),
    );
  }

  // 商品单独项

  Widget _item(index){
    return InkWell(
      onTap: (){

      },
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border:Border(
            left: BorderSide(
              width: 1,
              color: Colors.black12
            )
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey
              ),
            )
          ],
        ),
      ),
    );
  }
  
  // 横向列表方法

  Widget _recommedList(){
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context,index){
          return _item(index);
        },
      ),
      
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top:10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommedList()
        ],
      ),
    );
  }
}

// 楼层标题

class FloorTitle extends StatelessWidget {
  final String pictrueAddress;

  const FloorTitle({Key key,this.pictrueAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(pictrueAddress),
    );
  }
}

// 楼层商品列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;
 
  const FloorContent({Key key,this.floorGoodsList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(floorGoodsList[0]);
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods()
        ],
      ),
    );
  }

  Widget _firstRow(){

    return Row(
      children: <Widget>[
        // _gootsItem([floorGoodsList[1]]),
        _gootsItem(floorGoodsList[1]),
        _gootsItem(floorGoodsList[2]),
        
      ],
    );
  }

  Widget _otherGoods(){
    var good2 =floorGoodsList[2];
    print(good2);
    return Row(
      children: <Widget>[
        _gootsItem(floorGoodsList[1]),
        _gootsItem(floorGoodsList[2]),
        _gootsItem(floorGoodsList[1]),
      ],
    );
  }

  Widget _gootsItem(goods){

    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: (){
          print('点击了楼层商品');
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}

// import 'package:flutter/material.dart';r

// // import '../service/service_mathod.dart';
// import '../demo/demo01.dart';

// class HomePage extends StatefulWidget {

//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {

//   String homePageContent = '正在获取数据';
//   @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //   getHomePageContent();
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return Demo1();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/widgets.dart';

// import '../config/httpHeaders.dart';

// class HomePage extends StatefulWidget {
//   HomePage({Key key}) : super(key: key);

//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String showText='还没有请求书';
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: Scaffold(
//         //  backgroundColor: Color(
//         //   //  Color.fromRGBO(255, 255, 255, 1)
//         //  ),
//          appBar: AppBar(
//            title: Text('远程数据'),
//          ),
//          body: SingleChildScrollView(
//            child: Column(
//              children: <Widget>[
//                RaisedButton(
//                  onPressed: (){
//                     _jike();
//                  },
//                  child: Text('请求数据'),
//                ),
//                Text(
//                  showText
//                )
//              ],
//            ),
//          ),
//        ),
//     );
//   }

//   void _jike(){
//     print('开始请求极客时间数据---------');
//     getHttp().then((val){
//       setState(() {
//        showText =val['data'].toString(); 
//       });
//     });
//   }

//   Future getHttp() async{
//     try{
//       Response response;
//       Dio dio = new Dio();
//       dio.options.headers = httpHeades;
//       response = await dio.get('https://time.geekbang.org/serv/v1/column/newAll');
//       print(response);
//       return response.data;
//     }catch(e){
//       print(e);
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';

// class HomePage extends StatefulWidget {
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {

//   @override
//   TextEditingController typeController = TextEditingController();

//   void initState() { 
//     super.initState();
//     this.typeController.text = 'ptbird'; // 设置初始值
//   }
//   String showText ='欢迎';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//        child: Scaffold(
//          appBar: AppBar(
//            title:Text('美好人间')
//          ),
//          body:Column(
//            children: <Widget>[
//              TextField(
//                controller: typeController,
//                decoration: InputDecoration(
//                  contentPadding: EdgeInsets.all(10.0),
//                  labelText: '美女类型',
//                  helperText: '请输入你喜欢的类型'
//                ),
//                autofocus: false,
//              ),
//              RaisedButton(
//                child: Text('选择完毕'),
//                onPressed: (){
//                  _choiceAction();
//                 //  print(this.typeController.text);
//                },
//              ),
//              Text(
//                  showText,
//                  overflow: TextOverflow.ellipsis,
//                  maxLines: 1,
//               )
//            ],
//          )
//        ),
//     );
//   }

//   Future getHttp(String TypeText) async{
//     try{
//       Response response;
//       var data ={'name':TypeText};
//       response = await Dio().get('https://www.easy-mock.com/mock/5da58b62b3d26c45bb3af780/example/query?name=美女y');
//       print(response);
//       return response;
//     }catch(e){

//     }
//   }

//   void _choiceAction(){
//     print('开始你喜欢-------');
//     print(typeController.text);
//     if(typeController.text.toString()==''){
//       showDialog(
//         context: context,
//         builder: (context)=>AlertDialog(title: Text('美女类型布恩不能为空'),)
//       );
//     }else{
//       getHttp(typeController.text.toString()).then((value){
//         print(value);
//       });
//   }


//   }
// }
