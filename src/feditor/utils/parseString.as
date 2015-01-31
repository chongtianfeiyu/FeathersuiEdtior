package feditor.utils 
{
	public function parseString(str:String):*
	{
		var hex:*;
		if (str == "false")
		{
			return false;
		}
		else if (str == "true")
		{
			return true;
		}
		else if (str == "null")
		{
			return null;
		}
		else if (str == "undefined")
		{
			return undefined;
		}
		else if (/\^0x[0-9]+$/.test(str))
		{
			hex = parseInt(str,16);
			if (isNaN(hex)==false) return hex;
		}
		else if (/^[0-9]+[\.]?[0-9]+$/.test(str))
		{
			return parseFloat(str);
		}
		
		return str;
	}
}