package com.mikechambers.pewpew.utils
{

	public final class NumberUtil
	{
	
		//todo: we could make different versions for differnt num types
		//i.e. formatInt, formatUint
		//if performance is an issue
		public static function formatNumber(value:Number):String
		{			
			var vStr:String = String(value);
			
			return vStr.replace(/(\d)(?=(\d\d\d)+$)/g, "$1,");
		}
	
	}

}

