/*
	The MIT License

	Copyright (c) 2010 Mike Chambers

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
*/

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

