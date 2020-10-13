import rm.managers.DataManager;
import rm.core.Graphics;
import rm.core.TouchInput;
import rm.types.RPG.EquipItem;
import rm.Globals;
import rm.scenes.Scene_Map as RmScene_Map;

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
  }

  public function createMapInvWindow() {
    var centerX = Graphics.width / 2;
    trace(centerX);
    var width = 400;
    this._lmmInventoryWindow = new WindowMapInventory(cast centerX - width / 2, 300, width, 75);
    this.addWindow(this._lmmInventoryWindow);
    this._lmmInventoryWindow.hide();
  }

  public function createMapInvHelpWindow() {
    this._lmmInventoryHelpWindow = new WindowMapInvHelp(0, 0, 200, 200);
    this.addWindow(this._lmmInventoryHelpWindow);
    this._lmmInventoryHelpWindow.hide();
  }

  public function createMapInvConfirmWindow() {
    this._lmmInventoryConfirmWindow = new WindowMapInvConfirm(0, 0, 200, 200);
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
    // Shouldn't happen
    if (currentItem != null) {
      switch (currentItem) {
        case DataManager.isItem(_) => true:
          Globals.GameParty.members()[0].useItem(cast currentItem);
        case DataManager.isArmor(_) || DataManager.isWeapon(_) => true:
          var equipItem: EquipItem = cast currentItem;
          Globals.GameParty.members()[0].changeEquip(equipItem.etypeId, equipItem);
        case _:
          // Do nothing
      }
    }

    this.closeConfirmWindow();
  }

  public function cancelItemUse() {
    this.closeConfirmWindow();
  }

  public function closeConfirmWindow() {
    this._lmmInventoryConfirmWindow.deactivate();
    this._lmmInventoryConfirmWindow.close();
    this._lmmInventoryConfirmWindow.hide();
  }

  public override function update() {
    // super.update();
    untyped _Scene_Map_update.call(this);
    this.processMMInventory();
  }

  public function processMMInventory() {
    // Inventory Window Hovered Over Item
    var item = this._lmmInventoryWindow.getHoveredItem(cast TouchInput.x, cast TouchInput.y);
    if (item != null) {
      trace('Found Item', item.description);
      this._lmmInventoryHelpWindow.setHelpText(item.description);
      this._lmmInventoryHelpWindow.show();
      this._lmmInventoryHelpWindow.open();
    } else {
      this._lmmInventoryHelpWindow.close();
    }
  }
}
