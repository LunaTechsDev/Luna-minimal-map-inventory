import rm.objects.Game_Action;
import rm.types.RPG.BaseItem;
import Types.InvEvents;
import rm.managers.DataManager;
import rm.core.Graphics;
import rm.core.TouchInput;
import rm.types.RPG.EquipItem;
import rm.Globals;
import rm.scenes.Scene_Map as RmScene_Map;

using Lambda;
using WindowExtensions;

// TODO: Update Game_Player to not move when inv open
class Scene_Map extends RmScene_Map {
  public var _lmmInventoryWindow: WindowMapInventory;
  public var _lmmInventoryHelpWindow: WindowMapInvHelp;
  public var _lmmInventoryConfirmWindow: WindowMapInvConfirm;

  public override function createAllWindows() {
    // super.createAllWindows();
    untyped _Scene_Map_createAllWindows.call(this);
    this.createMapInvWindow();
    this.createMapInvHelpWindow();
    this.createMapInvConfirmWindow();
    this.setupMMInventoryEvents();
  }

  public function createMapInvWindow() {
    // Last Character in the character spritesets is the
    // player party leader
    var centerX = Graphics.width / 2;
    trace(centerX);
    var width = 400;
    var height = 75;
    this._lmmInventoryWindow = new WindowMapInventory(cast centerX, 300, width, height);

    // player.addChild(this._lmmInventoryWindow);
    this.addWindow(this._lmmInventoryWindow);
    this._lmmInventoryWindow.hide();
  }

  public function createMapInvHelpWindow() {
    var invWindow = this._lmmInventoryWindow;
    var width = 200;
    this._lmmInventoryHelpWindow = new WindowMapInvHelp(cast invWindow.x - width, cast invWindow.y, width, 200);
    this.addWindow(this._lmmInventoryHelpWindow);
    this._lmmInventoryHelpWindow.hide();
  }

  public function createMapInvConfirmWindow() {
    this._lmmInventoryConfirmWindow = new WindowMapInvConfirm(0, 0, 200, 125);
    this.setConfirmWindowHandlers();
    this.addWindow(this._lmmInventoryConfirmWindow);
    this._lmmInventoryConfirmWindow.hide();
  }

  public function setConfirmWindowHandlers() {
    this._lmmInventoryConfirmWindow.setHandler('yes', confirmItemUse);
    this._lmmInventoryConfirmWindow.setHandler('no', cancelItemUse);
  }

  public function confirmItemUse() {
    // Use current item
    var currentItem = this._lmmInventoryWindow.currentItem();

    if (currentItem != null) {
      var mainActor = Globals.GameParty.members()[0];
      switch (currentItem) {
        case DataManager.isItem(_) => true:
          // TODO: Turn this into an extension function
          mainActor.useItem(cast currentItem);
          var action = new Game_Action(mainActor, false);
          action.setItemObject(cast currentItem);
          trace(this.myItemTarget(mainActor, cast currentItem));
          action.apply(cast this.myItemTarget(mainActor, cast currentItem)[0]);
          action.applyGlobal();
        case DataManager.isArmor(_) || DataManager.isWeapon(_) => true:
          var equipItem: EquipItem = cast currentItem;
          Globals.GameParty.members()[0].changeEquip(equipItem.etypeId, equipItem);
        case _:
          // Do nothing
      }
    }

    this.closeMMInvWindow();
    this.closeMMConfirmWindow();
  }

  public function myItemTarget(user, item) {
    var action = new Game_Action(user, false);
    action.setItemObject(item);
    if (!action.isForFriend()) {
      return [];
    } else if (action.isForAll()) {
      var result = Globals.GameParty.members();
      return result;
    } else {
      var result = [Globals.GameParty.members()[0]];
      return result;
    }
  }

  public function cancelItemUse() {
    this._lmmInventoryWindow.activate();
    this.closeMMConfirmWindow();
  }

  public function closeMMInvWindow() {
    this._lmmInventoryWindow.close();
    this._lmmInventoryWindow.deactivate();
    this._lmmInventoryWindow.hide();
  }

  public function closeMMConfirmWindow() {
    this._lmmInventoryConfirmWindow.deactivate();
    this._lmmInventoryConfirmWindow.close();
    this._lmmInventoryConfirmWindow.hide();
  }

  public override function update() {
    untyped _Scene_Map_update.call(this);
    this.processMMInventory();
  }

  public function processMMInventory() {
    // Inventory Window Hovered Over Item

    var item = this._lmmInventoryWindow.currentItem();
    if (item != null && this._lmmInventoryWindow.isOpen()) {
      // trace('Found Item', item.description);
      this.processMMHelpWindow(item);
    } else {
      this._lmmInventoryHelpWindow.close();
    }
  }

  public function processMMHelpWindow(item: BaseItem) {
    var width = this._lmmInventoryHelpWindow.width;
    var invWindow = this._lmmInventoryWindow;
    this._lmmInventoryHelpWindow.setNameText(item.name);
    this._lmmInventoryHelpWindow.setHelpText(item.description);
    this._lmmInventoryHelpWindow.move(cast invWindow.x - width, cast invWindow.y, width, 200);
    this._lmmInventoryHelpWindow.show();
    this._lmmInventoryHelpWindow.open();
  }

  public function setupMMInventoryEvents() {
    this._lmmInventoryWindow.on(InvEvents.CANCELITEM, (_) -> {
      this._lmmInventoryConfirmWindow.close();
      this._lmmInventoryHelpWindow.close();
      this._lmmInventoryWindow.deactivate();
      this._lmmInventoryWindow.close();
    });

    this._lmmInventoryWindow.on(InvEvents.CONFIRMITEM, (item: BaseItem) -> {
      // Move Window to the proper position
      var invWindow = this._lmmInventoryWindow;

      this._lmmInventoryConfirmWindow.move(invWindow.x, invWindow.y + invWindow.height, this._lmmInventoryConfirmWindow.width, this._lmmInventoryConfirmWindow.height);
      this._lmmInventoryWindow.deactivate();
      this._lmmInventoryConfirmWindow.activate();
      this._lmmInventoryConfirmWindow.show();
      this._lmmInventoryConfirmWindow.open();
      this._lmmInventoryConfirmWindow.refresh();
    });
  }

  /**
   * ==== SceneMap Updates ====
   */
  public override function isMenuEnabled(): Bool {
    if (this._lmmInventoryWindow.isOpen()) {
      return false;
    } else {
      return untyped _Scene_Map_isMenuEnabled.call(this);
    }
  }
}
