//FENDER-BENDER TEAM!!!
///Premium Members:
///  ElJabali, Sami	19059321	cs186-au
///  Tenorio, Yuly	19077774	cs186-as



package bufmgr;

import java.util.LinkedList;

import global.GlobalConst;
import global.AbstractBufMgr;
import global.AbstractBufMgrFrameDesc;
import global.AbstractBufMgrReplacer;
import global.PageId;

import exceptions.BufferPoolExceededException;
import exceptions.InvalidFrameNumberException;
import exceptions.PagePinnedException;
import exceptions.PageUnpinnedException;


/**
 * This class should implement a Clock replacement strategy.
 */
public class MRU extends BufMgrReplacer
{
	
	LinkedList<Integer> UnpinnedQ;
	int buffer_count;
	
	
	
	public MRU() 
	{
		UnpinnedQ= new LinkedList<Integer>();
	/*	buffer_count = 1;
		for (int i=0; i<NUMBUF; i++)
		{
			if (mgr.getFrameTable()[i].getPinCount() == 0)
				UnpinnedQ.addLast(mgr.getFrameTable()[i].getPageNo());
		}*/
	};
	
	public MRU(AbstractBufMgr b) 
	{
		setBufferManager(b);
		buffer_count = 1;
		
		UnpinnedQ= new LinkedList<Integer>();
		for (int i=0; i<b.getNumBuffers(); i++)
			if (b.getFrameTable()[i].getPinCount() == 0)
				UnpinnedQ.addLast(i);
		
	};
	
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
	public void pin(int frameNo) throws InvalidFrameNumberException
	{
		//if page is in UnpinnedQ queue, remove it
		boolean in_queue = UnpinnedQ.contains(frameNo);
		int i=0;
		if (in_queue)
		{
			while (! UnpinnedQ.get(i).equals(frameNo))
			{
				i++;
			}
			UnpinnedQ.remove(i);
		}
	};

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
	public boolean unpin(int frameNo) throws InvalidFrameNumberException,
			PageUnpinnedException
	{ 
		if (frameNo >= 0 && (mgr.getFrameTable()[frameNo].getPinCount() == 0))
		{
			//PageId thePgId = mgr.getFrameTable()[frameNo].getPageNo();
			UnpinnedQ.addFirst(frameNo);
		}
		else
			throw new InvalidFrameNumberException(new Exception(""), "InvalidFrameNumberException");
	
		return true; 
	};

	/**
	 * Frees and unpins a page in the buffer pool.
	 * 
	 * @param frameNo
	 *            frame number of the page.
	 * @throws PagePinnedException
	 *             if the page is pinned.
	 */
	public void free(int frameNo) throws PagePinnedException
	{
		//if page is in UnpinnedQ queue, remove it
		//BufMgr wouldn't call this method unless page is unpinned, so this doesn't throw the exception
		boolean in_queue = UnpinnedQ.contains(frameNo);
		int i=0;
			
		if (mgr.getFrameTable()[frameNo].getPinCount() == 0)
		{
			if (in_queue)
			{
				while (!(UnpinnedQ.get(i) == frameNo))
				{
					i++;
				}
				UnpinnedQ.remove(i);
				UnpinnedQ.addFirst(frameNo);
			}
			else
			{
				throw new PagePinnedException(new Exception(""), "PagePinnedException"); 
			}
		}
		else
		{
			throw new PagePinnedException(new Exception(""), "PagePinnedException");
		}

	};

	/** Must pin the returned frame. */
	public int pick_victim() throws BufferPoolExceededException,
			PagePinnedException
	{
		int q_size = UnpinnedQ.size();
		
		if (q_size == 0 && buffer_count == 0)    /*****************/
		{
			for (int i=0; i<mgr.getNumBuffers(); i++)
			{
				if (mgr.getFrameTable()[i].getPinCount() == 0)
					UnpinnedQ.addLast(i);
			}
			buffer_count = mgr.getNumBuffers();				
		}
		
		if (UnpinnedQ.size() == 0)     
		{
			throw new BufferPoolExceededException(new Exception(""), "BufferPoolExceededException");
		}else
		{
			int victim = UnpinnedQ.removeFirst();
			
			if (victim >= 0 && victim < mgr.getNumBuffers())
				return victim;
			else
				return -1;
		}		
	}

	/** Retruns the name of the replacer algorithm. */
	public String name()
	{ return "MRU"; };

	/**
	 * Counts the unpinned frames (free frames) in the buffer pool.
	 * 
	 * @returns the total number of unpinned frames in the buffer pool.
	 */
	public int getNumUnpinnedBuffers()
	{ 
		return UnpinnedQ.size();
	};
}
