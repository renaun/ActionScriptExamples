package com 
{
	import flash.events.Event;
	/**
	 * @author matgroves
	 */
	 
	public class WasteCenter
	{
		// E V E N T S ---------------------------------------------------//
			
		// P R O P E R T I E S ---------------------------------------------//
	
		private static var _instance : WasteCenter;
		
		/* 
		 * Game Center API can be purchased from: http://www.milkmangames.com/blog/
		 * I have excluded it from this src code :/
		 * Its a great API though!
		 * 
		 */
		private var gameCenter : *;
		private var isLoggedIn : Boolean;
		
		public static function get instance():WasteCenter
		{
			if(!_instance)_instance = new WasteCenter();
			return _instance; 
		}
		
		public var leaderBoardID		:String = "WasteInvadersLeaderBoard";
		
		// G E T T E R S / S E T T E R S -------------------------------------//
		
		// C O N S T R U C T O R  ---------------------------------------//
		
		function WasteCenter()
		{
		}

		public function init() : void
		{
			/*
			// check if gameCenter is supported.  note that this just determines platform support- iOS- and NOT whether
			// the user's os version has gamecenter installed!
			if (!GameCenter.isSupported())
			{
				trace("GameCenter is not supported on this platform.");
				return;
			}
			
			
			trace("initializing GameCenter...");		
			try
			{			
				gameCenter=GameCenter.create();
			}
			catch (e:Error)
			{
				trace("ERROR:"+e.message);
				return;
			}
			trace("GameCenter Initialized.");
			
			trace("Checking os level support...");
			
			// GameCenter doesn't work on iOS versions < 4.1, so always check this first!
			if (!gameCenter.isGameCenterAvailable())
			{
				trace("this ios version doesn't have gameCenter.");
				return;
			} 
			trace("Game Center is ready.");
			
			gameCenter.addEventListener(GameCenterEvent.AUTH_SUCCEEDED,onAuthSucceeded);
			gameCenter.addEventListener(GameCenterErrorEvent.AUTH_FAILED,onAuthFailed);
			
			gameCenter.addEventListener(GameCenterEvent.LEADERBOARD_VIEW_OPENED,onViewOpened);
			gameCenter.addEventListener(GameCenterEvent.LEADERBOARD_VIEW_CLOSED,onViewClosed);
			
			gameCenter.addEventListener(GameCenterEvent.SCORE_REPORT_SUCCEEDED,onScoreReported);
			gameCenter.addEventListener(GameCenterErrorEvent.SCORE_REPORT_FAILED,onScoreFailed);
			 
			GameCenter.gameCenter.authenticateLocalUser();
			 * 
			 */
		}

		
			
		public function showScores():void
		{
			//if(isLoggedIn)gameCenter.showLeaderboardForCategory(leaderBoardID);
		}
		
		public function submitScore(score:int):void
		{
			//if(isLoggedIn)gameCenter.reportScoreForCategory(score, leaderBoardID);
		}
		
		private function onScoreFailed(event : Event) : void
		{
			trace("SCORE! failed")
		}

		private function onScoreReported(event : Event) : void
		{
			trace("SCORE! successfully added")
		}
		
		private function onViewClosed(event : Event) : void
		{
			
		}

		private function onViewOpened(event : Event) : void
		{
			
		}

		private function onAuthFailed(event : Event) : void
		{
			trace("Game center login fail")
		}

		private function onAuthSucceeded(event : Event) : void
		{
			//trace("Game center login success")
			//isLoggedIn = true;
		}
		
		// P U B L I C ---------------------------------------------------//
		
		// P R I V A T E -------------------------------------------------//
		
		// H A N D L E R S -----------------------------------------------//
	}
}