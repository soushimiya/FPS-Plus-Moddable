package stages.data;

import flixel.addons.display.FlxBackdrop;
import shaders.AdjustColorShader;
import flixel.sound.FlxSound;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import stages.elements.*;

class LimoErect extends BaseStage
{
	var	characterShader:AdjustColorShader = new AdjustColorShader(-30, -30, 0, -20);

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var shootingStarBeat:Int = 0;
	var shootingStarOffset:Int = 2;
	var shootingStar:FlxSprite;

	var mist1:FlxBackdrop;
	var mist2:FlxBackdrop;
	var mist3:FlxBackdrop;
	var mist4:FlxBackdrop;
	var mist5:FlxBackdrop;

	var carSound:FlxSound = new FlxSound();
	var unpauseSoundCheck:Bool = false;

	var fastCarCanDrive:Bool = true;

    public override function init(){
        name = "limo-erect";
		startingZoom = 0.9;

		var skyBG:FlxSprite = new FlxSprite(-220, -80).loadGraphic(Paths.image("week4/limo/erect/limoSunset"));
		skyBG.scrollFactor.set(0.1, 0.1);
		skyBG.scale.set(0.9, 0.9);
		skyBG.updateHitbox();
		skyBG.antialiasing = true;
		addToBackground(skyBG);

		shootingStar = new FlxSprite(200, 0);
		shootingStar.frames = Paths.getSparrowAtlas("week4/limo/erect/shooting star");
		shootingStar.scrollFactor.set(0.12, 0.12);
		shootingStar.antialiasing = true;
		shootingStar.animation.addByPrefix('star', "shooting star", 24, false);
		shootingStar.animation.play('star', true);
		shootingStar.visible = false;
		addToBackground(shootingStar);

		mist5 = new FlxBackdrop(Paths.image('week4/limo/erect/mistMid'), X);
		mist5.setPosition(-650, -400);
		mist5.scrollFactor.set(0.2, 0.2);
   		mist5.blend = ADD;
		mist5.color = 0xFFE7A480;
		mist5.alpha = 1;
		mist5.velocity.x = 100;
		mist5.scale.set(1.5, 1.5);
		addToBackground(mist5);

		var bgLimo:FlxSprite = new FlxSprite(-200, 480);
		bgLimo.frames = Paths.getSparrowAtlas("week4/limo/erect/bgLimo");
		bgLimo.animation.addByPrefix('drive', "background limo blue", 24);
		bgLimo.animation.play('drive');
		bgLimo.scrollFactor.set(0.4, 0.4);
		bgLimo.antialiasing = true;
		addToBackground(bgLimo);

		grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
		addToBackground(grpLimoDancers);

		for (i in 0...5)
		{
			var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
			dancer.scrollFactor.set(0.4, 0.4);
			dancer.shader = characterShader.shader;
			grpLimoDancers.add(dancer);
		}

		mist4 = new FlxBackdrop(Paths.image('week4/limo/erect/mistBack'), X);
		mist4.setPosition(-650, -380);
		mist4.scrollFactor.set(0.6, 0.6);
    	mist4.blend = ADD;
		mist4.color = 0xFF9c77c7;
		mist4.alpha = 1;
		mist4.velocity.x = 700;
		mist4.scale.set(1.5, 1.5);
		addToBackground(mist4);

		mist3 = new FlxBackdrop(Paths.image('week4/limo/erect/mistMid'), X);
		mist3.setPosition(-650, -100);
		mist3.scrollFactor.set(0.8, 0.8);
   		mist3.blend = ADD;
		mist3.color = 0xFFa7d9be;
		mist3.alpha = 0.5;
		mist3.velocity.x = 900;
		mist3.scale.set(1.5, 1.5);
		addToBackground(mist3);

		fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image("week4/limo/fastCarLol"));
		fastCar.antialiasing = true;
		fastCar.shader = characterShader.shader;
		addToBackground(fastCar);

		limo = new FlxSprite(-120, 550);
		limo.frames = Paths.getSparrowAtlas("week4/limo/erect/limoDrive");
		limo.animation.addByPrefix('drive', "Limo stage", 24);
		limo.animation.play('drive');
		limo.antialiasing = true;
		addToMiddle(limo);

		mist1 = new FlxBackdrop(Paths.image('week4/limo/erect/mistMid'), X);
		mist1.setPosition(-650, -100);
		mist1.scrollFactor.set(1.1, 1.1);
    	mist1.blend = ADD;
		mist1.color = 0xFFc6bfde;
		mist1.alpha = 0.4;
		mist1.velocity.x = 1700;
		addToForeground(mist1);

		mist2 = new FlxBackdrop(Paths.image('week4/limo/erect/mistBack'), X);
		mist2.setPosition(-650, -100);
		mist2.scrollFactor.set(1.2, 1.2);
    	mist2.blend = ADD;
		mist2.color = 0xFF6a4da1;
		mist2.alpha = 1;
		mist2.velocity.x = 2100;
		mist1.scale.set(1.3, 1.3);
		addToForeground(mist2);

		resetFastCar();

		dadStart.set(341, 914);
		bfStart.set(1235.5, 604);
		gfStart.set(787, 779);

		bfCameraOffset.set(-200, 0);

		boyfriend.applyShader(characterShader.shader);
		dad.applyShader(characterShader.shader);
		gf.applyShader(characterShader.shader);
    }

	var mistTimer:Float = 0;

	override function update(elapsed:Float):Void{
		mistTimer += elapsed;
		mist1.y = 100 + (Math.sin(mistTimer)*200);
		mist2.y = 0 + (Math.sin(mistTimer*0.8)*100);
		mist3.y = -20 + (Math.sin(mistTimer*0.5)*200);
		mist4.y = -180 + (Math.sin(mistTimer*0.4)*300);
		mist5.y = -450 + (Math.sin(mistTimer*0.2)*150);

		super.update(elapsed);
	}

	public override function beat(curBeat:Int){
		grpLimoDancers.forEach(function(dancer:BackgroundDancer){
			dancer.dance();
		});

		if (FlxG.random.bool(10) && fastCarCanDrive){
			fastCarDrive();
		}

		if (FlxG.random.bool(10) && curBeat > (shootingStarBeat + shootingStarOffset)){
			doShootingStar(curBeat);
		}
	} 

	public override function pause() {
		if(carSound.playing){
			unpauseSoundCheck = true;
			carSound.pause();
		}
	}

	public override function unpause() {
		if(unpauseSoundCheck){
			unpauseSoundCheck = false;
			carSound.play(false);
		}
	}

	function resetFastCar():Void{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive(){
		carSound = FlxG.sound.play(Paths.sound('week4/carPass' + FlxG.random.int(0, 1)), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer){
			resetFastCar();
		});
	}

	function doShootingStar(beat:Int):Void{
		shootingStar.visible = true;
		shootingStar.x = FlxG.random.int(50,900);
		shootingStar.y = FlxG.random.int(-10,20);
		shootingStar.flipX = FlxG.random.bool(50);
		shootingStar.animation.play('star', true);

		shootingStarBeat = beat;
		shootingStarOffset = FlxG.random.int(4, 8);
	}
}