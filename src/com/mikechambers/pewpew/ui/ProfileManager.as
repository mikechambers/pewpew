package com.mikechambers.pewpew.ui
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.mikechambers.pewpew.ui.events.ScreenControlEvent;
	
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