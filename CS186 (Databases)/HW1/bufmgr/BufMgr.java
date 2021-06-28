//FENDER-BENDER TEAM!!!
///Premium Members:
///  ElJabali, Sami	19059321	cs186-au
///  Tenorio, Yuly	19077774	cs186-as


/*  File BufMgr,java */

package bufmgr;

import java.io.IOException;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map;

import global.AbstractBufMgr;
import global.AbstractBufMgrFrameDesc;
import global.PageId;
import global.SystemDefs;
import diskmgr.Page;

import exceptions.BufMgrException;
import exceptions.BufferPoolExceededException;
import exceptions.DiskMgrException;
import exceptions.FileIOException;
import exceptions.HashEntryNotFoundException;
import exceptions.HashOperationException;
import exceptions.InvalidBufferException;
import exceptions.InvalidFrameNumberException;
import exceptions.InvalidPageNumberException;
import exceptions.InvalidReplacerException;
import exceptions.PageNotFoundException;
import exceptions.PageNotReadException;
import exceptions.PagePinnedException;
import exceptions.PageUnpinnedException;
import exceptions.ReplacerException;

public class BufMgr extends AbstractBufMgr
{
	// Replacement policies to be implemented
	public static final String Clock = "Clock";
	public static final String LRU = "LRU";
	public static final String MRU = "MRU";
	
	// Total number of buffer frames in the buffer pool. */
	private int numBuffers;

	// This buffer manager keeps all pages in memory! 
	private Hashtable<PageId, byte[]> pageIdToPageData = new Hashtable<PageId,byte[]>();
	
	// An array of Descriptors one per frame. 
	private BufMgrFrameDesc[] frameTable = new BufMgrFrameDesc[NUMBUF];

	public BufMgr(int numbufs, String replacerArg) throws InvalidReplacerException
	{
		numBuffers = numbufs;
		setReplacer(replacerArg);
		((BufMgrReplacer)replacer).setBufferManager(this);
		
		for (int i = 0; i< NUMBUF; i++)
		{
			frameTable[i] = new BufMgrFrameDesc(new PageId(-1));
		}	
	}

	public BufMgr() throws InvalidReplacerException
	{
		numBuffers = 5;
		replacer = new Clock(this);
		
		for (int i = 0; i< NUMBUF; i++)
			frameTable[i] = new BufMgrFrameDesc(new PageId(-1));
	}

