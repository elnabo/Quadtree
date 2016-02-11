package com.elnabo.quadtree;

/**
 * Quadtree data structure.
 */
class Quadtree<T : QuadtreeElement>
{
	/** List of entities in this node. */
	private var entities:Array<T> = new Array<T>();
	/** The boundaries of this node. */
	private var boundaries:Box;
	/** The depth of this node. */
	private var depth:Int = 0;
	/** The maximum depth of this tree */
	private var maxDepth:Int;
	/**
	 * The minimum number of elements in a node
	 * before splitting. *
	 */
	private var minElementBeforeSplit:Int;
	
	// Children 
	/** Top left child. */
	private var topLeft:Quadtree<T> = null;
	/** Top right child. */
	private var topRight:Quadtree<T> = null;
	/** Bottom right child. */
	private var bottomRight:Quadtree<T> = null;
	/** Bottom left child. */
	private var bottomLeft:Quadtree<T> = null;
	
	/**
	 * Create a new quadtree.
	 * 
	 * @param boundaries The bounds of the tree.
	 * @param minElementBeforeSplit The minimum number element in a node before spliting.
	 * @param maxDepth  The maximum depth of the tree.
	 * 
	 */
	public function new(boundaries:Box, ?minElementBeforeSplit:Int=5, ?maxDepth:Int=2147483647)
	{
		this.boundaries = boundaries.clone();
		this.minElementBeforeSplit = minElementBeforeSplit;
		this.maxDepth = maxDepth;
	}
	
	/**
	 * Add an element to the tree.
	 * 
	 * @param element The element.
	 * 
	 * @return True if the element was added, else false.
	 */
	public function add(element:T):Bool
	{
		if (!boundaries.contains(element.box()))
			return false;
			
		// Try to add it in a children.
		if (depth<maxDepth && (topLeft != null || entities.length >=  minElementBeforeSplit))
		{
			if (topLeft == null)
				split();
			
			if (topLeft.add(element)) { return true;}
			if (topRight.add(element)) { return true;}
			if (bottomRight.add(element)) { return true;}
			if (bottomLeft.add(element)) { return true;}
		}
		
		// Add here.
		entities.push(element);
		return true;
	}
	
	/**
	 * Return all the element who collide with a given box.
	 * 
	 * @param box  The box.
	 * 
	 * @return The list of element who collide with the box.
	 */
	public function getCollision(box:Box):Array<T>
	{
		if (!boundaries.intersect(box))
			return new Array<T>();
		
		var res:Array<T> = new Array<T>();
		
		// Add all from this level who intersect;
		for (e in entities)
		{
			if (box.intersect(e.box()))
			{
				res.push(e);
			}
		}
		
		if (topLeft == null)
			return res;
			
		// Test if children contain some.
		res = res.concat(topLeft.getCollision(box));
		res = res.concat(topRight.getCollision(box));
		res = res.concat(bottomRight.getCollision(box));
		return res.concat(bottomLeft.getCollision(box));
		
	}
	
	/**
	 * Create a new tree node.
	 * 
	 * Only used to create children.
	 * 
	 * @param boundaries The boundaries of the new node.
	 * 
	 * @return A new tree.
	 */
	private function getChildTree(boundaries:Box):Quadtree<T>
	{
		var child:Quadtree<T> = new Quadtree<T>(boundaries,minElementBeforeSplit,maxDepth);
		child.depth = depth + 1;
		return child;
	}
	
	/**
	 * Split the current node to add children.
	 * Rebalance the current entities if they can't fit in a lower node.
	 */
	private function split():Void
	{
		var leftWidth:Int = Std.int(boundaries.width/2);
		var topHeight:Int = Std.int(boundaries.height/2);
		
		var rightStartX:Int = boundaries.x + leftWidth + 1;
		var rightWidth:Int = boundaries.width - (leftWidth +1);
		
		var botStartY:Int = boundaries.y + topHeight + 1;
		var botHeight:Int = boundaries.height - (topHeight + 1);
		
		topLeft = getChildTree(new Box(boundaries.x, boundaries.y, leftWidth, topHeight));
		topRight = getChildTree(new Box(rightStartX,boundaries.y,rightWidth,topHeight));
		bottomRight = getChildTree(new Box(rightStartX, botStartY,rightWidth, botHeight));
		bottomLeft = getChildTree(new Box(boundaries.x,botStartY,leftWidth, botHeight));
		
		balance();		
	}
	
	/**
	 * Move entities who can fit in a lower node.
	 */
	private function balance():Void
	{
		for (e in entities)
		{
			if (topLeft.add(e) || topRight.add(e) ||
				bottomRight.add(e) || bottomLeft.add(e))
			{
				entities.remove(e);
			}
		}
	}
	
	/**
	 * Remove an element of the tree.
	 * Doesn't change its datastructure.
	 * 
	 * @param e The element.
	 * 
	 * @return True if the element has been removed, else false.
	 */
	public function remove(e:T):Bool
	{
		if (topLeft == null)
			return entities.remove(e);
			
		return entities.remove(e)||	topLeft.remove(e)||
			topRight.remove(e)||bottomRight.remove(e)||
			bottomLeft.remove(e);
	}
}
