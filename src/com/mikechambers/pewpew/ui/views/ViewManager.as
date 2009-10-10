package com.mikechambers.pewpew.ui.views
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class ViewManager
	{
		public static const SLIDE_FROM_RIGHT:String = "slideFromRight";
		public static const NO_TRANSITION:String = "noTransition";
		
		private var _overlayView:DisplayObject;
		private var _currentView:DisplayObject;
		private var _container:DisplayObjectContainer;
		
		public function ViewManager(container:DisplayObjectContainer)
		{
			_container = container;
		}
		
		import gs.TweenLite;
		public function displayView(view:DisplayObject, transitionType:String):void
		{
			var containerWidth:Number = _container.stage.stageWidth;
			//view.x = view.getBounds(_container).width;
			view.x = containerWidth;
			view.y = 0;
			
			if(_currentView)
			{
				//_container.removeChild(_currentView);
				//TweenLite.to(_currentView, 1, {x:_currentView.getBounds(_container).width * -1, y:0});
				
				switch(transitionType)
				{
					case SLIDE_FROM_RIGHT:
					{
						TweenLite.to(_currentView, 1, {x:containerWidth * -1, 
										onComplete:tweenOutComplete, onCompleteParams:[_currentView]});
						break;
					}
					case NO_TRANSITION:
					{
						//_container.removeChild(_currentView);
						tweenOutComplete(_currentView);
					}
				}
			}
			
			if(!_container.contains(view))
			{
				_container.addChild(view);
				
				switch(transitionType)
				{
					case SLIDE_FROM_RIGHT:
					{
						TweenLite.to(view, 1, {x:0, onComplete:tweenInComplete, onCompleteParams:[view]});
						break;
					}
					case NO_TRANSITION:
					{
						view.x = 0;
						tweenInComplete(view);
					}
				}				
			}
			
			//_currentView = view;
		}
		
		private function tweenInComplete(displayObject:DisplayObject):void
		{
			_currentView = displayObject;
		}
		
		private function tweenOutComplete(displayObject:DisplayObject):void
		{
			_container.removeChild(displayObject);
		}
		
		//we might not need overlays. Might be able to just put the high score view
		//in the gameArea
		public function displayOverlayView(view:DisplayObject):void
		{
			if(!_container.contains(view))
			{
				_container.addChild(view);
			}
			
			_overlayView = view;
		}
		
		public function removeOverlayView():void
		{
			if(_container.contains(_overlayView))
			{
				_container.removeChild(_overlayView);
			}
			
			_overlayView = null;
		}
		
	}
}

