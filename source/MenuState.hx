package;

import editorFolder.EditorState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxDestroyUtil;
import playStateFolder.PlayState;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	
	private var btnPlay:FlxButton;
	private var btnEditor:FlxButton;
	
	override public function create():Void
	{
		btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		btnPlay.x = FlxG.width / 2 - btnPlay.width / 2;
		btnPlay.y = FlxG.height / 2 - btnPlay.height / 2;
		add(btnPlay);
		btnEditor = new FlxButton(0, 0, "Editor", clickEditor);
		btnEditor.x = FlxG.width / 2 - btnEditor.width / 2;
		btnEditor.y = FlxG.height / 2 - btnEditor.height / 2 + 20;
		add(btnEditor);
		
		super.create();
	}
	
	private function clickPlay()
	{
		FlxG.switchState(new PlayState());
	}
	
	private function clickEditor()
	{
		FlxG.switchState(new EditorState());
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		btnPlay = FlxDestroyUtil.destroy(btnPlay);
		btnEditor = FlxDestroyUtil.destroy(btnEditor);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
}