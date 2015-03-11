package editorFolder ;

import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.FlxSprite;

/**
 * ...
 * @author ...
 */
class EditorState extends FlxState
{
	private var grpWaypoint:FlxTypedGroup<FlxSprite>;

	override public function create():Void
	{
		trace('Editor');
		
		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
	}
}