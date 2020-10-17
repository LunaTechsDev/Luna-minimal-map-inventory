import rm.core.TouchInput;
import rm.core.Input;
import js.html.SelectElement;
import Types.InvEvents;
import rm.managers.ImageManager;
import rm.types.RPG.BaseItem;
import rm.objects.Game_Item;
import rm.abstracts.objects.GameItem;
import rm.windows.Window_Base;
import rm.core.Rectangle;

using Lambda;
using core.NumberExtensions;
using WindowExtensions;

// TODO: Add Hover Functionality
@:keep
@:native('WindowMapInventory')
@:expose('WindowMapInventory')
class WindowMapInventory extends Window_Base {
  public var _items: Array<BaseItem>;
  public var _selectionIndex: Int;
  public var page: Int;
  public var _maxPageItems: Int;
  public var cellWidth: Int;
  public var cellHeight: Int;
  public var borderSize: Int;
  public var horizontalSpacing: Int;

  public function new(x: Int, y: Int, width: Int, height: Int) {
    #if compileMV
    super(x, y, width, height);
    #else
    var rect = new Rectangle(x, y, width, height);
    super(rect);
    #end
    this._items = [];
    this._selectionIndex = -1;
    this.page = 0;
    this._maxPageItems = Main.Params.maxPageItems;
    this.cellWidth = 48;
    this.cellHeight = 48;
    this.borderSize = 2;
    this.horizontalSpacing = 4;
    this.setupEvents();
  }

  public function setupEvents() {
    this.on(InvEvents.SELECTITEM, (index: Int) -> {
      this._selectionIndex = index;
      var rect = this.itemRectForCell(index);
      this.setCursorRect(rect.x, rect.y, rect.width, rect.height);
    });
  }

  public override function drawIcon(iconIndex: Float, x: Float, y: Float) {
    var bitmap = ImageManager.loadSystem("IconSet");
    #if compileMV
    var pw = Window_Base._iconWidth;
    var ph = Window_Base._iconHeight;
    #else
    var pw = ImageManager.iconWidth;
    var ph = ImageManager.iconHeight;
    #end
    var sx = (iconIndex % 16) * pw;
    var sy = Math.floor(iconIndex / 16) * ph;
    this.contents.blt(
      bitmap,
      sx,
      sy,
      pw,
      ph,
      x,
      y,
      this.cellWidth - this.borderSize * 4,
      this.cellHeight - this.borderSize * 4
    );
  }

  public function setItems(items: Array<BaseItem>) {
    this._items = items;
    this.refresh();
  }

  // Will need to add meta data around item
  public function currentItem(): BaseItem {
    return this._items[this._selectionIndex];
  }

  public function refresh() {
    if (this.contents != null) {
      trace('Paint All Items');
      this.contents.clear();
      this.paintAllItems();
    }
  }

  public function paintAllItems() {
    var startIndex = this.page * this._maxPageItems;
    var endIndex = (this.page * this._maxPageItems) + this._maxPageItems;

    for (index in startIndex...endIndex) {
      this.paintItem(index);
    }
  }

  public function paintItem(index: Int) {
    var rect = this.itemRectForCell(index);
    // trace(rect.x, rect.y, rect.width, rect.height);
    this.paintCell(rect);
    this.paintCellItemIcon(rect, index);
  }

  public function paintCell(rect: Rectangle) {
    // Draw Cell Background
    // TODO: Update Bitmap to allow for drawing rectangles
    // TODO: Update drawIcon to accept Integer

    this.contents.fillRect(rect.x, rect.y, rect.width, rect.height, 'white');
    this.contents.clearRect(rect.x
      + this.borderSize, rect.y
      + this.borderSize, rect.width
      - this.borderSize * 2, rect.height
      - this.borderSize * 2);
  }

  public function paintCellItemIcon(rect: Rectangle, index) {
    // Draw Cell Icon
    var item = this._items[index];
    // Update to draw Icon of any size
    if (item != null) {
      this.drawIcon(item.iconIndex, rect.x + this.borderSize * 2, rect.y + this.borderSize * 2);
    }
  }

  public function itemRectForCell(index: Int) {
    // Handles properly positioning the cells based on index
    var internalIndex = index % this._maxPageItems;
    var spacing = (this.horizontalSpacing * internalIndex); // clamp(0, this.horizontalSpacing);
    // trace(spacing);
    var x = this.cellWidth * internalIndex;
    // trace('X Position ${x}');
    // Don't need to calculate y since row max is always 1
    var rectangle = new Rectangle(x + spacing, 0, this.cellWidth, this.cellHeight);
    return rectangle;
  }

  public function getCurrentItem(index) {
    var item = null;
    item = this._items[(this.page * this._maxPageItems) + this._selectionIndex];
    return item;
  }

  // Update Functionality
  public override function update() {
    super.update();
    this.processOkAndCancel();
    this.processSelectionOfItemsKeyboard();
    this.processSelectionOfItemMouse();
  }

  public function processOkAndCancel() {
    switch (Input) {
      case _.isTriggered('ok') => true:
        this.emit(InvEvents.CONFIRMITEM, this.currentItem());
      // TODO: Suppress Menu when  on screen
      case _.isTriggered('cancel') => true:
        this.emit(InvEvents.CANCELITEM);
      case _:
        // Do nothing
    }
  }

  public function processSelectionOfItemsKeyboard() {
    // Handle moving with arrow keys
    switch (Input) {
      case _.isTriggered('right') => true:
        this.emit(InvEvents.SELECTITEM, this._selectionIndex + 1);
      case _.isTriggered('left') && this._selectionIndex > 0 => true:
        this.emit(InvEvents.SELECTITEM, this._selectionIndex - 1);
      case _:
        // Do nothing
    }
  }

  public function processSelectionOfItemMouse() {
    var item = null;
    var pos = this.canvasToLocal(TouchInput.x, TouchInput.y);
    for (index in 0...this._maxPageItems) {
      var internalIndex = index % this._maxPageItems;
      var rect = this.itemRectForCell(index);

      if (pos.x.withinRangef(rect.x, rect.width + rect.x) && pos.y.withinRangef(rect.y, rect.height)) {
        item = this._items[(this.page * this._maxPageItems) + index];
        // Since we found an item for the hovered item, setCursorRect
        this.emit(InvEvents.SELECTITEM, index);
      }
    }
    return item;
  }
}
