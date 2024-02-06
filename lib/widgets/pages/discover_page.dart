import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Startup for the app, see if endpoint is reachable or not
/// if reachable, process to main_page, if not show option to try again (and enpoint address) or to try and discover again
/// keep old not reachable endpoint while rediscovering to be able to revert, e.g. set new endpoint to settings only if reachable
class DiscoverPage extends StatefulWidget {
  DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  late Future<SharedPreferences> _getSharedPrefs;
  String endpointAddressSettingKey = "ScanClient_EndpointAddress";

  @override
  void initState() {
    super.initState();
    _getSharedPrefs = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getSharedPrefs,
        builder: (BuildContext buildContext,
            AsyncSnapshot<SharedPreferences> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              // get if endpoint is set
              final endpointSet =
                  snapshot.data?.getString(endpointAddressSettingKey);
              // is not reachable
              //TODO pint endpoint with calling ping method? add to endpoint?

            } else {
              // show fail if error or no data
              return Icon(Icons.error, color: Colors.red);
            }
          }
          return Container(child: Center(child: CircularProgressIndicator()));
        });
  }
}
