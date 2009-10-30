package
{
	import com.mikechambers.pewpew.ui.events.ScreenControlEvent;
	import com.mikechambers.pewpew.ui.ProfileManager;
	import com.mikechambers.pewpew.ui.GameMenu;
	import com.mikechambers.pewpew.ui.GameOverScreen;
	import com.mikechambers.pewpew.engine.GameArea;
	import com.mikechambers.pewpew.ui.views.ViewManager;
	
	import flash.display.StageQuality;
	
	import com.mikechambers.pewpew.ui.FPSView;

	import com.mikechambers.pewpew.engine.TickManager;
	import com.mikechambers.pewpew.engine.events.TickEvent;
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;

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
		private var profileManager:ProfileManager;
		private var gameMenu:GameMenu;
		private var gameOverScreen:GameOverScreen;
		
		public var background:MovieClip;
		
		public var fpsView:Sprite;
		
		private var titleGraphic:TitleGraphic;
		
		private var viewManager:ViewManager;
		
		private var tickManager:TickManager;
		
		//import flash.display.StageQuality;
		public function Main()
		{
			stage.quality = StageQuality.HIGH;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			addEventListener(Event.ADDED_TO_STAGE, onStageAdded, false, 0, 
																		true);
			
			tickManager = TickManager.getInstance();
			tickManager.start();					
				
			background.cacheAsSurface = true;
			//background.mouseEnabled = false;
			//background.mouseChildren = false;	
																		
			stop();
		}
		
		private function displayTitleGraphic(display:Boolean = true):void
		{
			if(!titleGraphic)
			{
				titleGraphic = new TitleGraphic();
			}
			
			var isOnStage:Boolean = contains(titleGraphic);
			
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
		
		
		
		private function onStageAdded(e:Event):void
		{
			viewManager = new ViewManager(this);
			
			removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
						
			profileManager = new ProfileManager();
			
			profileManager.addEventListener(ScreenControlEvent.PROFILE_SELECTED,
												onProfileSelected);
												
			viewManager.displayView(profileManager, ViewManager.NO_TRANSITION);
			

			
			fpsView = new FPSView();
			fpsView.y = stage.stageHeight - fpsView.height;
			addChild(fpsView);
			
			
			displayTitleGraphic();
		}
		
		private function onProfileSelected(e:ScreenControlEvent):void
		{
			//gotoAndStop(SELECT_SCREEN);
			
			if(!gameMenu)
			{
				gameMenu = new GameMenu();
				gameMenu.addEventListener(ScreenControlEvent.PLAY, onPlaySelect);
			}
			
			viewManager.displayView(gameMenu, ViewManager.NO_TRANSITION);
			
			displayTitleGraphic();
		}
		
		private function onPlaySelect(e:ScreenControlEvent):void
		{
			//gotoAndStop(GAME_SCREEN);
			
			if(gameOverScreen)
			{
				viewManager.removeOverlayView();
			}
			
			if(!gameArea)
			{
				gameArea = new GameArea();
				gameArea.addEventListener(ScreenControlEvent.GAME_OVER, onGameOver);
			}
			
			viewManager.displayView(gameArea, ViewManager.NO_TRANSITION);
			gameArea.start();
			
			displayTitleGraphic(false);
		}
		
		private function onGameOver(e:ScreenControlEvent):void
		{
			//gotoAndStop(GAME_OVER_SCREEN);
			
			if(!gameOverScreen)
			{
				gameOverScreen = new GameOverScreen();
				gameOverScreen.addEventListener(ScreenControlEvent.PLAY, onPlaySelect);
			}
			
			viewManager.displayOverlayView(gameOverScreen);
		}
	}
}