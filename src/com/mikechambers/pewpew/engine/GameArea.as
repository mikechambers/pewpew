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
	import com.mikechambers.pewpew.engine.events.FireEvent;
	import com.mikechambers.pewpew.engine.events.GameEvent;
	import com.mikechambers.pewpew.engine.events.GameObjectEvent;
	import com.mikechambers.pewpew.engine.gameobjects.BasicEnemy;
	import com.mikechambers.pewpew.engine.gameobjects.ChaserEnemy;
	import com.mikechambers.pewpew.engine.gameobjects.Enemy;
	import com.mikechambers.pewpew.engine.gameobjects.Explosion;
	import com.mikechambers.pewpew.engine.gameobjects.Missile;
	import com.mikechambers.pewpew.engine.gameobjects.Ship;
	import com.mikechambers.pewpew.engine.gameobjects.UFOEnemy;
	import com.mikechambers.pewpew.ui.GameController;
	import com.mikechambers.pewpew.ui.ScoreBar;
	import com.mikechambers.pewpew.ui.WaveCompletedView;
	import com.mikechambers.pewpew.ui.events.ScreenControlEvent;
	
	import com.mikechambers.sgf.events.TickEvent;
	import com.mikechambers.sgf.time.TickManager;
	import com.mikechambers.sgf.utils.DisplayObjectUtil;
	import com.mikechambers.sgf.pools.GameObjectPool;
	import com.mikechambers.sgf.gameobjects.GameObject;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	//class that handles game play logic, and manages all
	//game play items
	public class GameArea extends Sprite
	{		
		//default starting number of lives
		private static const DEFAULT_LIVES:uint = 2;
		
		//default number of starting enemies per level
		private static const DEFAULT_NUMBER_ENEMIES:uint = 10;
		
		//interval in seconds to do special game checks
		private static const GAME_CHECK_INTERVAL:Number = 7;
	
		//instantiated within FLA
		public var scoreBar:ScoreBar;
	
		//player controlled ship
		private var ship:Ship;
		
		//game play bounds
		private var bounds:Rectangle;
		
		//current score
		private var score:uint;
		
		//current number of lives
		private var lives:int;
		
		//current level / wave
		private var wave:uint = 1;
		
		//vector of all active enemies
		private var enemies:Vector.<Enemy>;
		
		//vector of all active ship missiles
		private var missiles:Vector.<Missile>;
		
		//view displayed when a wave / level is completed
		private var waveCompletedView:WaveCompletedView;
		
		//tickManager instance to manage game play time
		private var tickManager:TickManager;
		
		//current tick count
		private var tickCount:uint = 0;
	
		//game controller / thumb paddle
		public var gameController:GameController;
	
		//object pool for game
		//todo: change this to use pool from SGF
		private var gameObjectPool:GameObjectPool;
		
		//Whether there is already a UFOEnemy in the game area
		private var ufoOnStage:Boolean = false;
	
		/*************** initialization *************/
		
		//constructor for instance
		public function GameArea()
		{			
			//initialize the enemies vector
			enemies = new Vector.<Enemy>();
			
			//initialize the missiles vector
			missiles = new Vector.<Missile>();
			
			//listen for when the instance is added to the stage
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
		
			//disable all mouse events since we dont need them here
			//this is done for performance reasons
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		
		
		/************** Flash engine Events **************/
	
		//called when instance is added to stage
		private function onStageAdded(e:Event):void
		{
			//dont need to listen for this anymore
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			//get an instance of the game object pool
			gameObjectPool = GameObjectPool.getInstance();
			
			//set the game area bounds
			bounds = new Rectangle(0,scoreBar.height, stage.stageWidth, 
										stage.stageHeight - scoreBar.height);
			
			
			//position the game controller / thumb paddle
			gameController.x = bounds.width - (gameController.width / 2);
			gameController.y = bounds.height - (gameController.height / 2);
			
			//listen for when the instance is removed from the stage
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 
																	0, true);
						
		}
		
		//called when the instance is removed from the stage
		private function onStageRemoved(e:Event):void
		{
			//remove listener, since we are already removed
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			//stop listening to the tickManager events
			tickManager.removeEventListener(TickEvent.TICK, onTick);
		}
	
	
		/************ controll APIS ****************/
	
		//starts the game
		public function start():void
		{
			//check if we have an instance of tickManager
			if(!tickManager)
			{
				//if not, create one and start it
				tickManager = TickManager.getInstance();
				
				//todo: look into why start is called inside the if statement
				tickManager.start();
			}
						
			//reset level
			reset();
			
			//initialize player ship
			initShip();
			
			//add enemies
			addEnemies();			
		}	
	
		//reset game state
		private function reset():void
		{
			//todo: need to be more consitent on how we listen for events / weak
			//listen for the onTick event from TickManager
			tickManager.addEventListener(TickEvent.TICK, onTick, false, 0, true);
			
			//reset tickCount
			tickCount = 0;
			
			//remove all existing enemies
			removeAllEnemies();
			
			//remove all existing missiles
			removeAllMissiles();

			//result current lives
			lives = DEFAULT_LIVES;
			
			//result score
			score = 0;
			
			//reset wave / level
			wave = 1;
			
			//todo: move this to a setter so we can set it in one place
			//update scorebar view
			scoreBar.score = score;
			scoreBar.lives = lives;
			scoreBar.wave = wave;
		}	
	
		//removes all of the enemies from the game play area
		private function removeAllEnemies():void
		{
			var len:int = enemies.length;
		
			for(var i:int = len - 1; i >= 0; i--)
			{
				//note that removeEnemy does a slice to remove the specified
				//enemy.
				//for removing all enemies, we could refactor to just set enemies.length = 0
				//but would have to include code from removeEnemy
				//given the fact that we never have more that 12 or so enemies at once, 
				//we are fine as is. However, if we added tons of enemies, it might be something
				//worth considering
				removeEnemy(enemies[i]);
			}
		}		
		
		
		//removes all missiles from the gameplay area
		private function removeAllMissiles():void
		{
			var len:int = missiles.length;
			
			for(var i:int = len - 1; i >= 0; i--)
			{
				//see comment above in removeAllEnemies, for possible
				//optimization
				removeMissile(missiles[i]);
			}
		}

		//resets all enemies and removes them from the game area		
		private function resetEnemies():void
		{			
			for each(var e:Enemy in enemies)
			{
				gameObjectPool.returnGameObject(e);
			}
		}
		
		//reinitializes all enemies
		private function restartEnemies():void
		{
			//make sure there are not any stray missiles that could
			//collide when the enemy spawns
			removeAllMissiles();
			
			for each(var e:Enemy in enemies)
			{
				//reinitialize 
				e.target = ship;
				e.initialize(bounds, ship, wave);
				
				//add to stage
				addGameObject(e);
			}
		}
		
		//initializes players ship
		private function initShip():void
		{
			//get a ship instance from the object pool
			ship = Ship(gameObjectPool.getGameObject(Ship));
			
			//reinitialize it
			ship.initialize(bounds, null, 1);
			
			//set the controller for the ship
			ship.gameController = gameController;
			
			//listen for when the ship fires
			ship.addEventListener(FireEvent.FIRE, onShipFire, false, 0, true);
			
			//add ship to stage
			addGameObject(ship);
			
			//position on stage
			ship.x = bounds.width / 2;
			ship.y = bounds.height / 2;
		}
		
		//add an initialize a new wave of enemies
		private function addEnemies():void
		{
			//make sure there are no stray missiles
			removeAllMissiles();
			
			var enemy:Enemy;
			
			//todo: should refactor to add ALL enemies (basic and advanced)
			//at same time.
			
			//loop through and create the enemies
			for(var i:int = 0; i < DEFAULT_NUMBER_ENEMIES; i++)
			{
				//get enemy instance from object pool
				enemy = BasicEnemy(gameObjectPool.getGameObject(BasicEnemy));
				
				//initialize
				enemy.initialize(bounds, null, 1 + (wave/5));
				
				//listen for when it gets destroyed
				enemy.addEventListener(GameObjectEvent.DESTROYED, onEnemyDestroyed, 
															false, 0, true);
				
				//add object to stage
				addGameObject(enemy);
				
				//added to enemies vector
				enemies.push(enemy);
			}
			
			//check if we are at wave 4 or higher
			if(wave > 3)
			{
				var len:int = 1;
				
				// some logic to add more advanced enemies at high levels
				if(wave >= 9)
				{
					//wave 9 or higher, add 3
					len = 3;
				}
				else if(wave > 6)
				{
					//wave 7 or higher, add 2
					len = 2;
				}
				
				//otherwise add 1
				
				while(len-- != 0)
				{
					//add chaser enemies
					enemy = ChaserEnemy(gameObjectPool.getGameObject(ChaserEnemy));
					
					//initialize
					enemy.initialize(bounds, ship, wave);
					
					
					//listen for when it gets destroyed
					enemy.addEventListener(GameObjectEvent.DESTROYED, onEnemyDestroyed, 
						false, 0, true);
					
					//add object to stage
					addGameObject(enemy);
					
					//added to enemies vector
					enemies.push(enemy);
				}
			}
		}
		
		/********** game events *************/
		
		//tick event, called on each game time interval
		private function onTick(e:TickEvent):void
		{
			//stop propogation of event for performance reasons
			e.stopPropagation();
			
			//check and see if there are any game object collisions
			checkCollisions();
			
			//update overall tick count
			tickCount++;
			
			//check if tick count is evenly divided by FPS (one second)
			if(!(tickCount % TickManager.FPS_RATE))
			{
				//see if it is time to do a game check to potentially
				//change game state
				//GAME_CHECK_INTERVAL is in seconds
				if(!(tickCount % GAME_CHECK_INTERVAL * TickManager.FPS_RATE))
				{
					gameCheck();
				}
			}
		}


		//called when it is time to potentially change the game state during
		//a game
		private function gameCheck():void
		{
			//if we are on wave one, do nothing
			if(wave < 2)
			{
				return;
			}
			
			//randomly dont do anyting (odds depend on the current wave)
			if((Math.random() * 100) + wave < 50)
			{
				return;
			}
			
			//check to see if a UFOEnemy is already on stage
			if(!ufoOnStage)
			{
				//get an instance of the UFOEnemy
				var enemy:UFOEnemy = UFOEnemy(gameObjectPool.getGameObject(UFOEnemy));
				
				//todo: we could move code below into its own function. This is done in a couple
				//of different places
				
				//initialize it
				enemy.initialize(bounds, ship, 1 + (wave/5));
				
				//list for destroyed event
				enemy.addEventListener(GameObjectEvent.DESTROYED, onEnemyDestroyed, 
															false, 0, true);
				
				//listen for REMOVE event (when it goes off stage)
				enemy.addEventListener(GameObjectEvent.REMOVE, onRemoveItem, false, 
																	0, true);

				//set that there is a UFOEnemy on stage
				ufoOnStage = true;
				
				//add to stage
				addGameObject(enemy);
				
				//add to enemies vector
				enemies.push(enemy);		
			}
		}
		
		//adds a game object to the stage (if it is not already on the stage)
		private function addGameObject(go:GameObject, setToBottom:Boolean = false):void
		{
			//check and see if it is already on the display list
			if(!contains(go))
			{
				
				//if not, add it
				addChild(go);
				
				//check if we want to set the item to the bottom of the z order
				if(setToBottom)
				{
					//if so, set it
					setChildIndex(go, 0);
				}
			}
			
			//tell the game object to start
			go.start();
		}
		
		/********* game engine APIs **********/
		
		//creates and positions an explosion object
		private function createExplosion(px:Number, py:Number):void
		{
			//get an explosion instance
			var exp:Explosion = Explosion(gameObjectPool.getGameObject(Explosion));
			
			//initialize it
			exp.initialize(bounds);
			
			//set position
			exp.x = px;
			exp.y = py;
			
			//listen for its complete event
			exp.addEventListener(GameEvent.EXPLOSION_COMPLETE, 
														onExplosionComplete, 
														false, 0, true);
			
			//add to game area
			addGameObject(exp);	
		}
		
		//check collisions between game objects
		//specifically, missiles and enemies
		//and enemies and the player's ship
		private function checkCollisions():void
		{
			/*
			Note, collision detection has been one of the areas
			where there has been extesnive optimizations and refactoring
			for performance reasons.
			
			The current version does a simple cirlce bounds test, which offers
			a good balance between performance, and visual accuracy.
			
			You can see a summary of various collision detection methods (most
			tried here at one point or another) at:
			
			http://www.mikechambers.com/blog/2009/06/26/relative-performance-for-collision-detection-techniques-in-actionscript-3/
			
			The most accurate detection used was doing pixel perfect collision detection:
			http://www.mikechambers.com/blog/2009/06/24/using-bitmapdata-hittest-for-collision-detection/
			http://www.mikechambers.com/blog/2009/06/25/strategies-for-optimizing-collision-detection-with-bitmapdata-hittest/
			
			however, this was removed to improve performance on iphone.
			
			I had also implimented pixel perfect collision detection with a grid based
			system for pairing down the tests that needed to be run. Again, this didnt perform great
			on iphone.
			
			http://www.mikechambers.com/blog/tag/as3dtc1/
			
			However, the current android based devices seem to run AIR / Flash content
			very well, and it may be possible to reimpliment pixel perfect collision detection with 
			a grid based checkl.
			
			*/
			
			//frameCount++;
			//check 1 out of every 3 frames
			//this is done for performance reasons.
			//can adjust depending on platform, and its performance
			//profile that the game is running on
			if((tickCount % 3) != 0)
			{
				return;
			}
			
			//if for some reason there is no ship, then dont do anything
			if(!ship)
			{
				return;
			}
			
			//get the bounds for the ship.
			var shipBounds:Rectangle = ship.getBounds(this);
			
			
			
			//loop through all of the enemies and check for collisions with missiles
			//and ships
			for each(var enemy:Enemy in enemies)
			{			
				//get the bounds of the current enemy
				var enemyBounds:Rectangle = enemy.getBounds(this);
				
				//loop through all of the missiles
				for each(var missile:Missile in missiles)
				{
					//do a simple circle hit test check between thie missile and enemy bounds
					if(DisplayObjectUtil.hitTestCircle(enemyBounds,missile.getBounds(this)))
					{
						//if they hit, remove the missile
						removeMissile(missile);

						// do damage to the enemy. This hit API is here so an enemy could have
						//different levels of hits points or conditions for being destroyed.
						//right now, all enemies will be killed by a single shot, and will be removed
						//from the stage immediately
						enemy.hit(missile.damage);

						//if there are no more enemies, then stop looping
						if(enemies.length == 0)
						{
							return;
						}
					}
				}
				
				//todo: might be an issue here where an enemy could be destroyed by a missile above (and
				//removed) but it would still be checked for collision against the ship here.
				
				//check and see if an enemy is colliding with the player's ship
				if(DisplayObjectUtil.hitTestCircle(shipBounds,enemyBounds))
				{
					//if so, destroy the ship
					destroyShip();

					//remove the enemy
					removeEnemy(enemy);
					return;
				}
			}
		}
				
		//called when a wave / level is completed
		private function waveCompleted():void
		{
			//there is a pause in the action, so lets call the
			//garbage collector.
			//probably not really necessary anymore
			System.gc();
			
			//create a new instance of the WaveCompletedView. We are not caching it
			//since it content changes everytime (level #)
			waveCompletedView = new WaveCompletedView();
			
			//listen for then the wave view is done being display
			waveCompletedView.addEventListener(GameEvent.WAVE_VIEW_COMPLETE, 
														onWaveViewCompleted, 
															false, 0, true);
			
			//add the view to the game area
			addChild(waveCompletedView);
			
			//tell the view what wave was just completed
			waveCompletedView.display(wave);
			
			
			//position it in the center of the stage.
			waveCompletedView.x = bounds.width / 2 - 
												(waveCompletedView.width / 2);
			waveCompletedView.y = bounds.height / 2 - waveCompletedView.height;
			
			//reset tickCount
			tickCount = 0;
		}		
		
		//todo: use a third party libary for this event chaining
		//timer used to track time after a ship it hit
		private var deathPauseTimer:Timer;
		
		//called when the player's ship should be destroyed
		//i.e. when it is hit by an enemy
		private function destroyShip():void
		{			
			//get the ships bounds
			var b:Rectangle = ship.getBounds(this);
			
			//create an explosion in the position that the ship was
			createExplosion(b.x + (b.width *.5), 
								b.y + (b.height * .5));
			
			//remove the fire event listener from the ship
			ship.removeEventListener(FireEvent.FIRE, onShipFire);
			
			//return the ship to the object pool
			gameObjectPool.returnGameObject(ship);
			
			ship = null;
			
			//decrement the number of player / ship lives
			lives--;
			
			//null out the target for all of the enemies
			for each(var enm:Enemy in enemies)
			{
				enm.target = null;
			}
			
			//check and see if there are no more lives
			if(lives < 0)
			{
				//if not, call GC
				System.gc();
				
				//dispatch a game over event
				var e:ScreenControlEvent = 
							new ScreenControlEvent(ScreenControlEvent.GAME_OVER);
				dispatchEvent(e);
			}
			else
			{
				//update scoreboard with new number of lives
				scoreBar.lives = lives;

				//if there are not more enemies (last one hit the ship)
				if(enemies.length < 1)
				{
					//complete the wave
					waveCompleted();
					return;
				}
				
				//start the death pause timer
				deathPauseTimer = new Timer(2000);
				deathPauseTimer.addEventListener(TimerEvent.TIMER, 
														onDeathPauseTimer, 
														false, 0, true);
				deathPauseTimer.start();

				//stop listening for tick events
				tickManager.removeEventListener(TickEvent.TICK, onTick);
			}
		}		
		
		//removes the specified enemy from the game area
		private function removeEnemy(s:GameObject):void
		{
			//remove event listeners
			s.removeEventListener(GameObjectEvent.DESTROYED, onEnemyDestroyed);
			s.removeEventListener(GameObjectEvent.REMOVE, onRemoveItem);

			//return the enemy to the object pool
			gameObjectPool.returnGameObject(s);
							
			//if the enemy is a UFOEnemy
			if(s is UFOEnemy)
			{
				//set that there are not UFOEnemies on stage
				ufoOnStage = false;
			}				

			//find the index of the enemies in the enemies vector
			var index:int = enemies.indexOf(s);
						
			//remove it
			enemies.splice(index, 1);			
			
			//check to see if there are anymore enemies
			if(enemies.length < 1 && lives > -1)
			{
				waveCompleted();
			}
		}		
		
		
		//removes the specified missile from the game area
		private function removeMissile(missile:Missile):void
		{
			//return the missile to the object pool
			gameObjectPool.returnGameObject(missile);
			
			//remove the listeners from the missile
			missile.removeEventListener(GameObjectEvent.REMOVE_MISSILE, onRemoveMissile);
			
			//find the index of the missile in the missiles vector
			var index:int = missiles.indexOf(missile);
			
			//remove the missile
			missiles.splice(index, 1);
		}		
		
		/*********** game engine events ***********/
		
		//called when an explosion has completed its anaimation
		private function onExplosionComplete(e:GameEvent):void
		{
			//stop the event propagation for performance reasons
			e.stopImmediatePropagation();
			
			//get a reference to the explosion
			var explosion:Explosion = Explosion(e.target);
			
			//remove the event listeners
			explosion.removeEventListener(GameEvent.EXPLOSION_COMPLETE, 
														onExplosionComplete);
			
			//return the explosion to the object pool
			gameObjectPool.returnGameObject(explosion);
		}
		
		//called when the wave view is done being displayed
		private function onWaveViewCompleted(e:GameEvent):void
		{
			//stop the event propagation for performance reasons
			e.stopImmediatePropagation();
			
			//remove the wave completed view from the display list
			removeChild(waveCompletedView);
			
			//stop listening for the event
			waveCompletedView.removeEventListener(GameEvent.WAVE_VIEW_COMPLETE, 
											onWaveViewCompleted);
			
			//clear the reference
			waveCompletedView = null;
			
			//if there are no ships
			if(!ship)
			{
				//initialize a new ship
				initShip();
			}
			
			//increment the wave / level counter
			wave++;
			
			//update scorebar
			scoreBar.wave = wave;
			
			//add the enemies
			addEnemies();
			
			//listen for tick events
			tickManager.addEventListener(TickEvent.TICK, onTick, false, 0, true);
		}
		
		//called when the time interval after a ship is destroyed is up
		private function onDeathPauseTimer(e:TimerEvent):void
		{						
			//stop event propagation for performance reasons
			e.stopImmediatePropagation();
			
			//reset all of the enemies
			resetEnemies();
			
			//initialize a new ship
			initShip();			
			
			//stop the timer
			deathPauseTimer.stop();
			
			//remove listener
			deathPauseTimer.removeEventListener(TimerEvent.TIMER, 
															onDeathPauseTimer);
			
			//add a new listener
			deathPauseTimer.addEventListener(TimerEvent.TIMER, 
													onSpawnShipTimer, false, 
													0, true);
			
			//set the intervale to 2 seconds
			deathPauseTimer.delay = 2000;
			
			//start the timer again. This gives the player 2 seconds to react to the
			//ship respawning before the enemies reappear
			deathPauseTimer.start();
		}
		
		//called after a ship has been destroyed and respawned
		private function onSpawnShipTimer(e:TimerEvent):void
		{
			//stop event propagation for performance reasons
			e.stopImmediatePropagation();
			
			//todo: should we reuse this?		
			
			//stop timer
			deathPauseTimer.stop();
			
			//remove listener
			deathPauseTimer.removeEventListener(TimerEvent.TIMER, 
															onSpawnShipTimer);
			
			//clear reference to timer
			deathPauseTimer = null;
			
			//restart all of the enemies
			restartEnemies();

			//reset tick count
			tickCount = 0;
			
			//start listening for tick events
			tickManager.addEventListener(TickEvent.TICK, onTick, false, 0, true);
		}		
		
		//called when an enemy is destroyed
		private function onEnemyDestroyed(e:GameObjectEvent):void
		{
			//stop event propagation for performance reasons
			e.stopImmediatePropagation();
			
			//get a reference to the enemy being destroyed
			var enemy:Enemy = Enemy(e.target);
			
			//get the enemy bounds
			var b:Rectangle = enemy.getBounds(this);
			
			//create an explosion in the place of the enemy
			createExplosion(b.x + (b.width * .5), b.y + (b.height * .5));
			
			//update the score value
			score += enemy.pointValue;
			
			//update the score display
			scoreBar.score = score;			
			
			//remove the enemy
			removeEnemy(enemy);
		}

		//called when a ship fires a missles
		private function onShipFire(e:FireEvent):void
		{
			//stop event propagation for performance reasons
			e.stopImmediatePropagation();
			
			//get a reference to the missile
			var m:Missile = e.projectile;
			
			//position it
			m.x = ship.x;
			m.y = ship.y;
			
			//listen for then the missile needs to be removed (i.e. goes off stage)
			m.addEventListener(GameObjectEvent.REMOVE_MISSILE, onRemoveMissile, false, 0, true);
			
			//add the missile to the game area
			addGameObject(m, true);
			
			//add the missile to the vector of all missiles
			missiles.push(m);
		}
		
		//called when a missile should be removed (probably because it went off
		//of the game area).
		private function onRemoveMissile(e:GameObjectEvent):void
		{
			//stop event propagation for performance reasons	
			e.stopImmediatePropagation();
			
			//remove the missile
			removeMissile(Missile(e.target));
		}
		
		//called when an item needs to be removed from the game area
		private function onRemoveItem(e:GameObjectEvent):void
		{
			//stop event propagation for performance reasons
			e.stopImmediatePropagation();
			
			//remove the item from the game area
			removeEnemy(GameObject(e.target));
		}	
	}

}