	public int FindFrameInPool(PageId page_id)
	{
		for (int i = 0; i< NUMBUF; i++)
		{
			if (frameTable[i].getPageId().getPid() != -1)
				{
					if (frameTable[i].getPageId().getPid() == page_id.getPid())
						return i;
				}
		}
		return -1;
	}
	/**
	 * Check if this page is in buffer pool, otherwise find a frame for this
	 * page, read in and pin it. Also write out the old page if it's dirty
	 * before reading. If emptyPage==TRUE, then actually no read is done to bring
	 * the page in.*/
	public void pinPage(PageId pin_pgid, Page page, boolean emptyPage)
			throws ReplacerException, HashOperationException,
			PageUnpinnedException, InvalidFrameNumberException,
			PageNotReadException, BufferPoolExceededException,
			PagePinnedException, BufMgrException, IOException
	{
		byte [] data = new byte[MAX_SPACE];
		
		int index = FindFrameInPool(pin_pgid);
		
		if (index >= 0)  	//if page found in BP
		{
			data = (byte[]) pageIdToPageData.get(pin_pgid);
			page.setpage(data);
			frameTable[index].pin();
			replacer.pin(index);						//notifying the replacer the page's been pinned
		}
		else											//if page not in BP, find a victim 
		{												//in the BP and replace it by the requested pg
			//if (!emptyPage)
				
				int victim;
				try
				{
					victim = (int) replacer.pick_victim();   //index in the frameTable array
				}catch (Exception e) 
				{
					throw new BufferPoolExceededException(e, "BufferPoolExceededException");
				};
				if (victim <0)
				{
					throw new InvalidFrameNumberException(new Exception(""), "InvalidFrameNumberException");
				}		
				else
				{
					//When a victim is found in the BP
					if (frameTable[victim].isDirty())	//if dirty, flush it 
					{	
						byte [] victim_data = new byte[MAX_SPACE];
						victim_data = (byte[]) pageIdToPageData.get(frameTable[victim].getPageId());
						try 
						{
							SystemDefs.JavabaseDB.write_page(frameTable[victim].getPageId(), new Page(victim_data));
						}catch (Exception e)
						{
							throw new IOException ("BUFMGR: WRITE_PAGE_ERROR");         
						}  
												
					}	
					//Now read in the requested page (pin it)and store it in the BP (hash table and frametable)
					try
					{
						SystemDefs.JavabaseDB.read_page(pin_pgid, page);
					} catch (Exception e)
					{
						throw new PageNotReadException(e,"BUFMGR: DB_READ_PAGE_ERROR");
					} 		
					//Remove from hashtable once we are done with the victim
					pageIdToPageData.remove(frameTable[victim].getPageId());
					
					pageIdToPageData.put(new PageId(pin_pgid.getPid()), page.getpage());					
					
					//frameTable[victim].Set_pageId(pin_pgid);
					frameTable[victim].Set_pageId(new PageId(pin_pgid.getPid()));
					
					frameTable[victim].pin();					
				}			
		}			
	}
	/**
	 * To unpin a page specified by a pageId. If pincount>0, decrement it and if
	 * it becomes zero, put it in a group of replacement candidates. if
	 * pincount=0 before this call, return error.
	 * 
	 * @param globalPageId_in_a_DB
	 *            page number in the minibase.
	 * @param dirty
	 *            the dirty bit of the frame
	 * 
	 * @exception ReplacerException
	 *                if there is a replacer error.
	 * @exception PageUnpinnedException
	 *                if there is a page that is already unpinned.
	 * @exception InvalidFrameNumberException
	 *                if there is an invalid frame number .
	 * @exception HashEntryNotFoundException
	 *                if there is no entry of page in the hash table.
	 */

	public void unpinPage(PageId PageId_in_a_DB, boolean dirty)
			throws ReplacerException, PageUnpinnedException,
			HashEntryNotFoundException, InvalidFrameNumberException
	{
		
		byte [] data = new byte[MAX_SPACE];
		try
		{
			data = (byte[]) pageIdToPageData.get(PageId_in_a_DB);
		}catch (Exception e)
		{
			throw new HashEntryNotFoundException(e,"HashEntryNotFoundException");      
		};
		int index = FindFrameInPool(PageId_in_a_DB);
		
		if (index  < 0)
		{
			throw new InvalidFrameNumberException(new Exception(""), "InvalidFrameNumberException");
		}
		else											//try to unpin the page
		{
			if (frameTable[index].getPinCount() <= 0)
			{
				throw new PageUnpinnedException(new Exception(""), "PagePinnedException"); 
			}
			else 
			{
				if (dirty)  							//if dirty, flush it
				{
					try 
					{
						SystemDefs.JavabaseDB.write_page(PageId_in_a_DB, new Page(data));
					}catch (Exception e)
					{
						throw new PageUnpinnedException (e, "IOException");  
					};
					frameTable[index].makeClean();
				}
				
				if (frameTable[index].getPinCount() > 0 )
				{
				 	frameTable[index].unpin();
				 	if ( frameTable[index].getPinCount() == 0)
				 	{
				 		replacer.unpin(index);     		//letting the replacer know we're unpinning
				 	}
				}else 
				{
					throw new PageUnpinnedException(new Exception(""), "PagePinnedException");
				}
			}
		}
	}
	/**
	 * Call DB object to allocate a run of new pages and find a frame in the
	 * buffer pool for the first page and pin it. If buffer is full, ask DB to
	 * deallocate all these pages and return error (null if error).
	 * 
	 * @param firstpage
	 *            the address of the first page.
	 * @param howmany
	 *            total number of allocated new pages.
	 * @return the first page id of the new pages.
	 * 
	 * @exception BufferPoolExceededException
	 *                if the buffer pool is full.
	 * @exception HashOperationException
	 *                if there is a hashtable error.
	 * @exception ReplacerException
	 *                if there is a replacer error.
	 * @exception HashEntryNotFoundException
	 *                if there is no entry of page in the hash table.
	 * @exception InvalidFrameNumberException
	 *                if there is an invalid frame number.
	 * @exception PageUnpinnedException
	 *                if there is a page that is already unpinned.
	 * @exception PagePinnedException
	 *                if a page is left pinned.
	 * @exception PageNotReadException
	 *                if a page cannot be read.
	 * @exception IOException
	 *                if there is other kinds of I/O error.
	 * @exception BufMgrException
	 *                other error occured in bufmgr layer
	 * @exception DiskMgrException
	 *                other error occured in diskmgr layer
	 */
	public PageId newPage(Page firstpage, int howmany)
			throws BufferPoolExceededException, HashOperationException,
			ReplacerException, HashEntryNotFoundException,
			InvalidFrameNumberException, PagePinnedException,
			PageUnpinnedException, PageNotReadException, BufMgrException,
			DiskMgrException, IOException
	{
		PageId apageId = new PageId(0);
		try 
		{
			SystemDefs.JavabaseDB.allocate_page(apageId, howmany);
		}catch (Exception e)
		{
			throw new DiskMgrException (e, "DiskMgrException");
		}
		pinPage(apageId, firstpage, false);
		return apageId;
	}

