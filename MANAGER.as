package core 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class MANAGER 
	{
		//----- PRIVATE PARTS
		private var states	:Array = [];
		
		//----- PUBIC VARS
		public var cstate:STATE;
		
		
		//---
			public static var THIS:MANAGER;
		public function MANAGER(stage:Stage) 
		{
				if (THIS == null)
				{
					THIS = this;
				}
				else
				{
					throw Error("Why the fuck are you initializing the manager twice? It's a singleton you jackass.");
				}
			//---
			
				stage.addEventListener(Event.ENTER_FRAME, 		tick);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, 	keydown);
				stage.addEventListener(KeyboardEvent.KEY_UP, 	keyup);
				stage.addEventListener(MouseEvent.MOUSE_DOWN, 	mousedown);
				stage.addEventListener(MouseEvent.MOUSE_UP, 	mouseup);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, 	mousemove);
			//--- FUCK WITH THE STAGE
			
			registerState(new STATE("main"));
		}
//-------

		public function registerState	(state:STATE):void
		{
			var j:int = states.indexOf(state.name);
				if (j == -1)
				{
					states.push(state.name, state);
					cstate = state;
					cstate.init();
				}
				else
				{
					throw Error("Ooops, tried to register a state which already exists!");
				}
			//---
		}
//-------

		public function gotoState	(name:String):void
		{
			var i:int = states.indexOf(name);
				if (i != -1)
				{
					cstate.invokeEvent("losefocus");
					cstate = states[i + 1];
					cstate.invokeEvent("gainfocus");
					
				}
				else
				{
					throw Error("Fuck! That state doesn't exist so I cannot switch to it :(");
				}
			//---
		}
//-------

		private function tick		(e:Event):void
		{
			cstate.tick();
		}
//-------

		private function keydown	(e:KeyboardEvent):void
		{
				cstate.invokeEvent("keydown",
					e.keyCode,
					e.shiftKey,
					e.altKey,
					e.ctrlKey
				);
			//---
		}
//-------

		private function keyup		(e:KeyboardEvent):void
		{
				cstate.invokeEvent("keyup",
					e.keyCode,
					e.shiftKey,
					e.altKey,
					e.ctrlKey
				);
			//---
		}
//-------

		private function mousedown	(e:MouseEvent):void
		{
				cstate.invokeEvent("mousedown",
					e.shiftKey,
					e.altKey,
					e.ctrlKey
				);
			//---
		}
//-------

		private function mouseup	(e:MouseEvent):void
		{
				cstate.invokeEvent("mouseup",
					e.shiftKey,
					e.altKey,
					e.ctrlKey
				);
			//---
		}
//-------

		private function mousemove	(e:MouseEvent):void
		{
				cstate.invokeEvent("mousemove",
					e.shiftKey,
					e.altKey,
					e.ctrlKey
				);
			//---
		}
//-------
	}
}
