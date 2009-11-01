package com.mikechambers.pewpew.utils
{
	import flash.geom.Point;
	
	public final class MathUtil
	{
		//todo: reuse
		public static function degreesToRadians(degrees:Number):Number
		{
			return (degrees * Math.PI / 180);
		}
		
		//todo: reuse
		public static function radiansToDegrees(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
		
		//returns angle in radians
		public static function getAngleBetweenPoints(p1:Point, p2:Point):Number
		{
			var dx:Number = p1.x - p2.x;
			var dy:Number = p1.y - p2.y;
			var radians:Number = Math.atan2(dy, dx);
			return radians;
		}
		
		public static function disanceBetweenPoints(p1:Point, p2:Point):Number
		{
			var dx:Number = p1.x - p2.x;
			var dy:Number = p1.y - p1.y;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			
			return dist;
		}
	}
}

