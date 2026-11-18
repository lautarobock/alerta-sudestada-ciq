import Toybox.Lang;
import Toybox.WatchUi;

class SudestadaDelegate extends WatchUi.BehaviorDelegate {
    private var _view as SudestadaView;

    function initialize(view as SudestadaView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onSelect() as Boolean {
        _view.refresh();
        return true;
    }

    function onMenu() as Boolean {
        _view.refresh();
        return true;
    }
}
