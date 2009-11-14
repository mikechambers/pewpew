//
//  DisplayObjectUtil
//
//  Created by Mike Chambers on 2009-11-13.
//  Copyright (c) 2009 __MyCompanyName__. All rights reserved.
//


package com.mikechambers.pewpew.utils
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public final class DisplayObjectUtil
	{
		public static function hitTestCircle(bounds1:Rectangle, bounds2:Rectangle):Boolean
		{
			var dx:Number = bounds2.x  - bounds1.x;
			var dy:Number = bounds2.y  - bounds1.y ;

			var radii:Number = ((bounds1.width * .5) + (bounds2.width * .5));
			return ((dx * dx) + (dy * dy) < radii * radii);
		}
	}
}