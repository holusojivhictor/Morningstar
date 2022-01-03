import 'package:http/http.dart' as http;
import 'package:morningstar/domain/services/changelog_provider.dart';
import 'package:morningstar/domain/services/network_service.dart';

const _defaultChangelog = '''
### Changelog
#### N/A
''';

const _url = 'https://raw.githubusercontent.com/holusojivhictor/Morningstar/main/Changelog.md';

class ChangelogProviderImpl implements ChangelogProvider {
  final NetworkService _networkService;

  ChangelogProviderImpl(this._networkService);

  @override
  Future<String> load() async {
    try {
      if (!await _networkService.isInternetAvailable()) {
        return _defaultChangelog;
      }
      final response = await http.Client().get(Uri.parse(_url));
      if (response.statusCode != 200) {
        return _defaultChangelog;
      }

      return response.body;
    } catch (e) {
      return _defaultChangelog;
    }
  }
}