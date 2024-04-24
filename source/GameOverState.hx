package;

import flixel.FlxState;
import flixel.text.FlxText;

class GameOverState extends FlxState
{
	override public function create()
	{
		add(new FlxText(20, 120, "Game Over!", 48));
	}
}
