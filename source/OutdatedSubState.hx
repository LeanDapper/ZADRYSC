package;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;
	var fade:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	public static var needVer:String = "IDFK LOL";

	override function create()
	{
		super.create();
		fade.alpha = 0;
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Hello Person that is reading this.\n"
			+ "\n"
			+ "I just wan't to say thanks for playing this mod. \n"
			+ "Making this mod, has been both funny and interesting to make."
			+ "I've learned so much from making this mod, " + "So it makes me feel happy that you played it.\n"
			+ "\n"
			+ "PRESS ENTER TO GO TO THE MENU SCREEN\n",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
		add(fade);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.save.data.seenthanks = true;
			FlxTween.tween(fade, {alpha: 1}, 0.5, {
				ease: FlxEase.quadInOut,
				onComplete: function(twn:FlxTween)
				{
					leftState = true;
					FlxG.switchState(new MainMenuState());	
				}
			});
		}
		super.update(elapsed);
	}
}
