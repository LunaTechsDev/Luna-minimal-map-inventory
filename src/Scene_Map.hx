import rm.scenes.Scene_Map as RmScene_Map;

// TODO: Update Game_Player to not move when inv open
class Scene_Map extends RmScene_Map {
  public override function createAllWindows() {
    super.createAllWindows();
    this.createMapInvWindow();
    this.createMapInvHelpWindow();
    this.createMapInvConfirmWindow();
  }

  public function createMapInvWindow() {}

  public function createMapInvHelpWindow() {}

  public function createMapInvConfirmWindow() {}
}
