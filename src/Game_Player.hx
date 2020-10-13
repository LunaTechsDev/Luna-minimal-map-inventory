import rm.objects.Game_Player as RmGame_Player;

class Game_Player extends RmGame_Player {
  public override function canMove(): Bool {
    if (Main.isInventoryOpen()) {
      return false;
    } else {
      return untyped _Game_Player_canMove.call(this);
    }
  }
}
