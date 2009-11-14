//
//  DisplayObjectUtil
//
//  Created by Mike Chambers on 2009-11-13.
//  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
//


package com.mikechambers.pewpew.utils
{
	import flash.display.Sprite;

	public final class DisplayObjectUtil
	{
		public static function hitTestCircle(clip1:Sprite, clip2:Sprite):Boolean
		{
			var dx:Number = clip2.x - clip1.x;
			var dy:Number = clip2.y  - clip1.y ;

			var radii:Number = ((clip1.width * .5) + (clip2.width * .5));
			return ((dx * dx) + (dy * dy) < radii * radii);
		}
	}
}