	/**
	 * User should call this method if s/he needs to delete a page. this routine
	 * will call DB to deallocate the page.
	 * 
	 * @param globalPageId
	 *            the page number in the data base.
	 * @exception InvalidBufferException
	 *                if buffer pool corrupted.
	 * @exception ReplacerException
	 *                if there is a replacer error.
	 * @exception HashOperationException
	 *                if there is a hash table error.
	 * @exception InvalidFrameNumberException
	 *                if there is an invalid frame number.
	 * @exception PageNotReadException
	 *                if a page cannot be read.
	 * @exception BufferPoolExceededException
	 *                if the buffer pool is already full.
	 * @exception PagePinnedException
	 *                if a page is left pinned.
	 * @exception PageUnpinnedException
	 *                if there is a page that is already unpinned.
	 * @exception HashEntryNotFoundException
	 *                if there is no entry of page in the hash table.
	 * @exception IOException
	 *                if there is other kinds of I/O error.
	 * @exception BufMgrException
	 *                other error occured in bufmgr layer
	 * @exception DiskMgrException
	 *                other error occured in diskmgr layer
	 */
	public void freePage(PageId globalPageId) throws InvalidBufferException,
			ReplacerException, HashOperationException,
			InvalidFrameNumberException, PageNotReadException,
			BufferPoolExceededException, PagePinnedException,
			PageUnpinnedException, HashEntryNotFoundException, BufMgrException,
			DiskMgrException, IOException
	{
		int index = FindFrameInPool(globalPageId);
		
		if (index < 0)
		{
			throw new InvalidFrameNumberException(new Exception(""), "InvalidFrameNumberException");
		}
		else
		{
			if (frameTable[index].getPinCount() == 0 || frameTable[index].getPinCount() == 1)
			{
				try 
				{
					SystemDefs.JavabaseDB.deallocate_page(globalPageId);
				}catch (Exception e)
				{
					throw new IOException ("BUFMGR: WRITE_PAGE_ERROR");        
				} 
				frameTable[index].makeClean();
				if (frameTable[index].getPinCount() == 1)
					frameTable[index].unpin();
				replacer.free(index);			
				frameTable[index] = new BufMgrFrameDesc(new PageId (-1));                
				pageIdToPageData.remove(globalPageId);
				
			}
			else if (frameTable[index].getPinCount() > 1) 
			{
				throw new PagePinnedException(new Exception(""), "PagePinnedException"); 			
			}
		}
	}

