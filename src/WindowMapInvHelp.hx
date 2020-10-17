import rm.types.RM.TextState;
import rm.windows.Window_Base;
import rm.core.Rectangle;

using WindowExtensions;
using StringTools;

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

  #if compileMV
  // TODO: Do MV implementation later
  public override function drawTextEx(text: String, x: Float, y: Float): Float {
    untyped ({
      if (text) {
        var textState = {
          index: 0,
          x: x,
          y: y,
          left: x,
          text: '',
          height: 0
        };
        textState.text = this.convertEscapeCharacters(text);
        textState.height = cast this.calcTextHeight(cast textState, false);
        this.resetFontSettings();
        while (textState.index < textState.text.length) {
          var textUpToIndex = textState.text.substring(0, textState.index);
          if (untyped textWidth(textUpToIndex) > this.contentsWidth() && textUpToIndex.charAt(textState.index) != '\n') {
            // Insert Manual Line Break
            textState.text = textUpToIndex
              + '\n'
              + textState.text.substring(textState.index, textState.text.length - 1);
            trace(textState.text);
          }
          this.processCharacter(cast textState);
        }
        return textState.x - x;
      } else {
        return 0;
      }
    });
  }
  #else
  // public override function drawTextEx(text: String, x: Float, y: Float, width: Float): Float {
  //   return 0;
  // }
  #end
  #if !compileMV
  public override function processAllText(textState: TextState) {
    while (textState.index < textState.text.length) {
      var currentLines = textState.text.substring(0, textState.index + 1).split('\n');
      var latestLine = currentLines[currentLines.length - 1];
      var textUpToIndex = latestLine.substring(0, latestLine.length);
      if (untyped textWidth(textUpToIndex) > this.contentsWidth()) {
        // Insert Manual Line Break
        var textWithBreak = textState.text.substring(0, textState.index);
        textState.text = textWithBreak + '\n' + textState.text.substring(textState.index, textState.text.length - 1);
        trace(textState.text);
      }
      this.processCharacter(textState);
    }
    this.flushTextState(textState);
  }
  #end

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
    this.contents.fontSize = Main.Params.helpFontSize;
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
