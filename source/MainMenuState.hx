package;

import flixel.FlxBasic.FlxType;
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['freeplay', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "-5.5" + nightly;
	public static var gameVer:String = "0.0.0.0";

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var lightText:FlxText;
	var trophyzadry:FlxSprite;

	var spotifycrap:FlxSprite;

	override function create()
	{

		if (FlxG.save.data.noMusic == null)
		{
			FlxG.save.data.noMusic = false;
		}

		if (FlxG.save.data.sans == null)
			{
				FlxG.save.data.sans = true;
				trace('it now exists');
			}
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Playing Zadry.EXE", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			if (FlxG.save.data.beatedzadry == true && FlxG.save.data.noMusic == false)
				{
					FlxG.sound.playMusic(Paths.musicRandom('altzadry', 1,12), 1.2);
				}
				else
				{
					FlxG.sound.playMusic(Paths.music('zadrymenu'), 0.7);		
				}
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('zadry-bg'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.15;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		trophyzadry = new FlxSprite(1003.2, 305.15);
		var zadrytex = Paths.getSparrowAtlas('trophy_zadry');
		trophyzadry.frames = zadrytex;
		trophyzadry.animation.addByPrefix('idle', 'trophy zadry', 24);
		trophyzadry.antialiasing = true;
		trophyzadry.scrollFactor.set(0, 0.15);
		trophyzadry.animation.play('idle');
		if (FlxG.save.data.beatedzadry == true)
		{
			FlxG.mouse.visible = true;
			add(trophyzadry);
		}


		if (FlxG.save.data.sans == true)
		{
				if (FlxG.save.data.beatedzadry == true && FlxG.random.bool(10))
				{
					FlxTween.tween(trophyzadry, {y: trophyzadry.y - 1000}, 10);
				}
				else if (FlxG.random.bool(6))
				{
					FlxG.sound.music.pause();
					FlxG.sound.play(Paths.sound('shorted'), 1);
					bg.alpha = 0;
					FlxG.camera.shake(0.05, 0.5);
					new FlxTimer().start(3, function(guycomesin:FlxTimer)
						{
							lightsout();
						});
				}
				else if (FlxG.random.bool(7))
				{
					FlxG.sound.music.pause();
					FlxG.camera.alpha = 0;
					new FlxTimer().start(1, function(sus:FlxTimer)
						{
							FlxG.camera.alpha = 1;
							spotifyjoke();		
						});	
				}
				else if (FlxG.random.bool(7))
				{
					heyguysitsmesans();
				}
		}

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}


		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	function heyguysitsmesans()
	{
		var sans:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('sans'));
		sans.setGraphicSize(Std.int(sans.width * 0.2));
		sans.updateHitbox();
		sans.screenCenter(Y);
		sans.x = 900;
		sans.antialiasing = false;

		add(sans);
		FlxTween.tween(sans, {x: -900}, 5, {type: FlxTweenType.PINGPONG, ease: FlxEase.cubeInOut});
	}
	function lightsout()
	{
		lightText = new FlxText(90, 0, 0, "", 32);  // the positions for this are confusing as hell to me 
		lightText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.WHITE, CENTER);		
		lightText.screenCenter(Y);
		lightText.text = "Hmm. Something isn't exactly working.";	
		add(lightText);
		FlxG.sound.play(Paths.sound('scrollMenu')); // i had nothing else to use :(
		new FlxTimer().start(3, function(lighttimer:FlxTimer)
			{
				lightText.text = "Oh well. It'll probably fix itself eventually.";
				FlxG.sound.play(Paths.sound('scrollMenu'));
				new FlxTimer().start(3, function(lighttimer:FlxTimer)
					{
						lightText.text = "Sorry for the minor inconvinence.";
						FlxG.sound.play(Paths.sound('scrollMenu'));
						new FlxTimer().start(3, function(lighttimer:FlxTimer)
							{
								FlxG.sound.music.resume();
								FlxG.sound.music.fadeIn(1.5, 0, 1.2);
								FlxTween.tween(lightText, {alpha: 0}, 1, {onComplete: function(swagguy:FlxTween)
								{
									remove(lightText);
								}});								
							});
					});
			});
	}

	function spotifyjoke()
	{
		spotifycrap = new FlxSprite(0, 0).loadGraphic(Paths.image('sorrybobcreators/spotifyad'));
		spotifycrap.scrollFactor.set();
		menuItems.forEach(function(sus:FlxSprite)
		{
			sus.alpha = 0;
		});
		trophyzadry.alpha = 0;
		var spotifyannoyance:FlxSound = new FlxSound().loadEmbedded(Paths.sound('tapnowtodie'));
		spotifyannoyance.play();

		lightText = new FlxText(90, 0, 0, "", 32);
		lightText.setFormat(Paths.font("comic.ttf"), 32, FlxColor.BLACK, CENTER);		
		lightText.screenCenter(Y);
		lightText.text = "shut up bob already did this joke";	
		FlxG.camera.fade(FlxColor.BLACK, 1.5, true);
		add(spotifycrap);
		new FlxTimer().start(3, function(iamreallysorry:FlxTimer)
			{
				spotifyannoyance.stop();
				add(lightText);
				FlxG.sound.play(Paths.sound('scrollMenu'));

				new FlxTimer().start(2, function(iamreallysorry:FlxTimer)
					{
						remove(lightText);
						remove(spotifycrap);
						menuItems.forEach(function(sus:FlxSprite)
							{
								sus.alpha = 1;
							});
						trophyzadry.alpha = 1;
						FlxG.sound.music.resume();
						FlxG.sound.music.fadeIn(1.5, 0, 1.2);
					});
			});
		

	}
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}


		if (trophyzadry != null)
		{
			if (FlxG.mouse.overlaps(trophyzadry) && FlxG.mouse.justPressed)
			{
				trophyzadry.animation.play('idle', true);
				var poop:String = Highscore.formatSong('zoned', 1);

				trace(poop);
	
				PlayState.SONG = Song.loadFromJson(poop, 'zoned');
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = 1;
				PlayState.storyWeek = 8;
				trace('CUR WEEK' + PlayState.storyWeek);
				LoadingState.loadAndSwitchState(new PlayState());
			}
			if (FlxG.mouse.overlaps(trophyzadry) && controls.RIGHT_P)
				{
					FlxTween.tween(trophyzadry, {alpha: 0.1}, 2);
				}
			if (FlxG.mouse.overlaps(trophyzadry) && controls.LEFT_P)
				{
					FlxTween.tween(trophyzadry, {alpha: 1}, 2);
				}
		}
		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('newclick'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('newclick'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());

										trace("Freeplay Menu Selected");

									case 'options':
										FlxG.switchState(new OptionsMenu());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
