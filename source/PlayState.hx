package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedSpriteGroup;
import flixel.input.gamepad.XboxButtonID;
import flixel.system.FlxSound;
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
	 private var grpEnemy:FlxTypedSpriteGroup<Enemy>;
	 private var grpBullet:FlxTypedSpriteGroup<Bullet>;
	 private var sndBullet:FlxSound;
	 private var countFrame:Float = 0;
	 
	override public function create():Void
	{
		grpBullet = new FlxTypedSpriteGroup<Bullet>();
		add(grpBullet);
		
		player = new Player(640,600);
		add(player);
		
		grpEnemy = new FlxTypedSpriteGroup<Enemy>();
		add(grpEnemy);
		grpEnemy.add(new Enemy(500, 100));
		
		add(new FlxText(100, 100, 200, "Xbox360 Controller " + ((player.gamePad == null) ? "NOT FOUND" : "FOUND")));
		
		sndBullet = FlxG.sound.load(AssetPaths.shot1__wav);
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
		super.update();
		var shoot:Bool = (player.gamePad != null && player.gamePad.pressed(XboxButtonID.RIGHT_TRIGGER)) ? true : FlxG.keys.anyPressed(["SPACE"]);
		if (shoot)
		{
			trace('lkjlkj');
			if (countFrame <= 0)
			{
					grpBullet.add(new Bullet(player.x+12.5, player.y+5));
					grpBullet.add(new Bullet(player.x + 72.5, player.y+5));
					FlxG.camera.shake(0.001, 0.1, null, true, 2);
					sndBullet.play(true);
					countFrame = player.rof;
			}
			countFrame--;
			//FlxG.overlap(grpBullet, grpEnemy, bulletHitEnemy);
		}
		grpBullet.forEach(bulletTest);
	}
	
	private function bulletTest(B:Bullet)
	{
		if (B.y < -20)
		{
			B.kill();
			B.destroy();
			grpBullet.remove(B);
		}
	}
	
	private function bulletHitEnemy(E:Enemy, B:Bullet)
	{
		trace('açdjaçl');
		/*if (E.alive && E.exists && B.alive && B.exists)
		{
			E.kill();
			B.kill();
		}*/
	}
}