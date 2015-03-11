package playStateFolder ;

import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class Enemy extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, type:Int = 1) 
	{
		super(X, Y);
		loadGraphic("assets/images/Enemy"+type+".png", true, 100, 100);
	}
}