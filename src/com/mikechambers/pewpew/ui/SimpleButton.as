package com.mikechambers.pewpew.ui
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class SimpleButton extends Sprite
	{
		public var labelField:TextField;
		
		public function SimpleButton()
		{
			mouseChildren = false;
		}
		
		public function set label(v:String):void
		{
			labelField.text = v;
		}
		
		public function get label():String
		{
			return labelField.text;
		}
	}
}