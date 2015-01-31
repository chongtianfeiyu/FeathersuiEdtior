package feditor.utils 
{
	/**
	 * ...
	 * @author gray
	 */
	public class ScriptParser 
	{
		public static const THIS:String = "this";
		public var func:Array;
		public var args:Array;
		
		public function ScriptParser() 
		{
			
		}
		
		public function execute(owner:Object,thisArg:*):* 
		{
			var p:* = null;
			
			if (func[0] == THIS && thisArg)
			{
				owner = thisArg;
			}
			
			for each (var name:String in func) 
			{
				if (owner.hasOwnProperty(name))
				{
					p = owner[name];
					owner = p;
				}
				else 
				{
					return;
				}
			}
			
			if (thisArg != null && thisArg != undefined && args)
			{
				for (var i:int = 0; i < args.length; i++) 
				{
					if (args[i] == THIS)
					{
						args[i] = thisArg;
					}
				}
			}
			
			if (p == null || (p as Function) == false) return;
			
			return Function(p).apply(null, args);
		}
		
		public static function parse(str:String):ScriptParser 
		{
			var func:Array = str.match(/[\w\.]+(?=\()/);
			var args:Array = str.match(/(?<=\()[\w]+(?=\))/);
			if (!func || !args) return null;
			if (func) func = String(func[0]).split(".");
			if (args) args = String(args[0]).split(",");
			
			var result:ScriptParser = new ScriptParser();
			result.func = func;
			result.args = args;
			
			for (var i:int = 0; i < args.length; i++) 
			{
				args[i] = parseString(args[i]);
			}
			
			return result;
		}
		
	}

}