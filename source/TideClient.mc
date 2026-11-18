import Toybox.Communications;
import Toybox.Lang;
import Toybox.WatchUi;

(:glance)
class TideClient {
    var loading as Boolean;
    var lastError as String or Null;
    private var _busy as Boolean;

    function initialize() {
        loading = false;
        lastError = null;
        _busy = false;
    }

    function fetch() as Void {
        if (_busy) {
            return;
        }
        _busy = true;
        loading = true;
        lastError = null;
        WatchUi.requestUpdate();

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        try {
            Communications.makeWebRequest(watchUrl(), null, options, method(:onReceive));
        } catch (ex) {
            _busy = false;
            loading = false;
            lastError = "Sin conexión";
            WatchUi.requestUpdate();
        }
    }

    function onReceive(responseCode as Number, data as Dictionary or String or Null) as Void {
        _busy = false;
        loading = false;
        if (responseCode == 200 && data instanceof Dictionary) {
            var normalized = TideFormat.normalize(data as Dictionary);
            if (normalized["h"] != null) {
                TideStore.save(normalized);
                TidePublisher.publishStored();
                lastError = null;
            } else {
                lastError = "Sin datos";
            }
        } else if (responseCode == 503) {
            lastError = "Sin datos";
        } else {
            lastError = "Sin conexión";
        }
        WatchUi.requestUpdate();
    }
}
