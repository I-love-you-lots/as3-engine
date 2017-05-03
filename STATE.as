package core 
{
	
	public class STATE 
	{
		//----- PRIVATE PARST
		private var events	 	:Array = [];
		private var triggers 	:Array = [];
		private var processes	:Array = [];
		private var processdel	:Array = [];
		private var processflag	:Boolean;
		
		//----- PUBIC VARS
		public var manager	:MANAGER = MANAGER.THIS;
		public var name		:String;
		
		
		public function STATE(_name:String)
		{
				name = _name;
			//---
		}
//-------

		public function init():void
		{
				addEvent("keydown");
				addEvent("keyup");
				addEvent("mousedown");
				addEvent("mouseup");
				addEvent("mousemove");
				addEvent("losefocus");
				addEvent("gainfocus");
			//---
		}
//-------

		public function addTrigger		(name:String, funct:Function):void
		{
			var i:int = triggers.indexOf(name);
				if (i == -1)
				{
					triggers.push(name, funct);
				}
			//---
		}
//-------

		public function pullTrigger		(name:String, ...args):*
		{
			var i:int = triggers.indexOf(name);
				if (i != -1)
				{
					return triggers.splice(i, 2)[1].apply(null, args);
				}
			//---
		}
//-------

		public function addEvent		(name:String, ...listeners):void
		{
			var i:int = events.indexOf(name);
				if (i == -1)
				{
					events.push(name, true, listeners);
				}
			//---
		}
//-------

		public function removeEvent		(name:String):void
		{
			var i:int = events.indexOf(name);
				if (i != -1)
				{
					events.splice(i, 3);
				}
			//---
		}
//-------

		public function addListener		(name:String, funct:Function):void
		{
			var i:int = events.indexOf(name);
				if (i != -1)
				{
					events[i + 2].push(funct);
				}
			//---
		}
//-------

		public function removeListener	(name:String, funct:Function):void
		{
			var i:int = events.indexOf(name);
				if (i != -1)
				{
					var j:int = events[i + 2].indexOf(funct);
						if (j != -1)
						{
							events[i + 2].splice(j, 1);
						}
					//---
				}
			//---
		}
//-------

		public function pauseEvent		(name:String):void
		{
			var i:int = events.indexOf(name);
				if (i != -1)
				{
					events[i + 1] = false;
				}
			//---
		}
//-------

		public function unpauseEvent	(name:String):void
		{
			var i:int = events.indexOf(name);
				if (i != -1)
				{
					events[i + 1] = true;
				}
			//---
		}
//-------

		public function invokeEvent		(name:String, ...args):*
		{
			var i:int = events.indexOf(name);
			var pos:int;
			var len:int;
			var ret:Array = [];
			var pl1:*;
			
				if (i != -1)
				{
						if (events[i + 1])
						{
							len = events[i + 2].length;
								while (pos < len)
								{
									pl1 = events[i + 2][pos].apply(null, args);
										if (pl1 != null)
										{
											ret.push(pl1);
										}
									//---
									pos++;
								}
							//---
						}
					//---
				}
			//---
			
			i = ret.length;
				if (i > 1)
				{
					return ret;
				}
				else if (i == 1)
				{
					return ret[0];
				}
			//---
		}
//-------

		public function addProcess		(funct:Function, _l:int, _f:int):*
		{
				if (processes[_l] == undefined)
				{
					processes[_l] = [];
				}
			//---
			
			var i:int = processes[_l].indexOf(funct);
				if (i == -1)
				{
					processes[_l].push(funct, _f, _f);
				}
			//---
		}
//-------

		public function removeProcess	(funct:Function, _l:int):void
		{
				if (processes[_l] != undefined)
				{
					var i:int = processes[_l].indexOf(funct);
						if (i != -1)
						{
							processes[_l][i] 		= undefined;
							processes[_l][i + 1] 	= undefined;
							processes[_l][i + 2] 	= undefined;
							processdel[_l] = true;
							processflag = true;
						}
					//---
				}
			//---
		}
//-------

		public function editFrequency	(funct:Function, _l:int, _f:int):void
		{
				if (processes[_l] != undefined)
				{
					var i:int = processes[_l].indexOf(funct);
						if (i != -1)
						{
							processes[_l][i + 1] = _f;
							processes[_l][i + 2] = _f;
						}
					//---
				}
			//---
		}
//-------

		public function tick			():void
		{
			var l_pos:int;
			var l_len:int = processes.length;
			var p_pos:int;
			var p_len:int;
			
				if (processflag)
				{	
						for (var i:int = processdel.length - 1; i >-1; i--)
						{
								if (processdel[i])
								{
									processdel[i] = false;
									processes[i] = prurgeArray(processes[i]);
								}
							//---
						}
					//---
					processflag = false;
				}
			//---
			
				while (l_pos < l_len)
				{
						if (processes[l_pos] != undefined)
						{
							p_pos = 0;
							p_len = processes[l_pos].length;
								while (p_pos < p_len)
								{
										if (processes[l_pos][p_pos + 1] == 0)
										{
											processes[l_pos][p_pos]();
											processes[l_pos][p_pos + 1] = processes[l_pos][p_pos + 2]
										}
										else
										{
											processes[l_pos][p_pos + 1]--;
										}
									//---
									p_pos += 3;
								}
							//---
						}
					//---
					l_pos++;
				}
			//---
		}
//-------

		private function prurgeArray(arr:Array):Array
		{
			var pos:int;
			var len:int 	= arr.length;
			var ret:Array 	= [];
				while (pos < len)
				{
						if 		(arr[pos] != undefined)
						{
								if (!(arr[pos] is Array))
								{
									ret.push(arr[pos]);
								}
								else
								{
									ret.push(prurgeArray(arr[pos]));
								}
							//---
						}
					//---
					pos++;
				}
			//---
			return ret;
		}
//-------
	}
}