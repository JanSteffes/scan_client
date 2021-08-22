library swagger.api;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

part 'api_client.dart';
part 'api_helper.dart';
part 'api_exception.dart';
part 'auth/authentication.dart';
part 'auth/oauth.dart';

part 'api/file_api.dart';
part 'api/scan_api.dart';

part 'model/scan_quality.dart';

ApiClient defaultApiClient = new ApiClient();
