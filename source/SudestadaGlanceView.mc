import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

(:glance)
class SudestadaGlanceView extends WatchUi.GlanceView {
    private var _client as TideClient;
    private var _started as Boolean;

    function initialize() {
        GlanceView.initialize();
        _client = new TideClient();
        _started = false;
    }

    function onLayout(dc as Graphics.Dc) as Void {
        if (!_started) {
            _started = true;
            _client.fetch();
        }
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var line1 = "Sin datos";
        var line2 = "";
        var color = Graphics.COLOR_WHITE;
        var data = TideStore.load();

        if (data != null) {
            var height = TideFormat.toFloat(TideFormat.valueAt(data, "h"));
            var status = data["s"];
            if (height != null) {
                line1 = TideFormat.meters(height);
            }
            if (status instanceof String) {
                line2 = TideFormat.statusLabel(status as String);
                color = TideFormat.statusColor(status as String);
            }
        } else if (_client.loading) {
            line1 = "Cargando";
        } else if (_client.lastError != null) {
            line1 = _client.lastError as String;
        }

        var glanceFont = Graphics.FONT_GLANCE;
        var lineHeight = dc.getFontHeight(glanceFont);
        var y = (dc.getHeight() - (lineHeight * 2)) / 2;
        if (y < 0) {
            y = 0;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        if (dc.getHeight() < lineHeight * 2 || line2.length() == 0) {
            dc.drawText(0, 0, glanceFont, line1, Graphics.TEXT_JUSTIFY_LEFT);
        } else {
            dc.drawText(0, y, Graphics.FONT_GLANCE_NUMBER, line1, Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(0, y + lineHeight, glanceFont, line2, Graphics.TEXT_JUSTIFY_LEFT);
        }
    }
}
