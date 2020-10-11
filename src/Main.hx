import rm.core.JsonEx;
import macros.FnMacros;
import rm.scenes.Scene_Map as RmScene_Map;
import js.Syntax;
import pixi.interaction.EventEmitter;
import core.Amaryllis;
import utils.Comment;
import utils.Fn;
import rm.Globals;

using Lambda;
using core.StringExtensions;
using core.NumberExtensions;
using StringTools;
using utils.Fn;

typedef LParams = {}

@:native('LunaMMInventory')
@:expose('LunaMMInventory')
class Main {
  public static var Params: LParams = null;
  public static var listener: EventEmitter = Amaryllis.createEventEmitter();

  public static function main() {
    var plugin = Globals.Plugins.filter((plugin) -> ~/<LunaLinks>/ig.match(plugin.description))[0];
    var params = plugin.parameters;
    untyped Params = {
      linkWindows: JsonEx.parse(params['linkWindows']).map((win) -> JsonEx.parse(win))
    }
    trace(Params);

    Comment.title('Scene_Map');
    FnMacros.jsPatch(true, RmScene_Map, Scene_Map);
  }

  public static function params() {
    return Params;
  }
}
