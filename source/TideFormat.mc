import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

(:glance)
class TideFormat {
    static function valueAt(data as Dictionary, key as String) as Object or Null {
        return data[key] as Object or Null;
    }

    static function toFloat(value as Object or Null) as Float or Null {
        if (value instanceof Float) {
            return value as Float;
        }
        if (value instanceof Number) {
            return (value as Number).toFloat();
        }
        if (value instanceof Long) {
            return (value as Long).toNumber().toFloat();
        }
        return null;
    }

    static function toNumber(value as Object or Null) as Number or Null {
        if (value instanceof Number) {
            return value as Number;
        }
        if (value instanceof Long) {
            return (value as Long).toNumber();
        }
        if (value instanceof Float) {
            return (value as Float).toNumber();
        }
        return null;
    }

    static function child(data as Dictionary, key as String) as Dictionary or Null {
        var value = data[key];
        if (value instanceof Dictionary) {
            return value as Dictionary;
        }
        return null;
    }

    static function meters(height as Float) as String {
        return height.format("%.2f") + " m";
    }

    static function statusLabel(status as String) as String {
        if (status.equals("warning")) {
            return "Advertencia";
        }
        if (status.equals("alert")) {
            return "Alerta";
        }
        if (status.equals("critical")) {
            return "Crítico";
        }
        if (status.equals("normal")) {
            return "Normal";
        }
        return "";
    }

    static function statusColor(status as String) as Number {
        if (status.equals("warning")) {
            return Graphics.COLOR_YELLOW;
        }
        if (status.equals("alert")) {
            return 0xFF6D00;
        }
        if (status.equals("critical")) {
            return Graphics.COLOR_RED;
        }
        if (status.equals("normal")) {
            return Graphics.COLOR_DK_GREEN;
        }
        return Graphics.COLOR_WHITE;
    }

    static function trend(height as Float, prev as Float or Null) as String {
        if (prev == null) {
            return "";
        }
        var delta = height - prev;
        if (delta > 0.005) {
            return " +";
        }
        if (delta < -0.005) {
            return " -";
        }
        return "";
    }

    static function clock(ts as Number) as String {
        var info = Gregorian.info(new Time.Moment(ts), Time.FORMAT_SHORT);
        var hour = info.hour;
        var minute = info.min;
        if (hour == null || minute == null) {
            return "--:--";
        }
        return (hour as Number).format("%02d") + ":" + (minute as Number).format("%02d");
    }

    static function age(ts as Number) as String {
        var delta = Time.now().value() - ts;
        if (delta < 60) {
            return "ahora";
        }
        var mins = delta / 60;
        if (mins < 180) {
            return "hace " + mins.toString() + " min";
        }
        return "hace " + (mins / 60).toString() + " h";
    }

    static function eventLabel(mode as String) as String {
        if (mode.equals("low")) {
            return "Bajamar";
        }
        return "Pleamar";
    }

    static function normalize(data as Dictionary) as Dictionary {
        var out = {} as Dictionary;
        var height = toFloat(valueAt(data, "h"));
        if (height != null) {
            out["h"] = height;
        }
        var prev = toFloat(valueAt(data, "prev"));
        if (prev != null) {
            out["prev"] = prev;
        }
        var status = data["s"];
        if (status instanceof String) {
            out["s"] = status;
        }
        var ts = toNumber(valueAt(data, "ts"));
        if (ts != null) {
            out["ts"] = ts;
        }
        var loc = data["loc"];
        if (loc instanceof String) {
            out["loc"] = loc;
        }

        var next = child(data, "next");
        if (next != null) {
            var mode = next["mode"];
            var nextValue = toFloat(valueAt(next, "v"));
            var nextTs = toNumber(valueAt(next, "ts"));
            if ((mode instanceof String) && (mode.equals("high") || mode.equals("low")) && nextValue != null && nextTs != null) {
                out["next"] = {
                    "mode" => mode,
                    "v" => nextValue,
                    "ts" => nextTs
                };
            }
        }

        var peak = child(data, "peak");
        if (peak != null) {
            var peakValue = toFloat(valueAt(peak, "v"));
            var peakTs = toNumber(valueAt(peak, "ts"));
            var peakStatus = peak["s"];
            if (peakValue != null && peakTs != null && peakStatus instanceof String) {
                out["peak"] = {
                    "v" => peakValue,
                    "ts" => peakTs,
                    "s" => peakStatus
                };
            }
        }

        return out;
    }
}
