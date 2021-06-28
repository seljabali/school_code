//FENDER-BENDER TEAM!!!
///Premium Members:
///  ElJabali, Sami	19059321	cs186-au
///  Tenorio, Yuly	19077774	cs186-as


package bufmgr;

import java.io.IOException;

import global.GlobalConst;
import global.AbstractBufMgr;
import global.AbstractBufMgrFrameDesc;
import global.AbstractBufMgrReplacer;

import exceptions.BufferPoolExceededException;
import exceptions.InvalidFrameNumberException;
import exceptions.PagePinnedException;
import exceptions.PageUnpinnedException;

public class Clock extends BufMgrReplacer
{
	private int index;
	public int [] Ref_table;
	
	public Clock() 
	{
		index = 0;
		Ref_table =  new int [NUMBUF];
		
		for (int i = 0; i<= (NUMBUF-1); i++)
			Ref_table[i]=0;
	};
	
	public Clock(AbstractBufMgr b) 
	{
		setBufferManager(b);
		//Initializing the reference bit array
		Ref_table =  new int [b.getNumBuffers()];
		for (int i = 0; i<= (b.getNumBuffers()- 1); i++)
			Ref_table[i]=0;
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
		if (frameNo < 0 || frameNo > mgr.getNumBuffers())
			throw new InvalidFrameNumberException(new Exception(""), "InvalidFrameNumberException");
		else
		{
			Ref_table[frameNo]=0;  //turn ref off
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
		if (frameNo >= 0 && frameNo < mgr.getNumBuffers())
		{
			Ref_table[frameNo] = 1; // setting it on
			return true;
		}
		else
		{
			throw new InvalidFrameNumberException(new Exception(""), "InvalidFrameNumberException");	
		}
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
		if (mgr.getFrameTable()[frameNo].getPinCount() == 0)
		{
			if (frameNo >= 0 && frameNo < mgr.getNumBuffers())
			{
				Ref_table[frameNo] = 0;      // setting it off
			}
		}
		else
		{
			throw new PagePinnedException(new Exception(""), "InvalidFrameNumberException");	
		}		
		
	};

	/** Must pin the returned frame. */
	public int pick_victim() throws BufferPoolExceededException,
			PagePinnedException
	{		
		boolean unref = false; 								//flag to check if there's an unreferenced entry
		int init_index = index;
		int thelength = mgr.getNumBuffers();
		do 
		{
			if (index > thelength -1)
				index = 0;
			else if (mgr.getFrameTable()[index].getPinCount() >= 1)  	//pinned
					index++;
			else if (Ref_table[index] == 1)    							//page unpinned
				{
					Ref_table[index] = 0;
					unref = true;							//flag tells us there is at least one unref entry
					index++;
				}
			else 
			{
				index++;
				return index-1;
			}
		} while ( unref  || init_index != index );
			
		return -1;
	
	} ;

	/** Retruns the name of the replacer algorithm. */
	public String name()
	{ 
		return "Clock"; 
	};

	/**
	 * Counts the unpinned frames (free frames) in the buffer pool.
	 * 
	 * @returns the total number of unpinned frames in the buffer pool.
	 */
	public int getNumUnpinnedBuffers()
	{ 
		int count=0;
		for (int i = 0; i < mgr.getNumBuffers() ; i++)
			if (mgr.getFrameTable()[i].getPinCount() == 0)
				count++;
		
		return count;		
		
	};
}
