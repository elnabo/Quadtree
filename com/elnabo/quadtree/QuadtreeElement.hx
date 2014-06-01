package com.elnabo.quadtree;

/**
 * Interface providing access to hitbox.
 */
interface QuadtreeElement
{
	/**
	 * Get the box/hitbox of the element.
	 * 
	 * @return The box of the element. 
	 */
	function box() : Box;
}
