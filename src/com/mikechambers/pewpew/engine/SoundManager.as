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

	/*
		Singleton Class for managing sounds in the game.
	
		The singleton is not enforced.
	
		It will initialize the sounds on start up (which ensures there
		is not a hicup or CPU spike the first time they are played).
	
		It also manages single instances of sound to help reduce
		memory and CPU usage.
	
		This class is specific to PewPew but could be made more generic
		in order to work anywhere.
	*/
	public class SoundManager
	{
		//sound of ship firing
		public static const FIRE_SOUND:String = "fireSound";
		
		//sound of explosion
		public static const EXPLOSION_SOUND:String = "explosionSound";
		
		//UFOEnemy sound
		public static const UFO_SOUND:String = "ufoSound";
		
		//single instance of class
		private static var instance:SoundManager;
		
		//dictionary to store the sounds
		private var sounds:Dictionary;
		
		//constructor. This should not be called directly.
		//Use SoundManager.getInstance() instead.
		public function SoundManager()
		{
			super();
			
			//initialize sounds
			initialize();
		}
	
		//API that returns the single instance of the SoundManager
		public static function getInstance():SoundManager
		{
			//see if we have an instance yet
			if(!instance)
			{
				//if not, create one
				instance = new SoundManager();
			}
			
			return instance;
		}
		
		//initializes sounds
		private function initialize():void
		{
			//dictionary to hold sounds
			sounds = new Dictionary();
			
			//create and store sound instances
			sounds[FIRE_SOUND] = new PewSound();
			sounds[EXPLOSION_SOUND] = new ExplosionSound();
			sounds[UFO_SOUND] = new UFONoiseSound();
			
			
			//create a SoundTransform instance with volume set
			//to 0.
			var st:SoundTransform = new SoundTransform(0);
			
			//loop through the sounds
			for each(var sound:Sound in sounds)
			{
				//play each sound silently one.
				//This will cache the sounds into memory, and ensure
				//the first time we need them, they play with out a pause,
				//CPU spike, or hicup.
				sound.play(0,0,st);
			}
		}
		
		//takes a sound name, and returns an initialized Sound
		//instance
		public function getSound(soundName:String):Sound
		{
			return sounds[soundName]; 
		}
	
	}

}

