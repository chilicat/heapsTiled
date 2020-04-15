package tiled.com;

class TLayer  {
	public var id : Int;
	public var opacity:Float = 1.0;
	public var name : String = "";
	public var wid : Int;
	public var hei : Int;

	var props : TProps;
	var tmap : TMap;

	var ids : Array<Int> = [];
	var xFlip : Map<Int,Bool> = new Map();
	var yFlip : Map<Int,Bool> = new Map();
	var content : Map<Int,Int> = new Map();

	public function new(tmap:TMap, name:String, id:Int, w, h, opacity:Float) {
		this.tmap = tmap;
		this.name = name;
		this.id = id;
		this.opacity = opacity;
		wid = w;
		hei = h;
	}

	public inline function isXFlipped(cx:Int, cy:Int) return xFlip.get(cx+cy*wid) == true;
	public inline function isYFlipped(cx:Int, cy:Int) return yFlip.get(cx+cy*wid) == true;

	inline function checkBit(v:UInt, bit:Int) : Bool {
		return v&(1<<bit) != 0;
	}

	inline function clearBit(v:UInt, bit:Int) : UInt {
		return v & ( 0xFFFFFFFF - (1<<bit) );
	}

	public function setIds(a:Array<UInt>) {
		// Check for flip bits
		xFlip = new Map();
		yFlip = new Map();
		for(i in 0...a.length) {
			if( checkBit(a[i], 31) ) {
				xFlip.set(i, true);
				a[i] = clearBit(a[i], 31);
			}
			if( checkBit(a[i],30) ) {
				yFlip.set(i,true);
				a[i] = clearBit(a[i], 30);
			}
		}

		// Store IDs
		ids = a;
		content = new Map();
		var i = 0;
		for(id in ids) {
			if( id>0 )
				content.set(i, id);
			i++;
		}
	}

	public inline function getIds() return ids;

	public function hasTile(cx,cy) return content.exists(cx + cy*wid);
	public function getGlobalTileId(cx,cy) {
		return !hasTile(cx,cy) ? -1 : content.get(cx+cy*wid);
	}
	public function getLocalTileId(cx,cy) {
		if( !hasTile(cx,cy) )
			return -1;
		var id = content.get(cx+cy*wid);
		id -= tmap.getTileSet(id).baseId;
		return id;
	}

	public function getTileProps(cx:Int, cy:Int) : TProps {
		if( !hasTile(cx,cy) )
			return null;
		var id = content.get(cx+cy*wid);
		var tset = tmap.getTileSet(id);
		id -= tset.baseId;
		return tset.getTileProps(id);
	}

	public function getProps() : TProps {
		return props;
    }
    
	public function setProps(props : TProps) {
		this.props = props;
	}

	@:deprecated("Use getProps().set(name, v)")
	public function setProp(name, v) {
		props.set(name, v);
	}

	@:deprecated("Use getProps().has(name)")
	public inline function hasProp(name) {
		return props.has(name);
	}

	@:deprecated("Use getProps().getStr(name)")
	public function getPropStr(name) : Null<String> {
		return props.getStr(name);
	}

	@:deprecated("Use getProps().getInt(name)")
	public function getPropInt(name) : Int {
		return props.getInt(name);
	}

	@:deprecated("Use getProps().getFloat(name)")
	public function getPropFloat(name) : Float {
		return props.getFloat(name);
	}

	@:deprecated("Use getProps().getBool(name)")
	public function getPropBool(name) : Bool {
		return props.getBool(name);
	}
}
