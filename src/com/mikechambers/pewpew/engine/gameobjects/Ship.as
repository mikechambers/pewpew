package com.mikechambers.pewpew.engine.gameobjects
{
	import com.mikechambers.pewpew.engine.events.FireEvent;
	import com.mikechambers.pewpew.utils.MathUtil;
	
	import com.mikechambers.pewpew.engine.events.TickEvent;		
	import com.mikechambers.pewpew.ui.GameController;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	
	import com.mikechambers.pewpew.engine.pools.GameObjectPool;
	import com.mikechambers.pewpew.engine.SoundManager;		
	
	import flash.geom.Point;
	
	import com.mikechambers.pewpew.engine.TickManager;

	public class Ship extends GameObject
	{
		private static const SPEED:Number = 3.5 * (TickManager.BASE_FPS_RATE / TickManager.FPS_RATE);
		
		private const FIRE_INTERVAL:int = int(TickManager.FPS_RATE / 4);
		
		private var fireTickCounter:int = 0;
		
		private var missileSound:PewSound;
		
		private var _gameController:GameController;
		
		private var gameObjectPool:GameObjectPool;

		public function Ship()
		{			
			if(!missileSound)
			{
				missileSound = PewSound(SoundManager.getInstance().getSound(SoundManager.FIRE_SOUND));
			}
			
			gameObjectPool = GameObjectPool.getInstance();
		}
				
		public function set gameController(value:GameController):void
		{
			this._gameController = value;
		}

		public override function start():void
		{
			super.start();

			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 
																	0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0,
																		true);
		}
		
		public override function pause():void
		{
			super.pause();

			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public function destroy():void
		{
			var s:ExplosionSound = ExplosionSound(SoundManager.getInstance().getSound(SoundManager.EXPLOSION_SOUND));
			s.play();
		}
		
		CONFIG::DEBUG
		{
			private function shipOnTick():void{}
		}
		
		protected override function onTick(e:TickEvent):void
		{			
			CONFIG::DEBUG
			{
				shipOnTick();
			}
			
			e.stopPropagation();

			if(!mouseDown)
			{
				return;
			}
			
			fireTickCounter++;
			if(!(fireTickCounter % FIRE_INTERVAL))
			{
				fire();
			}
	
			var radians:Number = _gameController.angle;
			this.rotation = MathUtil.radiansToDegrees(radians);
			
			var vx:Number = Math.cos(radians) * SPEED;
			var vy:Number = Math.sin(radians) * SPEED;
	
			var tempX:Number = this.x + vx;
			var tempY:Number = this.y + vy;	
	
			if(tempX < bounds.left ||
				tempX > bounds.right ||
				tempY < bounds.top ||
				tempY > bounds.bottom)
			{
				return;
			}					
						
			this.x += vx;
			this.y += vy;	
		}		
		
		public override function dealloc():void
		{
			super.dealloc();
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			target = null;
		}
		
		private var mouseDown:Boolean = false;
		private function onMouseDown(e:MouseEvent):void
		{	
			e.stopPropagation();
			mouseDown = true;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{	
			e.stopPropagation();
			fireTickCounter = 0;	
			mouseDown = false;	
		}		
		
		private function fire():void
		{			
			missileSound.play();
			
			var m:Missile = Missile(gameObjectPool.getGameObject(Missile));
			m.initialize(bounds);
			m.angle = this.rotation;
			
			var e:FireEvent = new FireEvent(FireEvent.FIRE);
			e.projectile = m;
			dispatchEvent(e);
		}
		
		/*
		var p1:Point = new Point();
		var p2:Point = new Point();
		private function getAngleToTarget():Number
		{			
			p1.x = __target.x;
			p1.y = __target.y;
			p2.x = this.x;
			p2.y = this.y;
			
			return MathUtil.getAngleBetweenPoints(p1, p2);
		}
		*/
	}
}