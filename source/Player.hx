package ;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.XboxButtonID;
import flixel.text.FlxText;
import flixel.util.FlxAngle;
import flixel.FlxG;
import haxe.Log;
/**
 * ...
 * @author ...
 */
class Player extends FlxSprite
{
	public var speed:Float = 600;
	public var rof:Float = 5;
	
	public var gamePad:FlxGamepad;

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.ShipSpritesheet__png, true, 100, 62);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		animation.add("lr", [1]);
		animation.add("ud", [0]);
		
		gamePad = FlxG.gamepads.lastActive;
		if (gamePad != null) gamePad.deadZone = 0.2;
	}
	
	private function movement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		
		#if !FLX_NO_KEYBOARD
		//_up = FlxG.keys.anyPressed(["UP", "W"]);
		//_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		//_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		//_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		_up = (gamePad != null && (gamePad.pressed(XboxButtonID.DPAD_UP) || gamePad.getYAxis(1) < 0)) ? true : FlxG.keys.anyPressed(["UP", "W"]);
		_down = (gamePad != null && (gamePad.pressed(XboxButtonID.DPAD_DOWN) || gamePad.getYAxis(1) > 0)) ? true : FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = (gamePad != null && (gamePad.pressed(XboxButtonID.DPAD_LEFT) || gamePad.getXAxis(0) < 0))  ? true : FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = (gamePad != null && (gamePad.pressed(XboxButtonID.DPAD_RIGHT) || gamePad.getXAxis(0) > 0)) ? true : FlxG.keys.anyPressed(["RIGHT", "D"]);
		if (gamePad != null)
		{
			trace('trace', gamePad.getXAxis(0), gamePad.getYAxis(1));
			//_up = gamePad.pressed(XboxButtonID.DPAD_UP);
			//_down = gamePad.pressed(XboxButtonID.DPAD_DOWN);
			//_left = gamePad.pressed(XboxButtonID.DPAD_LEFT);
			//_right = gamePad.pressed(XboxButtonID.DPAD_RIGHT);
		}
		#end
		#if mobile
		_up = PlayState.virtualPad.buttonUp.status == FlxButton.PRESSED;
		_down = PlayState.virtualPad.buttonDown.status == FlxButton.PRESSED;
		_left = PlayState.virtualPad.buttonLeft.status == FlxButton.PRESSED;
		_right = PlayState.virtualPad.buttonRight.status == FlxButton.PRESSED;
		#end
		
		if (_up && _down) _up = _down = false;
		if (_left && _right) _left = _right = false;
		
		if (_up || _down || _left || _right)
		{
			var mA:Float = 0;
			if (_up)
			{
				mA = -90;
				if (_left) mA -= 45;
				else if (_right) mA += 45;
				facing = FlxObject.UP;
			}
			else if (_down)
			{
				mA = 90;
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;
				facing = FlxObject.DOWN;
			}
			else if (_left)
			{
				mA = 180;
				facing = FlxObject.LEFT;
			}
			else if (_right)
			{
				mA = 0;
				facing = FlxObject.RIGHT;
			}
			
			FlxAngle.rotatePoint(speed, 0, 0, 0, mA, velocity);
			
			if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
			{
				switch(facing)
				{
					case FlxObject.UP, FlxObject.DOWN:
						animation.play("ud");
					case FlxObject.LEFT, FlxObject.RIGHT:
						animation.play("lr");
				}
			}
		}else {
			animation.play("ud");
			FlxAngle.rotatePoint(0, 0, 0, 0, 0, velocity);
		}
	}
	
	override public function destroy():Void
	{
		
	}
	
	override public function update():Void
	{
		movement();
		super.update();
	}
}