	/**
	 * Added to flush a particular page off the buffer pool to disk
	 * 
	 * @param pageid
	 *            the page number in the database.
	 * 
	 * @exception HashOperationException
	 *                if there is a hashtable error.
	 * @exception PageUnpinnedException
	 *                if there is a page that is already unpinned.
	 * @exception PagePinnedException
	 *                if a page is left pinned.
	 * @exception PageNotFoundException
	 *                if a page is not found.
	 * @exception BufMgrException
	 *                other error occured in bufmgr layer
	 * @exception IOException
	 *                if there is other kinds of I/O error.
	 */
	public void flushPage(PageId pageid) throws HashOperationException,
			PageUnpinnedException, PagePinnedException, PageNotFoundException,
			BufMgrException, IOException
	{
		////*********** FLUSH = Out of the bufferpool, up to us for it to be outta hash and Descriptors
		int index = FindFrameInPool(pageid);
		
		byte [] data = new byte[MAX_SPACE];
			
		if (index >= 0)
		{
			try
			{
				data = (byte[]) pageIdToPageData.get(pageid);
			}catch (Exception e)
			{
				throw new PageNotFoundException (e,"PageNotFoundException");      
			};
		
			if (frameTable[index].getPinCount() == 0 || frameTable[index].getPinCount() == 1)
			{
				try 
				{
					SystemDefs.JavabaseDB.write_page(pageid, new Page(data));
				}catch (Exception e)
				{
					throw new IOException ("BUFMGR: WRITE_PAGE_ERROR");
				};
				if (frameTable[index].getPinCount() == 1)
				{
				   frameTable[index].unpin();
				   try 
					{
					   replacer.unpin(index);
					}catch (Exception e)
					{
						throw new PagePinnedException (e, "PagePinnedException");
					};
				}
				frameTable[index].makeClean();
				
			}
			else
			{
				if (frameTable[index].getPinCount() > 1)
				{
					try 
					{
						SystemDefs.JavabaseDB.write_page(pageid, new Page(data)); 
						frameTable[index].makeClean();
					}catch (Exception e)
					{
						throw new IOException("BUFMGR: WRITE_PAGE_ERROR");         
					};
					throw new PagePinnedException (new IOException(""), "PagePinnedException"); 
				}
			}
		}
	}
	
	/**
	 * Flushes all pages of the buffer pool to disk
	 * 
	 * @exception HashOperationException
	 *                if there is a hashtable error.
	 * @exception PageUnpinnedException
	 *                if there is a page that is already unpinned.
	 * @exception PagePinnedException
	 *                if a page is left pinned.
	 * @exception PageNotFoundException
	 *                if a page is not found.
	 * @exception BufMgrException
	 *                other error occured in bufmgr layer
	 * @exception IOException
	 *                if there is other kinds of I/O error.
	 */
	public void flushAllPages() throws HashOperationException,
			PageUnpinnedException, PagePinnedException, PageNotFoundException,
			BufMgrException, IOException
	{
		boolean error_flag = false;
		
		for (int i = 0; i< numBuffers; i++)
		{
			try
			{
				this.flushPage(frameTable[i].getPageId());
			}catch (Exception e)
			{
				error_flag = true;      
			};
		}
		if (error_flag) 
			throw new PagePinnedException (new Exception(""), "PagePinnedException");
	}
	
	public int getNumBuffers()
	{
		return numBuffers;
	}

	public int getNumUnpinnedBuffers()
	{
		int NumUnpinnedBuffers = 0;
		for (int i = 0; i<= numBuffers; i++)
		{
			if (frameTable[i].getPinCount() == 0)
				NumUnpinnedBuffers++;
		}
		return NumUnpinnedBuffers;
	}

	/** A few routines currently need direct access to the FrameTable. */
	public AbstractBufMgrFrameDesc[] getFrameTable()
	{
		return this.frameTable;
	}
	
	
}