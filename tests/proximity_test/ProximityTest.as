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

package
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import com.gskinner.utils.PerformanceTest;
	
	import com.mikechambers.pewpew.engine.ProximityManager;
	import com.gskinner.sprites.ProximityManager;
	
	import flash.geom.Rectangle;

	public class ProximityTest extends Sprite
	{
	
		private const ITERATIONS:uint = 1000;
		private const GRID_SIZE:uint = 35;
		
		private var pmg:com.gskinner.sprites.ProximityManager;
		private var pmm:com.mikechambers.pewpew.engine.ProximityManager;
		
		private var items:Vector.<DisplayObject>;
		
		private var checkSprite:Sprite;
		public function ProximityTest()
		{
			super();
			
			var bounds:Rectangle = stage.getBounds(this);
			
			pmg = new com.gskinner.sprites.ProximityManager(GRID_SIZE);
			pmm = new com.mikechambers.pewpew.engine.ProximityManager(GRID_SIZE, bounds);
			
			items = new Vector.<DisplayObject>();
			
			for(var i:int = 0; i < 5000; i++)
			{
				var obj:Sprite = new Sprite();
				obj.x = Math.random() * bounds.width;
				obj.y = Math.random() * bounds.height;
				
				obj.graphics.beginFill( 0xff9933 , 1 );
				obj.graphics.drawCircle( 0 , 0 , 15 );
				
				items.push(obj);
				addChild(obj);
			}
			
			checkSprite = new Sprite();
			
			checkSprite.graphics.beginFill( 0xFF00FF , 1 );
			checkSprite.graphics.drawCircle( 0 , 0 , 15 );
			
			checkSprite.x = bounds.width / 2;
			checkSprite.y = bounds.height / 2;
			
			addChild(checkSprite);
			
			runTests();		
		}
	
        private function runTests():void
        {
	
			pmg.refresh(items);
			pmm.update(items);
            var perfTest:PerformanceTest = PerformanceTest.getInstance();
                perfTest.out = out;

                perfTest.testFunction(testGrantPD, ITERATIONS, "testGrantPD", "");
                perfTest.testFunction(testMeshPD, ITERATIONS, "testMeshPD", "");
        }

		private function testGrantPD():void
		{
			//pmg.refresh(items);
			pmg.getNeighbors(checkSprite);
		}
		
		private function testMeshPD():void
		{
			//pmm.update(items);
			pmm.getNeighbors(checkSprite);
		}

		private function out(str:*):void
		{
			trace(str);
			output.appendText(str + "\n");
		}
	}
}

