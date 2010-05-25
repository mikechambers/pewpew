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

package com.mikechambers.pewpew.ui.views
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	//import gs.TweenLite;	
	
	//commented out a bunch of stuff so Tween library is not compiled
	//since it is not being used right now
	
	public class ViewManager
	{
		//public static const SLIDE_FROM_RIGHT:String = "slideFromRight";
		public static const NO_TRANSITION:String = "noTransition";
		
		private var _overlayView:DisplayObject;
		private var _currentView:DisplayObject;
		private var _container:DisplayObjectContainer;
		
		public function ViewManager(container:DisplayObjectContainer)
		{
			_container = container;
		}
		
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
					/*
					case SLIDE_FROM_RIGHT:
					{
						TweenLite.to(_currentView, 1, {x:containerWidth * -1, 
										onComplete:tweenOutComplete, onCompleteParams:[_currentView]});
						break;
					}
					*/
					case NO_TRANSITION:
					{
						//_container.removeChild(_currentView);
						tweenOutComplete(_currentView);
						break;
					}
					default:
					{
						trace("ViewManager We should never get here.");
					}
				}
			}
			
			if(!_container.contains(view))
			{
				_container.addChild(view);
				
				switch(transitionType)
				{
					/*
					case SLIDE_FROM_RIGHT:
					{
						TweenLite.to(view, 1, {x:0, onComplete:tweenInComplete, onCompleteParams:[view]});
						break;
					}
					*/
					case NO_TRANSITION:
					{
						view.x = 0;
						tweenInComplete(view);
						break;
					}
					default:
					{
						trace("ViewManager We should never get here.");
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

