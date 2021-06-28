package global;

import java.io.IOException;

import diskmgr.Page;
import exceptions.*;


public abstract class AbstractBufMgr implements GlobalConst
{
	/** The replacer object, which is only used in this class. */
	protected AbstractBufMgrReplacer replacer;

	
	/**
	 * 
	 * @param replacerClassName
	 */
	protected void setReplacer(String replacerClassName) throws InvalidReplacerException
	{
		try
		{
			Class replacerClass = Class.forName(replacerClassName);
			if (!AbstractBufMgrReplacer.class.isAssignableFrom(replacerClass))
				throw new InvalidReplacerException("Specified class: " + replacerClassName+
						" is not a subclass of AbstractBufMgrReplacer.");
			
			replacer = (AbstractBufMgrReplacer) replacerClass.newInstance();
			replacer.setBufferManager(this);
		} catch (ClassNotFoundException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
			throw new InvalidReplacerException("Can't find class: " + replacerClassName);
		} catch (InstantiationException e)
		{
			throw new InvalidReplacerException("Can't instantiate class: " + replacerClassName);
		} catch (IllegalAccessException e)
		{
			throw new InvalidReplacerException("Can't access constructor for class: " + replacerClassName);
		}
		
	}
	
	
	/**
	 * Check if this page is in buffer pool, otherwise find a frame for this
	 * page, read in and pin it. Also write out the old page if it's dirty
	 * before reading if emptyPage==TRUE, then actually no read is done to bring
	 * the page in.
	 * 
	 * @param Page_Id_in_a_DB
	 *            page number in the minibase.
	 * @param page
	 *            the pointer poit to the page.
	 * @param emptyPage
	 *            true (empty page); false (non-empty page)
	 * 
	 * @exception ReplacerException
	 *                if there is a replacer error.
	 * @exception HashOperationException
	 *                if there is a hashtable error.
	 * @exception PageUnpinnedException
	 *                if there is a page that is already unpinned.
	 * @exception InvalidFrameNumberException
	 *                if there is an invalid frame number .
	 * @exception PageNotReadException
	 *                if a page cannot be read.
	 * @exception BufferPoolExceededException
	 *                if the buffer pool is full.
	 * @exception PagePinnedException
	 *                if a page is left pinned .
	 * @exception BufMgrException
	 *                other error occured in bufmgr layer
	 * @exception IOException
	 *                if there is other kinds of I/O error.
	 */

	public abstract void pinPage(PageId pin_pgid, Page page, boolean emptyPage)
	throws ReplacerException, HashOperationException,
	PageUnpinnedException, InvalidFrameNumberException,
	PageNotReadException, BufferPoolExceededException,
	PagePinnedException, BufMgrException, IOException;


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
	public abstract void unpinPage(PageId PageId_in_a_DB, boolean dirty)
	throws ReplacerException, PageUnpinnedException,
	HashEntryNotFoundException, InvalidFrameNumberException;


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

	public abstract PageId newPage(Page firstpage, int howmany)
	throws BufferPoolExceededException, HashOperationException,
	ReplacerException, HashEntryNotFoundException,
	InvalidFrameNumberException, PagePinnedException,
	PageUnpinnedException, PageNotReadException, BufMgrException,
	DiskMgrException, IOException;


	/**
	 * User should call this method if she needs to delete a page. this routine
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
	public abstract void freePage(PageId globalPageId) throws InvalidBufferException,
	ReplacerException, HashOperationException,
	InvalidFrameNumberException, PageNotReadException,
	BufferPoolExceededException, PagePinnedException,
	PageUnpinnedException, HashEntryNotFoundException, BufMgrException,
	DiskMgrException, IOException;


	/**
	 * Added to flush a particular page of the buffer pool to disk
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
	public abstract void flushPage(PageId pageid) throws HashOperationException,
	PageUnpinnedException, PagePinnedException, PageNotFoundException,
	BufMgrException, IOException;

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
	public abstract void flushAllPages() throws HashOperationException,
	PageUnpinnedException, PagePinnedException, PageNotFoundException,
	BufMgrException, IOException;

	/**
	 * Gets the total number of buffers.
	 * 
	 * @return total number of buffer frames.
	 */
	public abstract int getNumBuffers();

	/**
	 * Gets the total number of unpinned buffer frames.
	 * 
	 * @return total number of unpinned buffer frames.
	 */
	public abstract int getNumUnpinnedBuffers();
	
	/**
	 * 
	 */
	public abstract AbstractBufMgrFrameDesc[] getFrameTable();

	/**
	 * write_page - a wrapper for DB write_page, that also wraps any exception
	 * @param pageno
	 * @param page
	 * @throws BufMgrException
	 */
	protected void write_page(PageId pageno, Page page) throws BufMgrException
	{

		try
		{
			Minibase.JavabaseDB.write_page(pageno, page);
		} catch (Exception e)
		{
			e.printStackTrace();
			throw new BufMgrException(e, "BufMgr.java: write_page() failed");
		}

	} // end of write_page

	
	/**
	 * read_page - a wrapper for DB read_page, that also wraps any exception
	 * @param pageno
	 * @param page
	 * @throws BufMgrException
	 */
	protected void read_page(PageId pageno, Page page) throws BufMgrException
	{

		try
		{
			Minibase.JavabaseDB.read_page(pageno, page);
		} catch (Exception e)
		{
			throw new BufMgrException(e, "BufMgr.java: read_page() failed");
		}

	} // end of read_page


	/**
	 * allocate_page - a wrapper for DB allocate_page, that also wraps any exception
	 * @param pageno
	 * @param num
	 * @throws BufMgrException
	 */
	protected void allocate_page(PageId pageno, int num) throws BufMgrException
	{
		try
		{
			Minibase.JavabaseDB.allocate_page(pageno, num);
		} catch (Exception e)
		{
			throw new BufMgrException(e, "BufMgr.java: allocate_page() failed");
		}

	} // end of allocate_page

	
	/**
	 * deallocate_page - a wrapper for DB deallocate_page, that also wraps any exception
	 * @param pageno
	 * @throws BufMgrException
	 */
	protected void deallocate_page(PageId pageno) throws BufMgrException
	{

		try
		{
			Minibase.JavabaseDB.deallocate_page(pageno);
		} catch (Exception e)
		{
			throw new BufMgrException(e,
					"BufMgr.java: deallocate_page() failed");
		}

	} // end of deallocate_page


}
