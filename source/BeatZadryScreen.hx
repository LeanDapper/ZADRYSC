package;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class BeatZadryScreen extends MusicBeatState
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
			"CONGRATULATIONS YOU BEATED ZADRY!\n"
			+ "\n"
			+ "But that isn't the end of this mod just yet.\n"
			+ "\n"
			+ "Something new has appeared on the main menu.\n"
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
