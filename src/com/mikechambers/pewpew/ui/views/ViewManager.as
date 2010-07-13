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
	

	/*
		Class that manages the view stack.
	
		Has support for animation transitions between views, although
		it is not being used right now.
	
		The animation / slide transition were removed for performance
		reasons. Too slow on iPHone before hardware acceleration was
		added. They should work fine now on the android devices, especially
		once hardware acceleration is added.
	
		Note, that the tween code is commented out, because on the iphone
		the code would be compiled into the binary, making it larger. It is commented
		out so it would not add additional size.
	
		//todo: remove comments from code, and readd support to animating views in and out
	*/
	public class ViewManager
	{
		//transition type: slide from right to main screen
		//public static const SLIDE_FROM_RIGHT:String = "slideFromRight";
		
		//transition type: no transition, replace previous view
		public static const NO_TRANSITION:String = "noTransition";
		
		private var _overlayView:DisplayObject;
		private var _currentView:DisplayObject;
		private var _container:DisplayObjectContainer;
		
		//constructor, takes the DisplayObjectContainer instances where the
		//views will be parented
		public function ViewManager(container:DisplayObjectContainer)
		{
			_container = container;
		}
		
		//display the specified view, with the specified transition type
		public function displayView(view:DisplayObject, transitionType:String):void
		{
			//place the new view just off stage to the right
			//todo: this is unecessary right now since we dont do the slide
			//transition
			var containerWidth:Number = _container.stage.stageWidth;
			//view.x = view.getBounds(_container).width;
			view.x = containerWidth;
			view.y = 0;
			
			//check if we are currently displaying a view
			if(_currentView)
			{
				//tween view out. not supported right now
				//_container.removeChild(_currentView);
				//TweenLite.to(_currentView, 1, {x:_currentView.getBounds(_container).width * -1, y:0});
				
				//check what transition type was specified
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
						//specified an unknown transition type
						trace("ViewManager : Unknown transition specified : " + transitionType);
					}
				}
			}
			
			//check and see if the view is already parented in the containter
			if(!_container.contains(view))
			{
				//if it is not, add it
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
						//move it into position
						view.x = 0;
						tweenInComplete(view);
						break;
					}
					default:
					{
						trace("ViewManager : Unknown transition specified : " + transitionType);
					}
				}				
			}
			
			//_currentView = view;
		}
		
		//called when a new move is moved into position
		private function tweenInComplete(displayObject:DisplayObject):void
		{
			_currentView = displayObject;
		}
		
		//called when an old view is moved off stage
		private function tweenOutComplete(displayObject:DisplayObject):void
		{
			//remove it from containter
			_container.removeChild(displayObject);
		}
		
		//we might not need overlays. Might be able to just put the high score view
		//in the gameArea
		//this adds support for overlaying another view on top of a current one.
		//todo: this was a quick hack, and should probably be rethought
		public function displayOverlayView(view:DisplayObject):void
		{
			//if the containter does not already contain the overlay view
			if(!_container.contains(view))
			{
				//add it
				_container.addChild(view);
			}
			
			_overlayView = view;
		}
		
		//removes the overlay item
		public function removeOverlayView():void
		{
			//if the container contains the overlayView
			if(_container.contains(_overlayView))
			{
				//remove it
				_container.removeChild(_overlayView);
			}
			
			_overlayView = null;
		}
		
	}
}

