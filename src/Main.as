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
	import com.mikechambers.pewpew.engine.GameArea;
	import com.mikechambers.pewpew.engine.SoundManager;
	import com.mikechambers.pewpew.ui.FPSView;
	import com.mikechambers.pewpew.ui.GameMenu;
	import com.mikechambers.pewpew.ui.GameOverScreen;
	import com.mikechambers.pewpew.ui.ProfileManager;
	import com.mikechambers.pewpew.ui.events.ScreenControlEvent;
	import com.mikechambers.pewpew.ui.views.ViewManager;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.mikechambers.sgf.time.TickManager;
	
	//todo : need to do a check for when running in browser
	import flash.desktop.NativeApplication;

	public class Main extends MovieClip
	{
		private static const SPLASH_SCREEN:String = "splashScreen";
		private static const GAME_SCREEN:String = "gameScreen";
		private static const GAME_OVER_SCREEN:String = "gameOverScreen";
		
		private static const PROFILE_SCREEN:String = "profileScreen";
		private static const SELECT_SCREEN:String = "selectScreen";
		private static const HIGH_SCORE_SCREEN:String = "highScoreScreen";
		private static const STATS_SCREEN:String = "statsScreen";
		
		//instantiated within FLA
		private var gameArea:GameArea;
		
		//main game menu view
		private var gameMenu:GameMenu;
		
		//game over view
		private var gameOverScreen:GameOverScreen;
				
		//manages views and transitions between views
		private var viewManager:ViewManager;
		
		//background
		public var background:MovieClip;
		
		//title graphic
		private var titleGraphic:TitleGraphic;
		
		//tick manager that manages all time intervals
		private var tickManager:TickManager;
		
		//where the game should automatically resume when the app is activated.
		//Used to pause the app when it goes into the background
		private var _shouldResumeOnActivate = false;		
		
		//main entry point for applications
		public function Main()
		{
			
			//note stage quality is always set to best in Adobe AIR. Have it 
			//set to HIGH here in case we are running in browser
			stage.quality = StageQuality.HIGH;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//listen for when we are added to the stage
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);			
			
			//cache bitmap so it can be accelerated
			background.cacheAsBitmap = true;
			
			//dont need mouse events on background, so disable for performance
			background.mouseEnabled = false;
			background.mouseChildren = false;	
																		
			stop();
		}
		
		/************** Event Handlers *******************/
		
		//called when instance is added to the stage
		private function onStageAdded(e:Event):void
		{
			//create a view manager to hander view stack and transitions
			viewManager = new ViewManager(this);
			
			//dont need to listen for this anyone
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			
			//instantiate tickManager if it hasnt been instantiated already
			if(!tickManager)
			{
				tickManager = TickManager.getInstance();
			}
			
			//Initialize SoundManager which handles all game sounds
			SoundManager.getInstance();

			//todo: check for running in browser
			//listen for Activate and Deactivate events so we know when the app goes into the background
			//This is mostly so we can pause the app when the user "closes" it on Android, and reactivate it
			//when they bring the app forward again.
			//Supported in AIR 2.5
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate)
			
			//instantiate the game menu
			gameMenu = new GameMenu();
			
			//listen for when the play button is pressed
			gameMenu.addEventListener(ScreenControlEvent.PLAY, onPlaySelect);


			//add the gameMenu to the viewManager / display it
			viewManager.displayView(gameMenu, ViewManager.NO_TRANSITION);			
			
			//display the title graphic
			//this should probably be moved to the viewManager, but right now, viewManager
			//only supports displaying one view at a time.
			displayTitleGraphic();
		}
		
		//called when the app regains focus.
		//on Android, called when the app is opened after it has been pushed to the background
		private function onActivate(event:Event):void
		{
			//check to see if we should automatically resume the game
			if(_shouldResumeOnActivate)
			{
				tickManager.start();
			}
		}
		
		//called when the application is pushed to the background. On Android
		//this is when the app is "closed" (it is actually still running).
		private function onDeactivate(event:Event):void
		{
			//check and see if we are currently running. If so, save that state.
			_shouldResumeOnActivate = tickManager.isRunning;
			
			
			if(tickManager.isRunning)
			{
				//if running, pause everything
				tickManager.pause();
			}
		}
		
		//called when the user presses the play button
		private function onPlaySelect(e:ScreenControlEvent):void
		{			
			//check to see if the gameOverScreen is up?
			if(gameOverScreen)
			{
				//if so, remove it
				//note : this should be refactored
				viewManager.removeOverlayView();
			}
			
			//see if we have instantiated the game area yet
			if(!gameArea)
			{
				//if not, instantiate it
				gameArea = new GameArea();
				
				//listen for the game over event
				gameArea.addEventListener(ScreenControlEvent.GAME_OVER, onGameOver);
			}
			
			//add the gameArea to the viewManager and display list
			viewManager.displayView(gameArea, ViewManager.NO_TRANSITION);
			
			//start the game
			gameArea.start();
			
			//remove title graphic
			displayTitleGraphic(false);
		}
		
		//called when the game ends
		private function onGameOver(e:ScreenControlEvent):void
		{			
			//see if we have instantiated the gameOverScreen
			if(!gameOverScreen)
			{
				//if not, instantiate it
				gameOverScreen = new GameOverScreen();
				
				//listen for when the user presses the play button
				gameOverScreen.addEventListener(ScreenControlEvent.PLAY, onPlaySelect);
			}
			
			//display the gameOverScreen
			viewManager.displayOverlayView(gameOverScreen);
		}

		/************ General Functions ***************/
		
		//handles the display of the title graphic for the game
		private function displayTitleGraphic(display:Boolean = true):void
		{
			
			//see if we have instantiated it yet
			if(!titleGraphic)
			{
				//if not, instantiate it and save it
				titleGraphic = new TitleGraphic();
			}
			
			//see if title is on the display list
			var isOnStage:Boolean = contains(titleGraphic);
			
			
			//if we want to hardware accelerate the titleGraphic, then
			//we need to keep it on the display list. We should consider
			//hiding it instead of completely removing it. Removing it, will
			//cause it to be removed from texture memory, which will require that
			//it be recached the next time we add it.
			//right now, becuase not much goes on when the title graphic is up, 
			//we are not accelerating it
			
			if(display)
			{
				if(!isOnStage)
				{
					addChild(titleGraphic);
				}
			}
			else
			{
				if(isOnStage)
				{
					removeChild(titleGraphic);
				}
			}
		}			
		
	}
	
}