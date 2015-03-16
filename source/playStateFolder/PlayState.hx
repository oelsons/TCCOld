package playStateFolder ;

import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon;
import flixel.effects.particles.FlxParticle;
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
import flixel.util.FlxRandom;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxColor;

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
	 private var grpBullet:FlxTypedGroup<PBullet>;
	 private var sndBullet:FlxSound;
	 private var sndExplosion:FlxSound;
	 private var countFrame:Float = 0;
	 
	 private var fps:FPS = new FPS();
	 //private var weapon:FlxWeapon = new FlxWeapon("arma", null, Bullet);
	 
	 private var _explosionPixel:FlxParticle;
	 
	override public function create():Void
	{
		grpBullet = new FlxTypedGroup<PBullet>();
		add(grpBullet);
		
		startPlayer();
		
		grpEnemy = new FlxTypedGroup<Enemy>();
		add(grpEnemy);
		grpEnemy.add(new Enemy(500, 100));
		
		add(new FlxText(100, 100, 200, "Xbox360 Controller " + ((player.gamePad == null) ? "NOT FOUND" : "FOUND")));
		
		//trace(FlxG.overlap(player, grpEnemy));
		
		sndBullet = FlxG.sound.load(AssetPaths.shot1__wav);
		sndExplosion = FlxG.sound.load(AssetPaths.explosion1__mp3);
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
					grpBullet.add(new PBullet(player.x+12.5, player.y+5));
					grpBullet.add(new PBullet(player.x + 72.5, player.y+5));
					FlxG.camera.shake(0.001, 0.1, null, true, 2);
					sndBullet.play(true);
					countFrame = player.rof;
					
					_explosionPixel = new FlxParticle();
					_explosionPixel.makeGraphic(2, 10, FlxColor.WHITE);
					_explosionPixel.visible = false;
					var shellLeft = new FlxEmitter(player.x+100, player.y+20, 1);
					shellLeft.setXSpeed(1000+player.velocity.x,1000+player.velocity.x);
					shellLeft.setYSpeed(300,300);
					shellLeft.bounce = 0.8;
					add(shellLeft);
					shellLeft.add(_explosionPixel);
					shellLeft.start(true, 1);
					
					_explosionPixel = new FlxParticle();
					_explosionPixel.makeGraphic(2, 10, FlxColor.WHITE);
					_explosionPixel.visible = false;
					var shellRight = new FlxEmitter(player.x, player.y+20, 1);
					shellRight.setXSpeed(-1000+player.velocity.x,-1000+player.velocity.x);
					shellRight.setYSpeed(300, 300);
					shellRight.bounce = 0.8;
					add(shellRight);
					shellRight.add(_explosionPixel);
					shellRight.start(true, 1);
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
	
	private function bulletTest(B:PBullet)
	{
		if (!B.isOnScreen(FlxG.camera)) destroyBullet(B);
		grpEnemy.forEach(function(E:Enemy) {
			if (FlxG.pixelPerfectOverlap(B, E))
			{
				bulletHitEnemy(B, E);
			}});
		trace('Objects: '+(grpEnemy.length+grpBullet.length+1)+' FPS: '+fps.currentFPS);
	}
	
	private function destroyBullet(B:PBullet)
	{
		B.kill();
		B.destroy();
		grpBullet.remove(B);
	}
	
	private function bulletHitEnemy(B:PBullet, E:Enemy)
	{
		if (E.alive && E.exists && B.alive && B.exists)
		{
			destroyBullet(B);
			E.kill();
			E.destroy();
			grpEnemy.remove(E);
			grpEnemy.add(new Enemy(FlxRandom.intRanged(200, 1200), FlxRandom.intRanged(0, 400))); // TEST
			if(Math.random() > .8) grpEnemy.add(new Enemy(FlxRandom.intRanged(200, 1200), FlxRandom.intRanged(0, 400))); // TEST
			
			sndExplosion.play(true);
			
			var fe = new FlxEmitter(B.x, B.y, 30);
			fe.setXSpeed(-500,500);
			fe.setYSpeed(-200,50);
			fe.bounce = 0.8;
			add(fe);
			for (i in 0...(Std.int(fe.maxSize / 3))) 
			{
				_explosionPixel = new FlxParticle();
				_explosionPixel.makeGraphic(2, 2, FlxColor.YELLOW);
				_explosionPixel.visible = false; 
				fe.add(_explosionPixel);
				_explosionPixel = new FlxParticle();
				_explosionPixel.makeGraphic(1, 1, FlxColor.RED);
				_explosionPixel.visible = false;
				fe.add(_explosionPixel);
				_explosionPixel = new FlxParticle();
				_explosionPixel.makeGraphic(1, 1, FlxColor.WHITE);
				_explosionPixel.visible = false;
				fe.add(_explosionPixel);
			}
			fe.start(true, 3);
		}
	}
}