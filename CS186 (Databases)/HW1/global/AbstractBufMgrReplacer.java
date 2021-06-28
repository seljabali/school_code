package global;

import exceptions.BufferPoolExceededException;
import exceptions.InvalidFrameNumberException;
import exceptions.PagePinnedException;
import exceptions.PageUnpinnedException;


/**
 * A super class for buffer pool replacement algorithm. It describes which frame
 * to be picked up for replacement by a certain replace algorithm.
 */
public abstract class AbstractBufMgrReplacer implements GlobalConst
{

	/**
	 * Pins a candidate page in the buffer pool.
	 * 
	 * @param frameNo
	 *            frame number of the page.
	 * @throws InvalidFrameNumberException
	 *             if the frame number is less than zero or bigger than number
	 *             of buffers.
	 * @return true if successful.
	 */
	abstract public void pin(int frameNo) throws InvalidFrameNumberException;

	/**
	 * Unpins a page in the buffer pool.
	 * 
	 * @param frameNo
	 *            frame number of the page.
	 * @throws InvalidFrameNumberException
	 *             if the frame number is less than zero or bigger than number
	 *             of buffers.
	 * @throws PageUnpinnedException
	 *             if the page is originally unpinned.
	 * @return true if successful.
	 */
	abstract public boolean unpin(int frameNo) throws InvalidFrameNumberException,
			PageUnpinnedException;

	/**
	 * Frees and unpins a page in the buffer pool.
	 * 
	 * @param frameNo
	 *            frame number of the page.
	 * @throws PagePinnedException
	 *             if the page is pinned.
	 */
	abstract public void free(int frameNo) throws PagePinnedException;

	/** Must pin the returned frame. */
	abstract public int pick_victim() throws BufferPoolExceededException,
			PagePinnedException;

	/** Retruns the name of the replacer algorithm. */
	abstract public String name();

	/**
	 * Counts the unpinned frames (free frames) in the buffer pool.
	 * 
	 * @returns the total number of unpinned frames in the buffer pool.
	 */
	abstract public int getNumUnpinnedBuffers();


	public AbstractBufMgrReplacer()	{}
	/** Creates a replacer object. */
	public AbstractBufMgrReplacer(AbstractBufMgr javamgr)
	{
		setBufferManager(javamgr);
	}

	/**
	 * Sets the buffer manager to be eqaul to the buffer manager in the
	 * argument, gets the total number of buffer frames, and mainstains the head
	 * of the clock.
	 * 
	 * @param mgr
	 *            the buffer manage to be assigned to.
	 */
	public void setBufferManager(AbstractBufMgr mgrArg)
	{
		mgr = mgrArg;
		
		int numBuffers = mgr.getNumBuffers();
		state_bit = new int[numBuffers];
		
		for (int index = 0; index < numBuffers; ++index)
			state_bit[index] = Available;		
	}

	/** The state of a frame. */
	protected int state_bit[] = null;

	/** A buffer manager object. */
	protected AbstractBufMgr mgr = null;

	// constant values indicating state
	public static final int Available = 12;
	public static final int Referenced = 13;
	public static final int Pinned = 14;
}
