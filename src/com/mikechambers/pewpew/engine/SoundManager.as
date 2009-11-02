package com.mikechambers.pewpew.engine
{
	import flash.utils.Dictionary;
	import flash.media.SoundTransform;
	import flash.media.Sound;

	public class SoundManager
	{
		
		public static const FIRE_SOUND:String = "fireSound";
		public static const EXPLOSION_SOUND:String = "explosionSound";
		public static const UFO_SOUND:String = "ufoSound";
		
		private static var instance:SoundManager;
		
		private var sounds:Dictionary;
		
		public function SoundManager()
		{
			super();
			initialize();
		}
	
		public static function getInstance():SoundManager
		{
			if(!instance)
			{
				instance = new SoundManager();
			}
			
			return instance;
		}
		
		private function initialize():void
		{
			sounds = new Dictionary();
			sounds[FIRE_SOUND] = new PewSound();
			sounds[EXPLOSION_SOUND] = new ExplosionSound();
			sounds[UFO_SOUND] = new UFONoiseSound();
			
			var st:SoundTransform = new SoundTransform(0);
			
			for each(var sound:Sound in sounds)
			{
				sound.play(0,0,st);
			}
		}
		
		public function getSound(soundName:String):Sound
		{
			return sounds[soundName]; 
		}
	
	}

}

