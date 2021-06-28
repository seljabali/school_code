package global;

public abstract class AbstractBufMgrFrameDesc implements GlobalConst
{
	/**
	 * Returns the pin count of a certain frame page.
	 * 
	 * @return the pin count number.
	 */
	abstract public int getPinCount();

	/**
	 * Increments the pin count of a certain frame page when the page is pinned.
	 * 
	 * @return the incremented pin count.
	 */
	abstract public int pin();

	/**
	 * Decrements the pin count of a frame when the page is unpinned. If the pin
	 * count is equal to or less than zero, the pin count will be zero.
	 * 
	 * @return the decremented pin count.
	 */
	abstract public int unpin();

	/**
	 * 
	 */
	abstract public int getPageNo();

	/**
	 * the dirty bit, 1 (TRUE) stands for this frame is altered, 0 (FALSE) for
	 * clean frames.
	 */
	abstract public boolean isDirty();
}
