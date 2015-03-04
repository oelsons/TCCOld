package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxDestroyUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	
	 private var player:Player;
	 private var grpBullet:FlxTypedSpriteGroup<Bullet>;
	 
	override public function create():Void
	{
		grpBullet = new FlxTypedSpriteGroup<Bullet>();
		add(grpBullet);
		
		player = new Player(640,600);
		add(player);
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		player = FlxDestroyUtil.destroy(player);
		grpBullet = FlxDestroyUtil.destroy(grpBullet);
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (FlxG.keys.anyPressed(["SPACE"]))
		{
			grpBullet.add(new Bullet(player.x+12.5, player.y));
			grpBullet.add(new Bullet(player.x + 72.5, player.y));
			FlxG.camera.shake(0.001,0.1, null, true, 2);
		}
		super.update();
	}	
}