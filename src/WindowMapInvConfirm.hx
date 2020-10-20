import rm.windows.Window_HorzCommand;
import rm.core.Rectangle;

@:keep
@:native('WindowMapInvConfirm')
@:expose('WindowMapInvConfirm')
class WindowMapInvConfirm extends Window_HorzCommand {
  public var _offsetY: Float;

  public function new(x: Int, y: Int, width: Int, height: Int) {
    #if compileMV
    super(x, y);
    #else
    var rect = new Rectangle(x, y, width, height);
    super(rect);
    #end
    this._offsetY = 48.0;
  }

  #if compileMV
  public override function refresh() {
    if (this.contents != null) {
      this.contents.clear();
      untyped this.contentsBack.clear();
      this.paintTitle(0, 0);
      this.drawAllItems();
    }
  }
  #else
  public override function paint() {
    if (this.contents != null) {
      this.contents.clear();
      untyped this.contentsBack.clear();
      this.paintTitle(0, 0);
      this.drawAllItems();
    }
  }
  #end

  public override function itemRect(index: Int): Rectangle {
    var rect = super.itemRect(index);

    if (this._offsetY > 0) {
      rect.y += this._offsetY;
    }
    return rect;
  }

  public function paintTitle(x: Int, y: Int) {
    this.contents.fillRect(x, y, this.contentsWidth(), 40, 'rgba(0, 0, 0, 0.5)');
    this.drawText('Use Item?', x, y, this.contentsWidth(), 'center');
  }

  public override function maxCols(): Int {
    return 2;
  }

  public override function makeCommandList() {
    super.makeCommandList();
    this.addCommand('Yes', 'yes', true);
    this.addCommand('No', 'no', true);
  }
}
