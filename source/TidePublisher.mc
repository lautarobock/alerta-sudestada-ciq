import Toybox.Complications;
import Toybox.Lang;

// Publishes the latest height so a watch-face slot can show it.
(:glance)
class TidePublisher {
    static const ID as Number = 0;

    static function publishStored() as Void {
        var data = TideStore.load();
        if (data == null) {
            return;
        }
        var height = TideFormat.toFloat(TideFormat.valueAt(data, "h"));
        if (height == null) {
            return;
        }
        try {
            Complications.updateComplication(ID, {
                :value => height.format("%.2f"),
                :unit => "m"
            });
        } catch (ex) {
        }
    }
}
