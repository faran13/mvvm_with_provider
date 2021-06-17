import 'package:flutter/material.dart';
import 'package:mvvm_with_provider/view_model/view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: Colors.redAccent,
      ),
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ViewModel(),
          ),
        ],
        child: MyHomePage(
          title: 'MVVM',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  bool loading = false;
  ViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<ViewModel>(context, listen: false);
    _viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ViewModel>(context, listen: true);
    return _buildUI();
  }

  Widget _buildUI() {
    if (_viewModel.getLoadingState()) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _viewModel.getIsDataLoaded()
            ? Column(
                children: [
                  SizedBox(height: 30),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.blue,
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${_viewModel.getAllData()[index].getSingleResponse().name}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${_viewModel.getAllData()[index].getSingleResponse().city}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10);
                      },
                      itemCount: _viewModel.getAllData().length,
                    ),
                  ),
                  _getActionButton(
                    text: 'Refresh UI',
                    color: Colors.orangeAccent,
                    onPress: () async {
                      _viewModel.setLoadingState(value: true);
                      _viewModel.setIsDataLoaded(value: true);
                      Future.delayed(
                        Duration(milliseconds: 800),
                        () {
                          _viewModel.setLoadingState(value: false);
                          _viewModel.setIsDataLoaded(value: false);
                        },
                      );
                    },
                  ),
                  SizedBox(height: 50),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Get started to MVVM architecture using provider.',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _getActionButton(
                        text: 'Hit API',
                        color: Colors.redAccent,
                        onPress: () async {
                          await _viewModel.getAllUsers();
                        }),
                  ],
                ),
              ),
      );
    }
  }

  Widget _getActionButton({String text, Function onPress, Color color}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: FlatButton(
        color: color,
        splashColor: color,
        highlightColor: Colors.white.withOpacity(0.1),
        disabledColor: Colors.white.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.symmetric(vertical: 20),
        onPressed: () => onPress(),
        child: Text(
          '$text',
        ),
      ),
    );
  }

  void refresh() => setState(() {});
}
