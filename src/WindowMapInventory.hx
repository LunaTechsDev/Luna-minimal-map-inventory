import rm.objects.Game_Item;
import rm.abstracts.objects.GameItem;
import rm.windows.Window_Base;
import rm.core.Rectangle;

using Lambda;

// TODO: Add Hover Functionality
@:keep
@:native('WindowMapInventory')
@:expose('WindowMapInventory')
class WindowMapInventory extends Window_Base {
  public var _items: Array<Game_Item>;
  public var _selectionIndex: Int;
  public var page: Int;
  public var _maxPageItems: Int;
  public var cellWidth: Int;
  public var cellHeight: Int;

  public function new(x: Int, y: Int, width: Int, height: Int) {
    #if compileMV
    super(x, y, width, height);
    #else
    var rect = new Rectangle(x, y, width, height);
    super(rect);
    #end
  }

  public function refresh() {
    if (this.contents != null) {
      this.contents.clear();
      this.paintAllItems();
    }
  }

  public function paintAllItems() {
    var startIndex = this.page * this._maxPageItems;
    var endIndex = (this.page * this._maxPageItems) + this._maxPageItems;
    for (index in startIndex...(endIndex - 1)) {
      this.paintItem(index);
    }
  }

  public function paintItem(index: Int) {
    var rect = this.itemRectForCell(index);
    this.paintCell(rect);
    this.paintCellItemIcon(rect, index);
  }

  public function paintCell(rect: Rectangle) {
    // Draw Cell Background
    // TODO: Update Bitmap to allow for drawing rectangles
    // TODO: Update drawIcon to accept Integer
    this.drawRect(rect.x, rect.y, rect.width, rect.height);
  }

  public function paintCellItemIcon(rect: Rectangle, index) {
    // Draw Cell Icon
    var item = this._items[index];
    // Update to draw Icon of any size
    this.drawIcon(item.object().iconIndex, rect.x, rect.y);
  }

  public function itemRectForCell(index: Int) {
    // Handles properly positioning the cells based on index
    var internalIndex = index % this._maxPageItems;
    var x = this.cellWidth * internalIndex;
    trace('X Position ${x}');
    // Don't need to calculate y since row max is always 1
    var rectangle = new Rectangle(x, 0, this.cellWidth, this.cellHeight);
    return rectangle;
  }
}
