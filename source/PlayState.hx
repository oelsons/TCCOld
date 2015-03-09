package;

import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.input.gamepad.XboxButtonID;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxCollision;
import openfl.display.FPS;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	
	 private var player:Player;
	 private var grpEnemy:FlxTypedGroup<Enemy>;
	 private var grpBullet:FlxTypedGroup<Bullet>;
	 private var sndBullet:FlxSound;
	 private var countFrame:Float = 0;
	 
	 private var fps:FPS = new FPS();
	 //private var weapon:FlxWeapon = new FlxWeapon("arma", null, Bullet);
	 
	override public function create():Void
	{
		grpBullet = new FlxTypedGroup<Bullet>();
		add(grpBullet);
		
		startPlayer();

		grpEnemy = new FlxTypedGroup<Enemy>();
		add(grpEnemy);
		grpEnemy.add(new Enemy(500, 100));
		
		add(new FlxText(100, 100, 200, "Xbox360 Controller " + ((player.gamePad == null) ? "NOT FOUND" : "FOUND")));
		
		//trace(FlxG.overlap(player, grpEnemy));
		
		sndBullet = FlxG.sound.load(AssetPaths.shot1__wav);
		super.create();
	}
	
	function startPlayer()
	{
		player = new Player(640,600);
		add(player);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		player = FlxDestroyUtil.destroy(player);
		grpBullet = FlxDestroyUtil.destroy(grpBullet);
		grpEnemy = FlxDestroyUtil.destroy(grpEnemy);
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
		//trace(fps.currentFPS); //Show FPS
		var shoot:Bool = (player.gamePad != null && player.gamePad.pressed(XboxButtonID.RIGHT_TRIGGER)) ? true : FlxG.keys.anyPressed(["SPACE"]);
		if (shoot)
		{
			if (countFrame <= 0)
			{
					grpBullet.add(new Bullet(player.x+12.5, player.y+5));
					grpBullet.add(new Bullet(player.x + 72.5, player.y+5));
					FlxG.camera.shake(0.001, 0.1, null, true, 2);
					sndBullet.play(true);
					countFrame = player.rof;
			}
			countFrame--;
		}
		//FlxG.overlap(grpBullet, grpEnemy, bulletHitEnemy);
		grpBullet.forEach(bulletTest);
		grpEnemy.forEach(hitTest);
	}
	
	private function hitTest(E:Enemy)
	{
		if (FlxG.pixelPerfectOverlap(E, player))
		{
			player.killPlayer();
			player = FlxDestroyUtil.destroy(player);
			startPlayer();
		}
	}
	
	private function bulletTest(B:Bullet)
	{
		if (!B.isOnScreen(FlxG.camera)) destroyBullet(B);
		grpEnemy.forEach(function(E:Enemy) {
			if (FlxG.pixelPerfectOverlap(B, E))
			{
				bulletHitEnemy(B, E);
			}});
		trace(grpBullet.length);
	}
	
	private function destroyBullet(B:Bullet)
	{
		B.kill();
		B.destroy();
		grpBullet.remove(B);
	}
	
	private function bulletHitEnemy(B:Bullet, E:Enemy)
	{
		if (E.alive && E.exists && B.alive && B.exists)
		{
			destroyBullet(B);
			E.kill();
			E.destroy();
			grpEnemy.remove(E);
			grpEnemy.add(new Enemy(E.x + 20, E.y)); // TEST
		}
	}
}