package tiled.com;

import haxe.xml.*;

class TProps {
    
    private var internal : Map<String,String>;

	/*
	<properties>
		<property name="name1" value="value1"/>
		<property name="name2" value="value2"/>
		...
	</properties>
	*/
    public static function fromXML(xml : Xml) {
        var n = new haxe.xml.Access(xml);
        var props = new TProps();
        if(n.hasNode.properties) {
            for(p in n.node.properties.nodes.property) {
                props.set(p.att.name, p.att.value);
            }
        }
        return props;
    }

    public function new() {
        this.internal = new Map();
    }

    public function set(name, v) {
		internal.set(name, v);
	}
    public inline function has(name) {
		return internal.exists(name);
	}

	public function getStr(name) : Null<String> {
		return internal.get(name);
	}

	public function getInt(name) : Int {
		var v = getStr(name);
		return v==null ? 0 : Std.parseInt(v);
	}

	public function getFloat(name) : Float {
		var v = getStr(name);
		return v==null ? 0 : Std.parseFloat(v);
	}

	public function getBool(name) : Bool {
		var v = getStr(name);
		return v=="true";
    }
}