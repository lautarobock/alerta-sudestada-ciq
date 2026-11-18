import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class SudestadaApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    (:typecheck(disableGlanceCheck))
    function onStart(state as Dictionary or Null) as Void {
    }

    (:typecheck(disableGlanceCheck))
    function onStop(state as Dictionary or Null) as Void {
    }

    (:typecheck(disableGlanceCheck))
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new SudestadaView();
        return [view, new SudestadaDelegate(view)];
    }

    function getGlanceView() as [GlanceView] or [GlanceView, GlanceViewDelegate] or Null {
        return [new SudestadaGlanceView()];
    }
}
