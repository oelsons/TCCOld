package playStateFolder ;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxDestroyUtil;
/**
 * ...
 * @author ...
 */
class PBullet extends FlxSprite
{
	private var speed:Float = 2000;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Bullet1__png, true, 15, 20);
		animation.add("fire", [0]);
		animation.add("fly", [1]);
		animation.play("fire");
	}
	
	private function movement()
	{
		animation.play("fly");
		FlxAngle.rotatePoint(0, speed, 0, 0, 0, velocity);
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