package com.mikechambers.pewpew.engine
{
	import com.mikechambers.pewpew.memory.IMemoryManageable;
	
	import com.mikechambers.pewpew.engine.events.FireEvent;
	import com.mikechambers.pewpew.engine.events.GameEvent;
	import com.mikechambers.pewpew.ui.events.ScreenControlEvent;
	import com.mikechambers.pewpew.engine.events.GameObjectEvent;
	
	import com.mikechambers.pewpew.engine.TickManager;
	import com.mikechambers.pewpew.engine.events.TickEvent;
	
	import com.mikechambers.pewpew.ui.ScoreBar;
	import com.mikechambers.pewpew.ui.WaveCompletedView;
	import com.mikechambers.pewpew.ui.GameController;
	
	import com.mikechambers.pewpew.engine.gameobjects.Ship;
	import com.mikechambers.pewpew.engine.gameobjects.Missile;
	import com.mikechambers.pewpew.engine.gameobjects.Enemy;
	import com.mikechambers.pewpew.engine.gameobjects.UFOEnemy;
	import com.mikechambers.pewpew.engine.gameobjects.ChaserEnemy;
	import com.mikechambers.pewpew.engine.gameobjects.BasicEnemy;
	import com.mikechambers.pewpew.engine.gameobjects.Explosion;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;

	import flash.geom.Matrix;	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import flash.system.System;

	import flash.utils.Dictionary;
	import flash.utils.Timer;

	import __AS3__.vec.Vector;

	
	public class GameArea extends Sprite
	{		
		private static const DEFAULT_LIVES:uint = 2;
		private static const DEFAULT_NUMBER_ENEMIES:uint = 10;
		
		private static const GAME_CHECK_INTERVAL:Number = 7;
	
		//instantiated within FLA
		public var scoreBar:ScoreBar;
	
		private var ship:Ship;
		//private var target:Target;
		private var bounds:Rectangle;
		
		private var score:uint;
		private var lives:int;
		private var wave:uint = 1;
		
		private var enemies:Vector.<Enemy>;
		private var missiles:Vector.<Missile>;
		
		private var waveCompletedView:WaveCompletedView;
		
		private var missileBmpData:BitmapData;
		private var collisionPoint1:Point = new Point();
		private var collisionPoint2:Point = new Point();
		
		private var shipBmpData:BitmapData;
		private var oldShipHash:int = 0;
		
		//private var frameCount:int = 0;
		private var enemyBmpDataLookup:Dictionary = new Dictionary();		
		
		//private var timer:Timer;
		private var tickManager:TickManager;
		private var tickCount:uint = 0;
	
		public var gameController:GameController;
	
		public function GameArea()
		{			
			enemies = new Vector.<Enemy>();
			missiles = new Vector.<Missile>();
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
		
			mouseEnabled = false;
			mouseChildren = false;
			
			tickManager = TickManager.getInstance();
		}
		
		/*************** initialization *************/
		
		/************** Flash engine Events **************/
	
		private function onStageAdded(e:Event):void
		{
			bounds = new Rectangle(0,scoreBar.height, stage.stageWidth, 
										stage.stageHeight - scoreBar.height);
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			if(!missile)
			{
				var missile:Missile = new Missile(0, bounds);
			
				//hack to work around AIR bug #2412471
				addChild(missile);
			
				missileBmpData = new BitmapData(missile.width, missile.height);
				missileBmpData.draw(missile);
				
				//hack to work around AIR bug #2412471
				removeChild(missile);
			}
			
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 
																	0, true);
						
		}
		
		private function onStageRemoved(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			tickManager.removeEventListener(TickEvent.TICK, onTick);
		}
	
	
		/************ controll APIS ****************/
	
		//should we call this from onStageAdded?
		public function start():void
		{
			reset();
			initShip();
			addEnemies();			
		}	
	
		private function reset():void
		{
			/*
			if(!target)
			{
				target = new Target();
				addChild(target);
			}
			*/
			
			//addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			/*
			if(timer)
			{
				timer.reset();
			}
			else
			{
				timer = new Timer(GAME_CHECK_INTERVAL);
			}
			
			timer.addEventListener(TimerEvent.TIMER, onGameCheck, false, 0, 
																		true);
			timer.start();
			*/
			tickManager.addEventListener(TickEvent.TICK, onTick, false, 0, true);
			
		
			tickCount = 0;
			removeAllEnemies();
			removeAllMissiles();

			
			lives = DEFAULT_LIVES;
			score = 0;
			wave = 1;
			
			//remove this to a setter so we can set it in one place
			scoreBar.score = score;
			scoreBar.lives = lives;
			scoreBar.wave = wave;
		}	
		
		private function removeAllSpritesFromVector(v:Vector.<Sprite>):void
		{
			var len:int = v.length;
			
			for(var i:int = len - 1; i >= 0; i--)
			{
				removeItem(v[i]);
			}
		}
		
		private function removeAllEnemies():void
		{
			//todo : performace : if this cast is slow, we can inline the loop
			removeAllSpritesFromVector(Vector.<Sprite>(enemies));
		}		
		
		private function removeAllMissiles():void
		{
			//todo : performace : if this cast is slow, we can inline the loop
			removeAllSpritesFromVector(Vector.<Sprite>(missiles));
		}

		private function resetEnemies():void
		{			
			for each(var e:Enemy in enemies)
			{
				removeChild(e);
			}
		}
		
		private function restartEnemies():void
		{
			removeAllMissiles();
			for each(var e:Enemy in enemies)
			{
				e.target = ship;
				addChild(e);
			}
		}
		
		private function initShip():void
		{
			ship = new Ship(bounds, null, 1, gameController);
			
			ship.addEventListener(FireEvent.FIRE, onShipFire, false, 0, true);
			
			addChild(ship);
			//target.ship = ship;
			
			ship.x = 200;
			ship.y = 200;
		}
		
		private function addEnemies():void
		{
			removeAllMissiles();
			var enemy:Enemy;
			
			for(var i:int = 0; i < DEFAULT_NUMBER_ENEMIES; i++)
			{
				enemy = new BasicEnemy(bounds, null, 1 + (wave/5));
				enemy.addEventListener(GameObjectEvent.DESTROYED, onEnemyDestroyed, 
															false, 0, true);
				addChild(enemy);
				enemies.push(enemy);
			}
			
			if(wave > 3)
			{
				var len:int = 1;
				
				if(wave >= 9)
				{
					len = 3;
				}
				else if(wave > 6)
				{
					len = 2;
				}
				
				while(len-- != 0)
				{
					enemy = new ChaserEnemy(bounds, ship, wave);
					enemy.addEventListener(GameObjectEvent.DESTROYED, 
															onEnemyDestroyed, 
															false, 0, true);
					addChild(enemy);
					enemies.push(enemy);
				}
			}
		}
		
		/********** game events *************/

		private function onTick(e:TickEvent):void
		{

			checkCollisions();
			
			tickCount++;
			if(!(tickCount % TickManager.FPS_RATE))
			{
				
				if(!(tickCount % GAME_CHECK_INTERVAL * TickManager.FPS_RATE))
				{
					gameCheck();
				}
			}
		}

		private var ufoOnStage:Boolean = false;
		private function gameCheck():void
		{
			if(wave < 2)
			{
				return;
			}
			
			if((Math.random() * 100) + wave < 50)
			{
				return;
			}
			
			//check to see if there is already one
			var enemy:UFOEnemy = new UFOEnemy(bounds, ship, 1 + (wave/5));
			enemy.addEventListener(GameObjectEvent.DESTROYED, onEnemyDestroyed, 
															false, 0, true);
			enemy.addEventListener(GameObjectEvent.REMOVE, onRemoveItem, false, 
																	0, true);

			ufoOnStage = true;
			addChild(enemy);
			enemies.push(enemy);			
		}
		
		/********* game engine APIs **********/
		
		private function createExplosion(px:Number, py:Number):void
		{
			var exp:Explosion = new Explosion();
			exp.x = px;
			exp.y = py;
			
			exp.addEventListener(GameEvent.EXPLOSION_COMPLETE, 
														onExplosionComplete, 
														false, 0, true);
			
			addChild(exp);	
		}
		
		private function checkCollisions():void
		{
			
			//frameCount++;
			//only check every 2 frames
			if((tickCount % 2) != 0)
			{
				//return;
			}
			
			//check this
			if(!ship)
			{
				return;
			}
			
			var shipBounds:Rectangle = ship.getBounds(this);	
			
			var shipBoundsHash:int = ship.rotation;
			
			//basically, we check the rotation to see if it has changed much
			//if it hasnt, we just use the bitmapdata from early frame(s)
			if(!shipBmpData || 
						shipBoundsHash < oldShipHash - 5 || 
						shipBoundsHash > oldShipHash + 5)
			{	

				shipBmpData = new BitmapData(shipBounds.width, 
												shipBounds.height, true, 0);
				//shipBmpData.draw(ship, null);									
				//temp
				
				import flash.geom.Matrix3D;
				var shipOffset:Matrix3D = ship.transform.matrix3D;

				var rawMatrixData:Vector.<Number> = shipOffset.rawData;

				var matrix:Matrix = new Matrix();
				matrix.a = rawMatrixData[0];
				matrix.c = rawMatrixData[1];
				matrix.tx = ship.x - shipBounds.x;
				
				matrix.b = rawMatrixData[4];
				matrix.d = rawMatrixData[5];
				matrix.ty = ship.y - shipBounds.y;
				
				ship.transform.matrix3D = null;
				shipBmpData.draw(ship, matrix);
				ship.transform.matrix3D = shipOffset;
				
			}

			oldShipHash = shipBoundsHash;
			
			for each(var enemy:Enemy in enemies)
			{					
				//check if bounding boxes collide. if not, continue
				var classRef:Class = enemy["constructor"] as Class;

				eBmpData = enemyBmpDataLookup[classRef];
				var enemyBounds:Rectangle = enemy.getBounds(this);
				if(!eBmpData)
				{
					var eBmpData:BitmapData = new BitmapData(enemyBounds.width, 
														enemyBounds.height, 
														true, 0);
					//eBmpData.draw(enemy, null);
					//this might not work for items which rotate
					//var enemyOffset:Matrix = enemy.transform.matrix;
					//enemyOffset.tx = enemy.x - enemyBounds.x;
					//enemyOffset.ty = enemy.y - enemyBounds.y;
				
				
					var enemyOffset:Matrix3D = enemy.transform.matrix3D;
				
					var rawMatrixData:Vector.<Number> = enemyOffset.rawData;

import flash.geom.Matrix3D;
					var matrix:Matrix = new Matrix();
					matrix.a = rawMatrixData[0];
					matrix.c = rawMatrixData[1];
					matrix.tx = enemy.x - enemyBounds.x;

					matrix.b = rawMatrixData[4];
					matrix.d = rawMatrixData[5];
					matrix.ty = enemy.y - enemyBounds.y;				
				
					eBmpData.draw(enemy, matrix);
				
					//eBmpData.draw(enemy, enemyOffset);
					
					enemyBmpDataLookup[classRef] = eBmpData;
				}
	
				collisionPoint2.x = enemyBounds.x;
				collisionPoint2.y = enemyBounds.y;


				if(ship.hitTestObject(enemy))
				{
					collisionPoint1.x = shipBounds.x;
					collisionPoint1.y = shipBounds.y;

					//check if bounding boxes collide. if not, continue
					//we can cahce the matrix
					if(shipBmpData.hitTest(collisionPoint1, 255, eBmpData, 
										collisionPoint2, 255))
					{
						destroyShip();

						//todo: this may cause issues since we are removing 
						//it in the loop
						removeItem(enemy);
						return;				
					}
				}

			
				for each(var missile:Missile in missiles)
				{					
					if(!enemy.hitTestObject(missile))
					{
						continue;
					}
					
					collisionPoint1.x = missile.x;
					collisionPoint1.y = missile.y;
					
					if(missileBmpData.hitTest(collisionPoint1, 255, eBmpData, 
										collisionPoint2, 255))
					{
						//trace("hit");
						removeItem(missile);
						enemy.hit(missile.damage);

						if(enemies.length == 0)
						{
							return;
						}
					}
				}
			}
			
			//shipBmpData.dispose();
		}
				
		private function waveCompleted():void
		{
			System.gc();
			
			waveCompletedView = new WaveCompletedView();
			waveCompletedView.addEventListener(GameEvent.WAVE_VIEW_COMPLETE, 
														onWaveViewCompleted, 
															false, 0, true);
			addChild(waveCompletedView);
			
			waveCompletedView.display(wave);
			
			waveCompletedView.x = bounds.width / 2 - 
												(waveCompletedView.width / 2);
			waveCompletedView.y = bounds.height / 2 - waveCompletedView.height;
			
			//timer.reset();
			tickCount = 0;
		}		
		
		//todo: use a third party libary for this event chaining
		private var deathPauseTimer:Timer;
		private function destroyShip():void
		{			
			createExplosion(ship.x, ship.y);
			
			trace("destroyShip : " + ship);
			
			ship.removeEventListener(FireEvent.FIRE, onShipFire);
			ship.destroy();
			
			ship.dealloc();
			
			removeChild(ship);
			ship = null;
			
			lives--;
			
			
			for each(var enm:Enemy in enemies)
			{
				enm.target = null;
			}
			
			if(lives < 0)
			{
				System.gc();
				var e:ScreenControlEvent = 
							new ScreenControlEvent(ScreenControlEvent.GAME_OVER);
				dispatchEvent(e);
			}
			else
			{
				
				scoreBar.lives = lives;

				if(enemies.length < 1)
				{
					waveCompleted();
					return;
				}
				
				deathPauseTimer = new Timer(2000);
				deathPauseTimer.addEventListener(TimerEvent.TIMER, 
														onDeathPauseTimer, 
														false, 0, true);
				deathPauseTimer.start();
				
				//trace("destroyShip : remove enterframe");
				//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				//timer.stop();

				tickManager.removeEventListener(TickEvent.TICK, onTick);
			}
		}		
		
		
		private function removeItem(s:Sprite):void
		{
			/*
			if(!this.contains(s))
			{
				return;
			}
			*/
			
			s.removeEventListener(GameObjectEvent.DESTROYED, onEnemyDestroyed);
			s.removeEventListener(GameObjectEvent.REMOVE, onRemoveItem);
			
			removeChild(s);
							
			if(s is UFOEnemy)
			{
				ufoOnStage = false;
			}				
									
			var index:int;
			if(s is Missile)
			{
				index = missiles.indexOf(s);
				missiles.splice(index, 1);
			}
			else if(s is Enemy)
			{
				index = enemies.indexOf(s);
				enemies.splice(index, 1);
				
				if(enemies.length < 1 && lives > -1)
				{
					waveCompleted();
				}
			}
			
			IMemoryManageable(s).dealloc();
		}		
		
		/*********** game engine events ***********/
		
		private function onExplosionComplete(e:GameEvent):void
		{
			var explosion:Explosion = Explosion(e.target);
			explosion.removeEventListener(GameEvent.EXPLOSION_COMPLETE, 
														onExplosionComplete);
			removeChild(explosion);
			explosion.dealloc();
		}
		
		private function onWaveViewCompleted(e:GameEvent):void
		{
			removeChild(waveCompletedView);
			waveCompletedView.removeEventListener(GameEvent.WAVE_VIEW_COMPLETE, 
											onWaveViewCompleted);
			waveCompletedView = null;
			
			if(!ship)
			{
				initShip();
			}
			
			wave++;
			scoreBar.wave = wave;
			
			//removeAllMissiles();
			addEnemies();
			
			//timer.start();
			tickManager.addEventListener(TickEvent.TICK, onTick, false, 0, true);
		}
		
		private function onDeathPauseTimer(e:TimerEvent):void
		{						
			resetEnemies();
			initShip();			
			
			deathPauseTimer.stop();
			deathPauseTimer.removeEventListener(TimerEvent.TIMER, 
															onDeathPauseTimer);
			deathPauseTimer.addEventListener(TimerEvent.TIMER, 
													onSpawnShipTimer, false, 
													0, true);
			
			deathPauseTimer.delay = 2000;
			deathPauseTimer.start();
		}
		
		private function onSpawnShipTimer(e:TimerEvent):void
		{
			//should we reuse this?
			deathPauseTimer.stop();
			deathPauseTimer.removeEventListener(TimerEvent.TIMER, 
															onSpawnShipTimer);
			deathPauseTimer = null;
			
			restartEnemies();
			
			//addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			
			//timer.reset();
			//timer.start();
			tickCount = 0;
			tickManager.addEventListener(TickEvent.TICK, onTick, false, 0, true);
		}		
		
		private function onEnemyDestroyed(e:GameObjectEvent):void
		{
			var enemy:Enemy = Enemy(e.target);
			
			createExplosion(enemy.x + enemy.width, enemy.y + enemy.height);
			
			score += enemy.pointValue;
			scoreBar.score = score;			
			
			removeItem(enemy);
		}

		private function onShipFire(e:FireEvent):void
		{
			var m:Missile = e.projectile;
			
			m.x = ship.x;
			m.y = ship.y;
			
			m.addEventListener(GameObjectEvent.REMOVE, onRemoveItem, false, 0, true);
			
			addChild(m);
			missiles.push(m);
		}
		
		private function onRemoveItem(e:GameObjectEvent):void
		{
			removeItem(Sprite(e.target));
		}	
	}

}

