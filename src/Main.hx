import rm.core.JsonEx;
import macros.FnMacros;
import rm.scenes.Scene_Map as RmScene_Map;
import rm.objects.Game_Player as RmGame_Player;
import js.Syntax;
import pixi.interaction.EventEmitter;
import core.Amaryllis;
import utils.Comment;
import utils.Fn;
import rm.Globals;

using Lambda;
using core.StringExtensions;
using core.NumberExtensions;
using WindowExtensions;
using StringTools;
using utils.Fn;

typedef LParams = {
  var maxPageItems: Int;
  var helpFontSize: Int;
}

@:native('LunaMMInventory')
@:expose('LunaMMInventory')
class Main {
  public static var Params: LParams = null;
  public static var listener: EventEmitter = Amaryllis.createEventEmitter();

  public static function main() {
    var plugin = Globals.Plugins.filter((plugin) -> ~/<LunaMMI>/ig.match(plugin.description))[0];
    var params = plugin.parameters;
    untyped Params = {
      maxPageItems: Fn.parseIntJs(params['maxPageItems']),
      helpFontSize: Fn.parseIntJs(params['helpFontSize'])
    }
    trace(Params);

    Comment.title('Scene_Map');
    FnMacros.jsPatch(true, RmScene_Map, Scene_Map);

    Comment.title('Game_Player');
    FnMacros.jsPatch(true, RmGame_Player, Game_Player);
  }

  public static function params() {
    return Params;
  }

  public static function getAllItems() {}

  public static function isInventoryOpen() {
    var scene: Scene_Map = Amaryllis.currentScene();
    if (Fn.hasProperty(scene, '_lmmInventoryWindow')) {
      return scene._lmmInventoryWindow.isOpenAndVisible();
    } else {
      return false;
    }
  }

  public static function openInventory() {
    trace('Open minimal inventory');
    var scene: Scene_Map = Amaryllis.currentScene();
    // Get Name From Class Patched
    if (Fn.hasProperty(scene, '_lmmInventoryWindow')) {
      scene._lmmInventoryWindow.setItems(Globals.GameParty.items());
      var len = scene.__spriteset.__characterSprites.length;
      var player = scene.__spriteset.__characterSprites[len - 1];
      var lmmInvWindow = scene._lmmInventoryWindow;
      lmmInvWindow.move(player.x
        + player.width
        - (lmmInvWindow.width / 2), player.y
        - (lmmInvWindow.height * 2), lmmInvWindow.width, lmmInvWindow.height);
      scene._lmmInventoryWindow.show();
      scene._lmmInventoryWindow.open();
    }
  }

  public static function closeInventory() {
    trace('Close minimal inventory');
    var scene: Scene_Map = Amaryllis.currentScene();
    if (Fn.hasProperty(scene, '_lmmInventoryWindow')) {
      scene._lmmInventoryWindow.close();
      scene._lmmInventoryWindow.hide();
    }
  }

  // if(scene.)
}
