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

package com.mikechambers.pewpew.ui
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.mikechambers.pewpew.ui.events.ScreenControlEvent;
	
	/*
		Begining of a class to manager profiles.
	
		Not really implimented and not currently used.
	
		graphics defined in FLA
	*/
	public class ProfileManager extends Sprite
	{
		public var labelField:TextField;
		
		public var profileButton1:SimpleButton;
		//public var profileButton2:SimpleButton;
		//public var profileButton3:SimpleButton;
		
		public function ProfileManager()
		{
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
		}
		
		public function onStageAdded(e:Event):void
		{
			profileButton1.label = "mesh";
			//profileButton2.label = "Profile 2";
			//profileButton3.label = "New";
			
			profileButton1.addEventListener(MouseEvent.CLICK, onButtonClick, 
																	false, 
																	0, true);
																	
			addEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved, false, 
																	0, true);
		}
		
		private function onStageRemoved(e:Event):void
		{
			profileButton1.removeEventListener(MouseEvent.CLICK, onButtonClick);
			
			/*
			profileButton2.removeEventListener(MouseEvent.CLICK, 
															onButtonClick);
															
			profileButton3.removeEventListener(MouseEvent.CLICK, onButtonClick);
			*/
			
			removeEventListener(Event.REMOVED_FROM_STAGE, onStageRemoved);
			
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
		}		
		
		private function onButtonClick(e:MouseEvent):void
		{
			var sce:ScreenControlEvent = 
									new ScreenControlEvent(
											ScreenControlEvent.PROFILE_SELECTED
											);
			sce.profileName = SimpleButton(e.target).label;
			
			dispatchEvent(sce);
		}
		
	}
}