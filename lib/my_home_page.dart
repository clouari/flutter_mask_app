import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mask_app/model/mask_stores.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final stores = <MaskStores>[];
  // final isLoading = true; // 이 값이 True 면 로딩을 표시하고, 아니면 게시물을 표시해라!
  var isLoading = true;

  // 비동기 코드를 만들어서 쓰려고 하는구나 생각하기!
  // 여기서 Future 는 생략이 가능하다.
  Future fetch() async {
    setState(() {
      isLoading = true;
    });
    var url =
        'https://gist.githubusercontent.com/junsuk5/bb7485d5f70974deee920b8f0cd1e2f0/raw/063f64d9b343120c2cb01a6555cf9b38761b1d94/sample.json';

    var response = await http.get(Uri.parse(url));

    final jsonResult = jsonDecode(
      utf8.decode(response.bodyBytes),
    );

    final jsonStores = jsonResult['stores'];

    setState(() {
      stores.clear();
      // 지워주는 이유는? 새로고침 만들어서 리셋 시켜줄건데, clear를 안 해 주면, 계속 쌓인다.
      jsonStores.forEach((e) {
        stores.add(MaskStores.fromJson(e));
      });
      isLoading = false;
    });
    // print('fetch완료'); // 제대로 들어오는 지 확인하기 위해 테스트함.

    // print(jsonResult['stores']); // 가지고 오고 싶은 값만 넣어서 확인할 수 있다.
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${jsonDecode(
    //   utf8.decode(response.bodyBytes),
    // )}');
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마스크 재고 있는 곳 : ${stores.length}곳'),
        actions: [
          IconButton(onPressed: fetch, icon: const Icon(Icons.refresh))
        ],
      ),
      body: isLoading
          ? loadingWidget()
          : ListView(
              children: stores.map((e) {
                return ListTile(
                  title: Text(e.name ?? ''),
                  subtitle: Text(e.addr ?? ''),
                  trailing: Text(e.remainStat ?? '매진'),
                );
              }).toList(),
            ),
    );
  }

  Widget loadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text('정보를 가져오는 중'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}
