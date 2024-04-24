package;

import flixel.*;
import flixel.util.FlxTimer;
import haxe.Timer;

class PlayState extends FlxState
{
	private var snake:Array<FlxSprite>;
	private var food:FlxSprite;
	private var direction:String = "RIGHT";
	var speed:Float = 0.2;
	private var snakeSize:Int = 3;
	private var gameWidth:Int = 400;
	private var gameHeight:Int = 300;

	override public function create():Void
	{
		super.create();

		createSnake();
		createFood();

		new FlxTimer().start(speed, function(timer:FlxTimer):Void
		{
			updateMovement();
		});
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		handleInput();
		updateMovement();
		checkCollisions();
	}

	private function createSnake():Void
	{
		snake = new Array<FlxSprite>();

		for (i in 0...snakeSize)
		{
			snake.push(new FlxSprite(20 * i, 0).makeGraphic(10, 10, 0xFF00FF00)); // Green snake
			add(snake[i]);
		}
	}

	private function createFood():Void
	{
		food = new FlxSprite().makeGraphic(10, 10, 0xFFFF0000); // Red food
		placeFood();
	}

	private function placeFood():Void
	{
		do
		{
			food.x = Math.floor(Math.random() * (gameWidth / 10)) * 10;
			food.y = Math.floor(Math.random() * (gameHeight / 10)) * 10;
		}
		while (snake.filter(segment -> segment.overlaps(food)).length > 0);

		add(food);
	}

	private function handleInput():Void
	{
		if (FlxG.keys.justPressed.DOWN && direction != "UP")
		{
			direction = "DOWN";
		}
		else if (FlxG.keys.justPressed.UP && direction != "DOWN")
		{
			direction = "UP";
		}
		else if (FlxG.keys.justPressed.LEFT && direction != "RIGHT")
		{
			direction = "LEFT";
		}
		else if (FlxG.keys.justPressed.RIGHT && direction != "LEFT")
		{
			direction = "RIGHT";
		}
	}

	private function updateMovement():Void
	{
		for (i in snake.length - 1...0)
		{
			snake[i].x = snake[i - 1].x;
			snake[i].y = snake[i - 1].y;
		}

		switch (direction)
		{
			case "UP":
				snake[0].y -= 10;
			case "DOWN":
				snake[0].y += 10;
			case "LEFT":
				snake[0].x -= 10;
			case "RIGHT":
				snake[0].x += 10;
		}
	}

	private function checkCollisions():Void
	{
		// Boundary collision
		if (snake[0].x < 0 || snake[0].x >= gameWidth || snake[0].y < 0 || snake[0].y >= gameHeight)
		{
			gameOver();
		}

		// Self collision
		for (i in 1...snake.length)
		{
			if (snake[0].overlaps(snake[i]))
			{
				gameOver();
			}
		}

		// Food Collision
		if (snake[0].overlaps(food))
		{
			eatFood();
		}
	}

	private function eatFood():Void
	{
		snake.push(new FlxSprite().makeGraphic(10, 10, 0xFF00FF00));
		add(snake[snake.length - 1]);
		placeFood();
	}

	private function gameOver():Void
	{
		FlxG.switchState(new GameOverState());
	}
}
