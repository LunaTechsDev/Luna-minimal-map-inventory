//=============================================================================
// Luna_MinimalMapInventory.js
//=============================================================================
//=============================================================================
// Build Date: 2020-10-23 19:31:22
//=============================================================================
//=============================================================================
// Made with LunaTea -- Haxe
//=============================================================================

// Generated by Haxe 4.1.3
/*:
@author LunaTechs - Kino
@plugindesc A plugin that creates a inventory menu on the map scene<LunaMMI>.

@target MV MZ

@param maxPageItems
@text Max Page Items
@desc The maximum numer of page items
@default 8

@param helpFontSize
@text Help Font Size
@desc The help window font size
@default 12

@help

A plugin that creates a inventory menu on the map scene<LunaMMI>.

==== How To Use ====

==== Script Calls ====

Opens the Inventory
LunaMMInventory.openInventory()

Closes the Inventory
LunaMMInventory.closeInventory()

Checks if the Inventory is open
LunaMMInventory.isInventoryOpen()



MIT License
Copyright (c) 2020 LunaTechsDev
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE
*/
(function ($hx_exports, $global) { "use strict"
var $estr = function() { return js_Boot.__string_rec(this,''); },$hxEnums = $hxEnums || {};
class EReg {
	constructor(r,opt) {
		this.r = new RegExp(r,opt.split("u").join(""))
	}
	match(s) {
		if(this.r.global) {
			this.r.lastIndex = 0
		}
		this.r.m = this.r.exec(s)
		this.r.s = s
		return this.r.m != null;
	}
}
EReg.__name__ = true
class Game_$Player extends Game_Player {
	constructor() {
		super();
	}
	canMove() {
		if(LunaMMInventory.isInventoryOpen()) {
			return false;
		} else {
			return _Game_Player_canMove.call(this);
		}
	}
}
Game_$Player.__name__ = true
class LunaMMInventory {
	static main() {
		let _g = []
		let _g1 = 0
		let _g2 = $plugins
		while(_g1 < _g2.length) {
			let v = _g2[_g1]
			++_g1
			if(new EReg("<LunaMMI>","ig").match(v.description)) {
				_g.push(v)
			}
		}
		let plugin = _g[0]
		let params = plugin.parameters
		LunaMMInventory.Params = { maxPageItems : parseInt(params["maxPageItems"],10), helpFontSize : parseInt(params["helpFontSize"],10)}
		console.log("src/Main.hx:37:",LunaMMInventory.Params)
		
//=============================================================================
// Scene_Map
//=============================================================================
      
		let _Scene_Map__lmmInventoryWindow = Scene_Map.prototype._lmmInventoryWindow
		Scene_Map.prototype._lmmInventoryWindow = null
		let _Scene_Map__lmmInventoryHelpWindow = Scene_Map.prototype._lmmInventoryHelpWindow
		Scene_Map.prototype._lmmInventoryHelpWindow = null
		let _Scene_Map__lmmInventoryConfirmWindow = Scene_Map.prototype._lmmInventoryConfirmWindow
		Scene_Map.prototype._lmmInventoryConfirmWindow = null
		let _Scene_Map_createAllWindows = Scene_Map.prototype.createAllWindows
		Scene_Map.prototype.createAllWindows = function() {
			_Scene_Map_createAllWindows.call(this)
			this.createMapInvWindow()
			this.createMapInvHelpWindow()
			this.createMapInvConfirmWindow()
			this.setupMMInventoryEvents()
		}
		let _Scene_Map_createMapInvWindow = Scene_Map.prototype.createMapInvWindow
		Scene_Map.prototype.createMapInvWindow = function() {
			let centerX = Graphics.width / 2
			console.log("src/Scene_Map.hx:32:",centerX)
			let width = 400
			let height = 75
			this._lmmInventoryWindow = new WindowMapInventory(centerX,300,width,height)
			this.addWindow(this._lmmInventoryWindow)
			this._lmmInventoryWindow.hide()
		}
		let _Scene_Map_createMapInvHelpWindow = Scene_Map.prototype.createMapInvHelpWindow
		Scene_Map.prototype.createMapInvHelpWindow = function() {
			let invWindow = this._lmmInventoryWindow
			let width = 200
			this._lmmInventoryHelpWindow = new WindowMapInvHelp(invWindow.x - width,invWindow.y,width,200)
			this.addWindow(this._lmmInventoryHelpWindow)
			this._lmmInventoryHelpWindow.hide()
		}
		let _Scene_Map_createMapInvConfirmWindow = Scene_Map.prototype.createMapInvConfirmWindow
		Scene_Map.prototype.createMapInvConfirmWindow = function() {
			this._lmmInventoryConfirmWindow = new WindowMapInvConfirm(0,0,200,125)
			this.setConfirmWindowHandlers()
			this.addWindow(this._lmmInventoryConfirmWindow)
			this._lmmInventoryConfirmWindow.hide()
		}
		let _Scene_Map_setConfirmWindowHandlers = Scene_Map.prototype.setConfirmWindowHandlers
		Scene_Map.prototype.setConfirmWindowHandlers = function() {
			this._lmmInventoryConfirmWindow.setHandler("yes",$bind(this,this.confirmItemUse))
			this._lmmInventoryConfirmWindow.setHandler("no",$bind(this,this.cancelItemUse))
		}
		let _Scene_Map_confirmItemUse = Scene_Map.prototype.confirmItemUse
		Scene_Map.prototype.confirmItemUse = function() {
			let currentItem = this._lmmInventoryWindow.currentItem()
			if(currentItem != null) {
				let _hx_tmp
				if(DataManager.isItem(currentItem) == true) {
					$gameParty.members()[0].useItem(currentItem)
				} else {
					_hx_tmp = DataManager.isArmor(currentItem) || DataManager.isWeapon(currentItem)
					if(_hx_tmp == true) {
						let equipItem = currentItem
						$gameParty.members()[0].changeEquip(equipItem.etypeId,equipItem)
					}
				}
			}
			this.closeMMInvWindow()
			this.closeMMConfirmWindow()
		}
		let _Scene_Map_cancelItemUse = Scene_Map.prototype.cancelItemUse
		Scene_Map.prototype.cancelItemUse = function() {
			this.closeMMConfirmWindow()
		}
		let _Scene_Map_closeMMInvWindow = Scene_Map.prototype.closeMMInvWindow
		Scene_Map.prototype.closeMMInvWindow = function() {
			this._lmmInventoryWindow.close()
			this._lmmInventoryWindow.deactivate()
			this._lmmInventoryWindow.hide()
		}
		let _Scene_Map_closeMMConfirmWindow = Scene_Map.prototype.closeMMConfirmWindow
		Scene_Map.prototype.closeMMConfirmWindow = function() {
			this._lmmInventoryConfirmWindow.deactivate()
			this._lmmInventoryConfirmWindow.close()
			this._lmmInventoryConfirmWindow.hide()
		}
		let _Scene_Map_update = Scene_Map.prototype.update
		Scene_Map.prototype.update = function() {
			_Scene_Map_update.call(this)
			this.processMMInventory()
		}
		let _Scene_Map_processMMInventory = Scene_Map.prototype.processMMInventory
		Scene_Map.prototype.processMMInventory = function() {
			let item = this._lmmInventoryWindow.currentItem()
			if(item != null && this._lmmInventoryWindow.isOpen()) {
				this.processMMHelpWindow(item)
			} else {
				this._lmmInventoryHelpWindow.close()
			}
		}
		let _Scene_Map_processMMHelpWindow = Scene_Map.prototype.processMMHelpWindow
		Scene_Map.prototype.processMMHelpWindow = function(item) {
			let width = this._lmmInventoryHelpWindow.width
			let invWindow = this._lmmInventoryWindow
			this._lmmInventoryHelpWindow.setNameText(item.name)
			this._lmmInventoryHelpWindow.setHelpText(item.description)
			this._lmmInventoryHelpWindow.move(invWindow.x - width,invWindow.y,width,200)
			this._lmmInventoryHelpWindow.show()
			this._lmmInventoryHelpWindow.open()
		}
		let _Scene_Map_setupMMInventoryEvents = Scene_Map.prototype.setupMMInventoryEvents
		Scene_Map.prototype.setupMMInventoryEvents = function() {
			let _gthis = this
			this._lmmInventoryWindow.on("cancelItem",function(_) {
				_gthis._lmmInventoryConfirmWindow.close()
				_gthis._lmmInventoryHelpWindow.close()
				_gthis._lmmInventoryWindow.deactivate()
				_gthis._lmmInventoryWindow.close()
			})
			this._lmmInventoryWindow.on("confirmItem",function(item) {
				let invWindow = _gthis._lmmInventoryWindow
				_gthis._lmmInventoryConfirmWindow.move(invWindow.x,invWindow.y + invWindow.height,_gthis._lmmInventoryConfirmWindow.width,_gthis._lmmInventoryConfirmWindow.height)
				_gthis._lmmInventoryConfirmWindow.activate()
				_gthis._lmmInventoryConfirmWindow.show()
				_gthis._lmmInventoryConfirmWindow.open()
				_gthis._lmmInventoryConfirmWindow.refresh()
			})
		}
		let _Scene_Map_isMenuEnabled = Scene_Map.prototype.isMenuEnabled
		Scene_Map.prototype.isMenuEnabled = function() {
			if(this._lmmInventoryWindow.isOpen()) {
				return false;
			} else {
				return _Scene_Map_isMenuEnabled.call(this);
			}
		}
		
//=============================================================================
// Game_Player
//=============================================================================
      
		let _Game_Player_canMove = Game_Player.prototype.canMove
		Game_Player.prototype.canMove = function() {
			if(LunaMMInventory.isInventoryOpen()) {
				return false;
			} else {
				return _Game_Player_canMove.call(this);
			}
		}
	}
	static params() {
		return LunaMMInventory.Params;
	}
	static getAllItems() {
	}
	static isInventoryOpen() {
		let scene = SceneManager._scene
		if(scene.hasOwnProperty("_lmmInventoryWindow")) {
			let win = scene._lmmInventoryWindow
			if(win.isOpen()) {
				return win.visible;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}
	static openInventory() {
		console.log("src/Main.hx:62:","Open minimal inventory")
		let scene = SceneManager._scene
		if(scene.hasOwnProperty("_lmmInventoryWindow")) {
			scene._lmmInventoryWindow.setItems($gameParty.items())
			let player = scene._spriteset._characterSprites[scene._spriteset._characterSprites.length - 1]
			let lmmInvWindow = scene._lmmInventoryWindow
			lmmInvWindow.move(player.x + player.width - lmmInvWindow.width / 2,player.y - lmmInvWindow.height * 2,lmmInvWindow.width,lmmInvWindow.height)
			scene._lmmInventoryWindow.activate()
			scene._lmmInventoryWindow.show()
			scene._lmmInventoryWindow.open()
		}
	}
	static closeInventory() {
		console.log("src/Main.hx:81:","Close minimal inventory")
		let scene = SceneManager._scene
		if(scene.hasOwnProperty("_lmmInventoryWindow")) {
			scene._lmmInventoryWindow.deactivate()
			scene._lmmInventoryWindow.close()
			scene._lmmInventoryWindow.hide()
		}
	}
}
$hx_exports["LunaMMInventory"] = LunaMMInventory
LunaMMInventory.__name__ = true
Math.__name__ = true
class Scene_$Map extends Scene_Map {
	constructor() {
		super();
	}
	createAllWindows() {
		_Scene_Map_createAllWindows.call(this)
		this.createMapInvWindow()
		this.createMapInvHelpWindow()
		this.createMapInvConfirmWindow()
		this.setupMMInventoryEvents()
	}
	createMapInvWindow() {
		let centerX = Graphics.width / 2
		console.log("src/Scene_Map.hx:32:",centerX)
		this._lmmInventoryWindow = new WindowMapInventory(centerX,300,400,75)
		this.addWindow(this._lmmInventoryWindow)
		this._lmmInventoryWindow.hide()
	}
	createMapInvHelpWindow() {
		let invWindow = this._lmmInventoryWindow
		this._lmmInventoryHelpWindow = new WindowMapInvHelp(invWindow.x - 200,invWindow.y,200,200)
		this.addWindow(this._lmmInventoryHelpWindow)
		this._lmmInventoryHelpWindow.hide()
	}
	createMapInvConfirmWindow() {
		this._lmmInventoryConfirmWindow = new WindowMapInvConfirm(0,0,200,125)
		this.setConfirmWindowHandlers()
		this.addWindow(this._lmmInventoryConfirmWindow)
		this._lmmInventoryConfirmWindow.hide()
	}
	setConfirmWindowHandlers() {
		this._lmmInventoryConfirmWindow.setHandler("yes",$bind(this,this.confirmItemUse))
		this._lmmInventoryConfirmWindow.setHandler("no",$bind(this,this.cancelItemUse))
	}
	confirmItemUse() {
		let currentItem = this._lmmInventoryWindow.currentItem()
		if(currentItem != null) {
			let _hx_tmp
			if(DataManager.isItem(currentItem) == true) {
				$gameParty.members()[0].useItem(currentItem)
			} else {
				_hx_tmp = DataManager.isArmor(currentItem) || DataManager.isWeapon(currentItem)
				if(_hx_tmp == true) {
					let equipItem = currentItem
					$gameParty.members()[0].changeEquip(equipItem.etypeId,equipItem)
				}
			}
		}
		this.closeMMInvWindow()
		this.closeMMConfirmWindow()
	}
	cancelItemUse() {
		this.closeMMConfirmWindow()
	}
	closeMMInvWindow() {
		this._lmmInventoryWindow.close()
		this._lmmInventoryWindow.deactivate()
		this._lmmInventoryWindow.hide()
	}
	closeMMConfirmWindow() {
		this._lmmInventoryConfirmWindow.deactivate()
		this._lmmInventoryConfirmWindow.close()
		this._lmmInventoryConfirmWindow.hide()
	}
	processMMInventory() {
		let item = this._lmmInventoryWindow.currentItem()
		if(item != null && this._lmmInventoryWindow.isOpen()) {
			this.processMMHelpWindow(item)
		} else {
			this._lmmInventoryHelpWindow.close()
		}
	}
	processMMHelpWindow(item) {
		let width = this._lmmInventoryHelpWindow.width
		let invWindow = this._lmmInventoryWindow
		this._lmmInventoryHelpWindow.setNameText(item.name)
		this._lmmInventoryHelpWindow.setHelpText(item.description)
		this._lmmInventoryHelpWindow.move(invWindow.x - width,invWindow.y,width,200)
		this._lmmInventoryHelpWindow.show()
		this._lmmInventoryHelpWindow.open()
	}
	setupMMInventoryEvents() {
		let _gthis = this
		this._lmmInventoryWindow.on("cancelItem",function(_) {
			_gthis._lmmInventoryConfirmWindow.close()
			_gthis._lmmInventoryHelpWindow.close()
			_gthis._lmmInventoryWindow.deactivate()
			_gthis._lmmInventoryWindow.close()
		})
		this._lmmInventoryWindow.on("confirmItem",function(item) {
			let invWindow = _gthis._lmmInventoryWindow
			_gthis._lmmInventoryConfirmWindow.move(invWindow.x,invWindow.y + invWindow.height,_gthis._lmmInventoryConfirmWindow.width,_gthis._lmmInventoryConfirmWindow.height)
			_gthis._lmmInventoryConfirmWindow.activate()
			_gthis._lmmInventoryConfirmWindow.show()
			_gthis._lmmInventoryConfirmWindow.open()
			_gthis._lmmInventoryConfirmWindow.refresh()
		})
	}
	isMenuEnabled() {
		if(this._lmmInventoryWindow.isOpen()) {
			return false;
		} else {
			return _Scene_Map_isMenuEnabled.call(this);
		}
	}
}
Scene_$Map.__name__ = true
class WindowExtensions {
	static canvasToLocal(win,x,y) {
		let touchPos = new PIXI.Point(x,y)
		return win.worldTransform.applyInverse(touchPos);
	}
}
WindowExtensions.__name__ = true
class WindowMapInvConfirm extends Window_HorzCommand {
	constructor(x,y,width,height) {
		super(new Rectangle(x,y,width,height));
		this._offsetY = 48.0
	}
	paint() {
		if(this.contents != null) {
			this.contents.clear()
			this.contentsBack.clear()
			this.paintTitle(0,0)
			this.drawAllItems()
		}
	}
	itemRect(index) {
		let rect = super.itemRect(index)
		if(this._offsetY > 0) {
			rect.y += this._offsetY;
		}
		return rect;
	}
	paintTitle(x,y) {
		this.contents.fillRect(x,y,this.contentsWidth(),40,"rgba(0, 0, 0, 0.5)")
		this.drawText("Use Item?",x,y,this.contentsWidth(),"center")
	}
	maxCols() {
		return 2;
	}
	makeCommandList() {
		super.makeCommandList()
		this.addCommand("Yes","yes",true)
		this.addCommand("No","no",true)
	}
}
$hx_exports["WindowMapInvConfirm"] = WindowMapInvConfirm
WindowMapInvConfirm.__name__ = true
class WindowMapInvHelp extends Window_Base {
	constructor(x,y,width,height) {
		super(new Rectangle(x,y,width,height));
		this._nameText = ""
		this._helpText = ""
	}
	drawTextEx(text,x,y,width) {
		this.resetFontSettings()
		this.contents.fontSize = LunaMMInventory.Params.helpFontSize
		let textState = this.createTextState(text,x,y,width)
		this.processAllText(textState)
		return textState.outputWidth;
	}
	processAllText(textState) {
		while(textState.index < textState.text.length) {
			let currentLines = textState.text.substring(0,textState.index + 1).split("\n")
			let latestLine = currentLines[currentLines.length - 1]
			let textUpToIndex = latestLine.substring(0,latestLine.length)
			if(this.textWidth(textUpToIndex) > this.contentsWidth()) {
				let textWithBreak = textState.text.substring(0,textState.index)
				textState.text = textWithBreak + "\n" + textState.text.substring(textState.index,textState.text.length)
			}
			this.processCharacter(textState)
		}
		this.flushTextState(textState)
	}
	setNameText(text) {
		this._nameText = text
		this.refresh()
	}
	setHelpText(text) {
		this._helpText = text
		this.refresh()
	}
	refresh() {
		if(this.contents != null) {
			this.contents.clear()
			this.paintItemName(0,0)
			this.paintHelpText(0,40)
		}
	}
	paintItemName(x,y) {
		this.contents.fontSize = 18
		this.contents.fillRect(x,y,this.contentsWidth(),40,"rgba(0, 0, 0, 0.5)")
		this.drawText(this._nameText,x,y,this.contentsWidth(),"center")
	}
	paintHelpText(x,y) {
		this.contents.fontSize = LunaMMInventory.Params.helpFontSize
		this.drawTextEx(this._helpText,x,y,this.contentsWidth())
	}
	update() {
		super.update()
	}
	processVisible() {
		if(this._helpText.length > 0 && !(this.isOpen() || this.visible)) {
			this.show()
			this.open()
		} else {
			this.close()
			this.hide()
		}
	}
}
$hx_exports["WindowMapInvHelp"] = WindowMapInvHelp
WindowMapInvHelp.__name__ = true
class WindowMapInventory extends Window_Base {
	constructor(x,y,width,height) {
		super(new Rectangle(x,y,width,height));
		this._items = []
		this._selectionIndex = -1
		this.page = 0
		this._maxPageItems = LunaMMInventory.Params.maxPageItems
		this.cellWidth = 48
		this.cellHeight = 48
		this.borderSize = 2
		this.horizontalSpacing = 4
		this.setupEvents()
	}
	setupEvents() {
		let _gthis = this
		this.on("selectItem",function(index) {
			_gthis._selectionIndex = index
			let rect = _gthis.itemRectForCell(index)
			_gthis.setCursorRect(rect.x,rect.y,rect.width,rect.height)
		})
	}
	drawIcon(iconIndex,x,y) {
		let bitmap = ImageManager.loadSystem("IconSet")
		let pw = ImageManager.iconWidth
		let ph = ImageManager.iconHeight
		this.contents.blt(bitmap,iconIndex % 16 * pw,Math.floor(iconIndex / 16) * ph,pw,ph,x,y,this.cellWidth - this.borderSize * 4,this.cellHeight - this.borderSize * 4)
	}
	setItems(items) {
		this._items = items
		this.refresh()
	}
	currentItem() {
		return this._items[this._selectionIndex];
	}
	refresh() {
		if(this.contents != null) {
			console.log("src/WindowMapInventory.hx:92:","Paint All Items")
			this.contents.clear()
			this.paintAllItems()
		}
	}
	paintAllItems() {
		let endIndex = this.page * this._maxPageItems + this._maxPageItems
		let _g = this.page * this._maxPageItems
		while(_g < endIndex) this.paintItem(_g++)
	}
	paintItem(index) {
		let rect = this.itemRectForCell(index)
		this.paintCell(rect)
		this.paintCellItemIcon(rect,index)
	}
	paintCell(rect) {
		this.contents.fillRect(rect.x,rect.y,rect.width,rect.height,"white")
		this.contents.clearRect(rect.x + this.borderSize,rect.y + this.borderSize,rect.width - this.borderSize * 2,rect.height - this.borderSize * 2)
	}
	paintCellItemIcon(rect,index) {
		let item = this._items[index]
		if(item != null) {
			this.drawIcon(item.iconIndex,rect.x + this.borderSize * 2,rect.y + this.borderSize * 2)
		}
	}
	itemRectForCell(index) {
		let internalIndex = index % this._maxPageItems
		return new Rectangle(this.cellWidth * internalIndex + this.horizontalSpacing * internalIndex,0,this.cellWidth,this.cellHeight);
	}
	getCurrentItem(index) {
		let item = null
		item = this._items[this.page * this._maxPageItems + this._selectionIndex]
		return item;
	}
	update() {
		super.update()
		this.processOkAndCancel()
		this.processSelectionOfItemsKeyboard()
		this.processSelectionOfItemMouse()
	}
	processOkAndCancel() {
		if(this.currentItem() != null && this.active && Input.isTriggered("ok") || TouchInput.isPressed() && this.mouseInSelectionRect()) {
			this.emit("confirmItem",this.currentItem())
		}
		if(Input.isTriggered("cancel") || TouchInput.isCancelled() && this.active) {
			this.emit("cancelItem")
		}
	}
	processSelectionOfItemsKeyboard() {
		let _hx_tmp
		if(Input.isTriggered("right") == true) {
			this.emit("selectItem",this._selectionIndex + 1)
		} else {
			_hx_tmp = Input.isTriggered("left") && this._selectionIndex > 0
			if(_hx_tmp == true) {
				this.emit("selectItem",this._selectionIndex - 1)
			}
		}
	}
	mouseInSelectionRect() {
		return this.processSelectionOfItemMouse() != null;
	}
	processSelectionOfItemMouse() {
		let item = null
		let pos = WindowExtensions.canvasToLocal(this,TouchInput.x,TouchInput.y)
		let _g = 0
		let _g1 = this._maxPageItems
		while(_g < _g1) {
			let index = _g++
			let rect = this.itemRectForCell(index)
			let tmp
			let num = pos.x
			if(num >= rect.x && num <= rect.width + rect.x) {
				let num = pos.y
				tmp = num >= rect.y && num <= rect.height
			} else {
				tmp = false
			}
			if(tmp) {
				item = this._items[this.page * this._maxPageItems + index]
				this.emit("selectItem",index)
			}
		}
		return item;
	}
}
$hx_exports["WindowMapInventory"] = WindowMapInventory
WindowMapInventory.__name__ = true
class haxe_iterators_ArrayIterator {
	constructor(array) {
		this.current = 0
		this.array = array
	}
	hasNext() {
		return this.current < this.array.length;
	}
	next() {
		return this.array[this.current++];
	}
}
haxe_iterators_ArrayIterator.__name__ = true
class js_Boot {
	static __string_rec(o,s) {
		if(o == null) {
			return "null";
		}
		if(s.length >= 5) {
			return "<...>";
		}
		let t = typeof(o)
		if(t == "function" && (o.__name__ || o.__ename__)) {
			t = "object"
		}
		switch(t) {
		case "function":
			return "<function>";
		case "object":
			if(o.__enum__) {
				let e = $hxEnums[o.__enum__]
				let n = e.__constructs__[o._hx_index]
				let con = e[n]
				if(con.__params__) {
					s = s + "\t"
					return n + "(" + ((function($this) {
						var $r
						let _g = []
						{
							let _g1 = 0
							let _g2 = con.__params__
							while(true) {
								if(!(_g1 < _g2.length)) {
									break
								}
								let p = _g2[_g1]
								_g1 = _g1 + 1
								_g.push(js_Boot.__string_rec(o[p],s))
							}
						}
						$r = _g
						return $r;
					}(this))).join(",") + ")"
				} else {
					return n;
				}
			}
			if(((o) instanceof Array)) {
				let str = "["
				s += "\t";
				let _g = 0
				let _g1 = o.length
				while(_g < _g1) {
					let i = _g++
					str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i],s);
				}
				str += "]";
				return str;
			}
			let tostr
			try {
				tostr = o.toString
			} catch( _g ) {
				return "???";
			}
			if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
				let s2 = o.toString()
				if(s2 != "[object Object]") {
					return s2;
				}
			}
			let str = "{\n"
			s += "\t";
			let hasp = o.hasOwnProperty != null
			let k = null
			for( k in o ) {
			if(hasp && !o.hasOwnProperty(k)) {
				continue
			}
			if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
				continue
			}
			if(str.length != 2) {
				str += ", \n";
			}
			str += s + k + " : " + js_Boot.__string_rec(o[k],s);
			}
			s = s.substring(1)
			str += "\n" + s + "}";
			return str;
		case "string":
			return o;
		default:
			return String(o);
		}
	}
}
js_Boot.__name__ = true
class _$LTGlobals_$ {
}
_$LTGlobals_$.__name__ = true
class utils_Fn {
	static proto(obj) {
		return obj.prototype;
	}
	static updateProto(obj,fn) {
		return (fn)(obj.prototype);
	}
	static updateEntity(obj,fn) {
		return (fn)(obj);
	}
}
utils_Fn.__name__ = true
var $_
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $global.$haxeUID++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = m.bind(o); o.hx__closures__[m.__id__] = f; } return f; }
$global.$haxeUID |= 0
String.__name__ = true
Array.__name__ = true
js_Boot.__toStr = ({ }).toString
LunaMMInventory.listener = new PIXI.utils.EventEmitter()
LunaMMInventory.main()
})(typeof exports != "undefined" ? exports : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this)
