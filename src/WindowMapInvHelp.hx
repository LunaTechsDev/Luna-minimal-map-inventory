import rm.windows.Window_Base;
import rm.core.Rectangle;

using WindowExtensions;

@:keep
@:native('WindowMapInvHelp')
@:expose('WindowMapInvHelp')
class WindowMapInvHelp extends Window_Base {
  public var _helpText: String;

  public function new(x: Int, y: Int, width: Int, height: Int) {
    #if compileMV
    super(x, y, width, height);
    #else
    var rect = new Rectangle(x, y, width, height);
    super(rect);
    #end
    this._helpText = '';
  }

  public function setHelpText(text: String) {
    this._helpText = text;
    this.refresh();
  }

  public function refresh() {
    if (this.contents != null) {
      this.contents.clear();
      this.paintHelpText();
    }
  }

  public function paintHelpText() {
    #if compileMV
    this.drawTextEx(this._helpText, 0, 0);
    #else
    this.drawTextEx(this._helpText, 0, 0, this.contentsWidth());
    #end
  }

  public override function update() {
    super.update();
    // this.processVisible();
  }

  public function processVisible() {
    if (this._helpText.length > 0 && !this.isOpenOrVisible()) {
      this.show();
      this.open();
    } else {
      this.close();
      this.hide();
    }
  }
}
