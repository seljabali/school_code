//FENDER-BENDER TEAM!!!
///Premium Members:
///  ElJabali, Sami	19059321	cs186-au
///  Tenorio, Yuly	19077774	cs186-as


package bufmgr;

import exceptions.HashEntryNotFoundException;
import exceptions.InvalidFrameNumberException;
import exceptions.PageUnpinnedException;
import exceptions.ReplacerException;
import global.AbstractBufMgrFrameDesc;
import global.GlobalConst;
import global.PageId;

public class BufMgrFrameDesc extends global.AbstractBufMgrFrameDesc implements GlobalConst
{
	private int num_pin;     
	private PageId page_id;
	private boolean dirty;
	
	
	public BufMgrFrameDesc ()
	{
		page_id = null;
		num_pin = 0;      
		dirty = false;		
	}
	
	
	public BufMgrFrameDesc (PageId page)
	{
		page_id = page;
		num_pin = 0;      //***********//
		dirty = false;
	}
	
	public void Set_pageId (PageId pg_id)
	{
		page_id = pg_id;
	}
	
	public int getPinCount()
	{ return num_pin; };

	public int pin()
	{ 
		num_pin++;
		return num_pin; 
	};

	public int unpin()
	{ 
		num_pin--;
		if(num_pin < 0) num_pin = 0;
		return num_pin; 
	};

	public PageId getPageId()
	{ return page_id; };

	public PageId getPageNo()
	{ return page_id; };

	public boolean isDirty()
	{ return dirty; };
	
	public boolean makeDirty()
	{
		dirty = true;
		return dirty;
	}
	
	/**
	 * To set the page "undirty" or clean
	 * sets: dirty = false
	 */
	public boolean makeClean() 
	{
		dirty = false;
		return dirty;
	}
	

}
