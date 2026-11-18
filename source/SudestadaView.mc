import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class SudestadaView extends WatchUi.View {
    private var _client as TideClient;

    function initialize() {
        View.initialize();
        _client = new TideClient();
    }

    function onLayout(dc as Graphics.Dc) as Void {
        setLayout(Rez.Layouts.WatchLayout(dc));
    }

    function onShow() as Void {
        _client.fetch();
    }

    function refresh() as Void {
        _client.fetch();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        render(dc);
        View.onUpdate(dc);
    }

    private function render(dc as Graphics.Dc) as Void {
        var loc = "";
        var heightText = "--";
        var statusText = "Sin datos";
        var statusColor = Graphics.COLOR_WHITE;
        var nextText = "";
        var peakText = "";
        var peakColor = Graphics.COLOR_WHITE;
        var ageText = "";
        var data = TideStore.load();

        if (data != null) {
            var height = TideFormat.toFloat(TideFormat.valueAt(data, "h"));
            var status = data["s"];
            var place = data["loc"];
            if (place instanceof String) {
                loc = place as String;
            }
            if (height != null) {
                heightText = TideFormat.meters(height);
            }
            if (status instanceof String) {
                statusText = TideFormat.statusLabel(status as String);
                statusColor = TideFormat.statusColor(status as String);
                if (height != null) {
                    statusText += TideFormat.trend(height, TideFormat.toFloat(TideFormat.valueAt(data, "prev")));
                }
            }
            var ts = TideFormat.toNumber(TideFormat.valueAt(data, "ts"));
            if (ts != null) {
                ageText = TideFormat.age(ts);
            }
            nextText = fit(dc, eventLine(TideFormat.child(data, "next"), false));
            peakText = fit(dc, eventLine(TideFormat.child(data, "peak"), true));
            var peak = TideFormat.child(data, "peak");
            if (peak != null) {
                var peakStatus = peak["s"];
                if (peakStatus instanceof String) {
                    peakColor = TideFormat.statusColor(peakStatus as String);
                }
            }
        } else if (_client.loading) {
            statusText = "Cargando";
        } else if (_client.lastError != null) {
            statusText = _client.lastError as String;
        }

        setLabel("loc", loc, Graphics.COLOR_LT_GRAY);
        setLabel("height", heightText, Graphics.COLOR_WHITE);
        setLabel("status", statusText, statusColor);
        setLabel("next", nextText, Graphics.COLOR_WHITE);
        setLabel("peak", peakText, peakColor);
        setLabel("age", ageText, Graphics.COLOR_LT_GRAY);
    }

    private function eventLine(event as Dictionary or Null, isPeak as Boolean) as String {
        if (event == null) {
            return "";
        }
        var value = TideFormat.toFloat(TideFormat.valueAt(event, "v"));
        var ts = TideFormat.toNumber(TideFormat.valueAt(event, "ts"));
        if (value == null || ts == null) {
            return "";
        }
        if (isPeak) {
            var peakStatus = event["s"];
            if (!(peakStatus instanceof String) || (peakStatus as String).equals("normal")) {
                return "";
            }
            return "Pico " + TideFormat.clock(ts) + "  " + TideFormat.meters(value);
        }
        var mode = event["mode"];
        var label = "Pleamar";
        if (mode instanceof String) {
            label = TideFormat.eventLabel(mode as String);
        }
        return label + " " + TideFormat.clock(ts) + "  " + TideFormat.meters(value);
    }

    private function fit(dc as Graphics.Dc, text as String) as String {
        if (text.length() == 0) {
            return text;
        }
        var font = Graphics.FONT_TINY;
        if (dc.getWidth() <= 390) {
            font = Graphics.FONT_XTINY;
        }
        var limit = dc.getWidth() - 70;
        if (dc.getTextWidthInPixels(text, font) <= limit) {
            return text;
        }
        var cut = text.find("  ");
        if (cut != null && cut > 0) {
            var shortened = text.substring(0, cut);
            if (shortened != null) {
                return shortened;
            }
        }
        return text;
    }

    private function setLabel(id as String, text as String, color as Number) as Void {
        var drawable = View.findDrawableById(id);
        if (drawable instanceof WatchUi.Text) {
            var label = drawable as WatchUi.Text;
            label.setText(text);
            label.setColor(color);
        }
    }
}
