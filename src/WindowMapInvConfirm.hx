import rm.windows.Window_HorzCommand;
import rm.core.Rectangle;
import rm.windows.Window_Command;

@:keep
@:native('WindowMapInvConfirm')
@:expose('WindowMapInvConfirm')
class WindowMapInvConfirm extends Window_HorzCommand {
  public function new(x: Int, y: Int, width: Int, height: Int) {
    #if compileMV
    super(x, y);
    #else
    var rect = new Rectangle(x, y, width, height);
    super(rect);
    #end
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
