import 'package:chopper/chopper.dart';
import 'package:chopper/chopper.dart' as chopper;
import 'scan_server_api.enums.swagger.dart' as enums;
export 'scan_server_api.enums.swagger.dart';

part 'scan_server_api.swagger.chopper.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class ScanServerApi extends ChopperService {
  static ChopperClient createClient(String baseUrl) {
    return ChopperClient(
        services: [_$ScanServerApi()],
        converter: $JsonSerializableConverter(),
        baseUrl: baseUrl);
  }

  static ScanServerApi create(
    String baseUrl, [
    ChopperClient? client,
  ]) {
    if (client != null) {
      return _$ScanServerApi(client);
    }

    final newClient = createClient(baseUrl);
    return _$ScanServerApi(newClient);
  }

  ///Merge the given files and return result name.
  ///@param folder folder of both files
  ///@param resultFileName
  ///@param filesToMerge
  @Post(path: '/api/File/MergeFiles/{folder}/{resultFileName}')
  Future<chopper.Response<String>> apiFileMergeFilesFolderResultFileNamePost(
      {@Path('folder') required String? folder,
      @Path('resultFileName') required String? resultFileName,
      @Body() required List<String>? filesToMerge});

  ///Delete given file.
  ///@param folder folder of file
  ///@param fileName
  @Delete(path: '/api/File/DeleteFile/{folder}/{fileName}')
  Future<chopper.Response<bool>> apiFileDeleteFileFolderFileNameDelete(
      {@Path('folder') required String? folder,
      @Path('fileName') required String? fileName});

  ///Return file
  ///@param folder folder of file
  ///@param fileToRead
  @Get(path: '/api/File')
  Future<chopper.Response<String>> apiFileGet(
      {@Query('folder') String? folder,
      @Query('fileToRead') String? fileToRead});

  ///Return all files in a specific directory ordererd descending by name (newest first)
  ///@param directory
  @Get(path: '/api/File/ReadFiles')
  Future<chopper.Response<List<String>>> apiFileReadFilesGet(
      {@Query('directory') String? directory});

  ///Rename a file
  ///@param folder
  ///@param oldFileName
  ///@param newFileName
  @Patch(
      path: '/api/File/RenameFile/{folder}/{oldFileName}/{newFileName}',
      optionalBody: true)
  Future<chopper.Response<String>>
      apiFileRenameFileFolderOldFileNameNewFileNamePatch(
          {@Path('folder') required String? folder,
          @Path('oldFileName') required String? oldFileName,
          @Path('newFileName') required String? newFileName});

  ///Return all folders
  @Get(path: '/api/File/ReadFolders')
  Future<chopper.Response<List<String>>> apiFileReadFoldersGet();

  ///
  ///@param folder
  ///@param fileName
  @Get(path: '/api/File/GetThumbnailOfFile/{folder}/{fileName}')
  Future<chopper.Response<String>> apiFileGetThumbnailOfFileFolderFileNameGet(
      {@Path('folder') required String? folder,
      @Path('fileName') required String? fileName});

  ///Scan a file to the given folder and fileName
  ///@param folderName folder to put result in
  ///@param fileName name the file should get
  ///@param scanQuality quality to scan with
  @Post(path: '/api/Scan', optionalBody: true)
  Future<chopper.Response<String>> apiScanPost(
      {@Query('folderName') String? folderName,
      @Query('fileName') String? fileName,
      @Query('scanQuality') required enums.ScanQuality scanQuality});
}

final Map<Type, Object Function(Map<String, dynamic>)>
    scanServerApiJsonDecoderMappings = {};

String? scanQualityToJson(enums.ScanQuality? scanQuality) {
  return enums.$ScanQualityMap[scanQuality];
}

enums.ScanQuality scanQualityFromJson(String? scanQuality) {
  if (scanQuality == null) {
    return enums.ScanQuality.fast;
  }

  return enums.$ScanQualityMap.entries
      .firstWhere(
          (element) => element.value.toLowerCase() == scanQuality.toLowerCase(),
          orElse: () => const MapEntry(enums.ScanQuality.fast, ''))
      .key;
}

List<String> scanQualityListToJson(List<enums.ScanQuality>? scanQuality) {
  if (scanQuality == null) {
    return [];
  }

  return scanQuality.map((e) => enums.$ScanQualityMap[e]!).toList();
}

List<enums.ScanQuality> scanQualityListFromJson(List? scanQuality) {
  if (scanQuality == null) {
    return [];
  }

  return scanQuality.map((e) => scanQualityFromJson(e.toString())).toList();
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  chopper.Response<ResultType> convertResponse<ResultType, Item>(
      chopper.Response response) {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    final jsonRes = super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
        body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType);
  }
}

final $jsonDecoder = $CustomJsonDecoder(scanServerApiJsonDecoderMappings);

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}
