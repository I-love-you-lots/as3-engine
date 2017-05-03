package core 
{
	
	public class OBJ 
	{
		//----- PUBIC VARS
		public var manager	:MANAGER = MANAGER.THIS;
		public var state	:STATE;
		public var layer	:int;
		public var frequency:int;
		
		
		public function OBJ(_layer:int, _frequency:int) 
		{
				state = manager.cstate;
				state.addProcess(tick, _layer, _frequency);
			//--- DO STATE-Y THINGUMS
			
				layer 		= _layer;
				frequency 	= _frequency;
			//---
		}
//-------

		public function kill():void
		{
				state.removeProcess(tick, layer);
			//---
		}
//-------

		public function tick():void
		{
			
		}
//-------
	}
}