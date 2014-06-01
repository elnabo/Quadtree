package com.elnabo.quadtree;

class Box
{
	/** Left x value of the box. */
	public var x:Int;
	/** Top y value of the box. */ 
	public var y:Int;
	
	/** Width of the box. */
	public var width:Int;
	/** Height of the box.*/
	public var height:Int;
	
	/**
	 * Create a new box.
	 * 
	 * @param x  The top left corner x value.
	 * @param y  The top left corner y value.
	 * @param width  The width.
	 * @param height  The height.
	 */
	public function new(x:Int,y:Int,width:Int,height:Int)
	{
		this.x = x;
		this.y = y;
		
		this.width = width;
		this.height = height;
	}
	
	/**
	 * Clone the box.
	 * 
	 * @return A clone of this box.
	 */
	public function clone() : Box
	{
		return new Box(x,y,width,height);
	}
	
	/**
	 * Test if the box is contained in this.
	 * 
	 * @param other  The other box.
	 * 
	 * @return True if the other is in this box, else false.
	 */
	public function contains(other:Box):Bool
	{
		if (other == null)
			return false;
			
		return x <= other.x &&
				y <= other.y &&
				x + width >= other.x + other.width &&
				y + height >= other.y + other.height;
	}
	
	
	/**
	 * Test if this box is inside an other.
	 * 
	 * @param other  The other box;
	 * 
	 * @return True if this box is inside the other box, else false.
	 */
	public function inside(other:Box):Bool
	{
		if (other == null)
			return false;
			
		return other.x <= x &&
				other.y <= y &&
				other.x + other.width >= x + width &&
				other.y + other.height >= y + height;
	}
	
	/**
	 * Test if the two box intersect.
	 * 
	 * @param other  The other box.
	 * 
	 * @return True if the two box intersect, else false.
	 */
	public function intersect(other:Box):Bool
	{
		if (other == null)
			return false;
			
		return x + width > other.x &&
				y + height > other.y &&
				x < other.x + other.width &&
				y < other.y + other.height;
	}
	
	/**
	 * Clamp a box to fit in this.
	 * 
	 * @param other  The other box.
	 * 
	 * @return A clamped version of the other box, null if they don't 
	 * intersect.
	 */
	public function clamp(other:Box):Box
	{
		
		if (!intersect(other))
			return null;
		
		if (contains(other))
			return other;
		
		var startX:Int = (x < other.x) ? other.x : Std.int(Math.max(x,other.x));
		var startY:Int = (y < other.y) ? other.y : Std.int(Math.max(y,other.y));
		var endX:Int = (x + width  > other.x+other.width) ? other.x + other.width : Std.int(Math.max(other.x, x + width));
		var endY:Int = (y + height  > other.y+other.height) ? other.y + other.height : Std.int(Math.max(other.y, y + height));
		
		return new Box(startX,startY,endX - startX, endY - startY);
		
	}
}
