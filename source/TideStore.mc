import Toybox.Application.Storage;
import Toybox.Lang;

(:glance)
class TideStore {
    static const KEY as String = "tide";

    static function save(data as Dictionary) as Void {
        Storage.setValue(KEY, data as Storage.ValueType);
    }

    static function load() as Dictionary or Null {
        var value = Storage.getValue(KEY);
        if (value instanceof Dictionary) {
            return value as Dictionary;
        }
        return null;
    }
}
