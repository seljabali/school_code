//FENDER-BENDER TEAM!!!
///Premium Members:
///  ElJabali, Sami	19059321	cs186-au
///  Tenorio, Yuly	19077774	cs186-as


package tests;

import global.Convert;
import global.GlobalConst;
import global.PageId;
import global.SystemDefs;
import global.TestDriver;

import java.io.IOException;

import bufmgr.BufMgr;
import diskmgr.Page;
import exceptions.BufMgrException;
import exceptions.BufferPoolExceededException;
import exceptions.DiskMgrException;
import exceptions.HashEntryNotFoundException;
import exceptions.HashOperationException;
import exceptions.InvalidBufferException;
import exceptions.InvalidFrameNumberException;
import exceptions.InvalidReplacerException;
import exceptions.PageNotFoundException;
import exceptions.PageNotReadException;
import exceptions.PagePinnedException;
import exceptions.PageUnpinnedException;
import exceptions.ReplacerException;


public class BMDriver extends TestDriver implements GlobalConst
{
	
	// private int TRUE = 1;
	// private int FALSE = 0;
	private boolean OK = true;

	private boolean FAIL = false;

	/**
	 * BMDriver Constructor, inherited from TestDriver
	 */
	public BMDriver()
	{
		super("Buffer Manager");
	}

	public void initBeforeTests()
	{
		try 
		{
			//SystemDefs.initBufMgr(new BufMgr(5, "bufmgr.MRU"));
			SystemDefs.initBufMgr(new BufMgr(5, "bufmgr.Clock"));
		} catch(Exception ire)
		{
			ire.printStackTrace();
			System.exit(1);
		}
		
		SystemDefs.initDiskMgr("BMDriver", NUMBUF+20);
	}
	
	/**
	 * Add your own test here.
	 * 
	 * @return whether test1 has passed
	 */
	public boolean test1()
	{
		try {
			System.out.println("NOTE: testing with 5 buffers");
			System.out.println("index,  pid ,  dirty, pincount");
			
			int buffs = 5;    /************NUM OF BUFFERS FOR TESTING ******/
			
			System.out.println("pinPage 5");
			
			SystemDefs.JavabaseBM.pinPage(new PageId(5), new Page(), false);
			for (int i=0; i<buffs ; i++)
			{
				System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
			}
			
			
			System.out.println("pinPage 6");
			PageId pgid = new PageId(6);
			Page aPage = new Page();
			SystemDefs.JavabaseBM.pinPage(pgid, aPage, false);
			
			for (int i=0; i<buffs ; i++)
			{
				System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
			}
			
			System.out.println("pinPage 7");
			PageId pgid2 = new PageId(7);
			Page aPage2 = new Page();
			SystemDefs.JavabaseBM.pinPage(pgid2, aPage2, false);
			
			for (int i=0; i<buffs ; i++)
			{
				System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
			}
			
			System.out.println("pinPage 3");
			PageId pgid3 = new PageId(3);
			Page aPage3 = new Page();
			SystemDefs.JavabaseBM.pinPage(pgid3, aPage3, false);
			
			for (int i=0; i<buffs ; i++)
			{
				System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
			}
			System.out.println("pinPage 4");
			PageId pgid4 = new PageId(4);
			Page aPage4 = new Page();
			SystemDefs.JavabaseBM.pinPage(pgid4, aPage4, false);

			for (int i=0; i<buffs ; i++)
			{
				System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
			}
			
			System.out.println("unpinPage 6");
			SystemDefs.JavabaseBM.unpinPage(pgid, false);
			
			for (int i=0; i<buffs ; i++)
			{
				System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
			}
			
			System.out.println("pinPage 4");
			SystemDefs.JavabaseBM.pinPage(pgid4, aPage4, false);

			for (int i=0; i<buffs ; i++)
			{
				System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
			}
			
			
			
			
			System.out.println("pinPage 7");
			SystemDefs.JavabaseBM.pinPage(pgid2, aPage4, false);
			
			for (int i=0; i<buffs ; i++)
			{
				System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
			}
			
			
			System.out.println("unpinPage 4");
			SystemDefs.JavabaseBM.unpinPage(pgid4, false);
			
			for (int i=0; i<buffs ; i++)
			{
				System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
			}
			
			
			System.out.println("unpinPage 7");
			SystemDefs.JavabaseBM.unpinPage(pgid2, false);
			
			for (int i=0; i<buffs ; i++)
			{
				System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
			}
			
			System.out.println("pinPage 10");
			PageId pgid10 = new PageId(10);
			Page aPage10 = new Page();
			SystemDefs.JavabaseBM.pinPage(pgid10, aPage10, false);

			for (int i=0; i<buffs ; i++)
			{
				System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
			}
			
			System.out.println("unpinPage 7");
			SystemDefs.JavabaseBM.unpinPage(pgid2, false);
			
			for (int i=0; i<buffs ; i++)
			{
				System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
			}
			
			System.out.println("freePage 7");
			SystemDefs.JavabaseBM.freePage(pgid2);
			for (int i=0; i<buffs ; i++)
			{
				System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
			}
			
			System.out.println("pinPage 11");
			PageId pgid11 = new PageId(11);
			SystemDefs.JavabaseBM.pinPage(pgid11, aPage10, false);

			for (int i=0; i<buffs ; i++)
			{
				System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
			}
			
			System.out.println("flush all..");
			SystemDefs.JavabaseBM.flushAllPages();
			for (int i=0; i<buffs; i++)
			{
				System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
			}

			
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return false;
		}
		
		System.out.print("\n  Test 1 is implemented. \n ");
		
		return true;
	}

	/**
	 * Add your own test here.
	 * 
	 * @return whether test2 has passed
	 */

	public boolean test3()
	{
	  try {	
		
		  System.out.println("index,  pid ,  dirty, pincount");
		  int buffs = 5;    /************NUM OF BUFFERS FOR TESTING ******/
		
		System.out.println("pinPage 21");
		PageId pgid21 = new PageId(21);
		Page aPage1 = new Page();
		
		SystemDefs.JavabaseBM.pinPage(pgid21, aPage1, false);
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount() );				
		}
		
		
		System.out.println("pinPage 22");
		PageId pgid22 = new PageId(22);
		Page aPage = new Page();
		SystemDefs.JavabaseBM.pinPage(pgid22, aPage, false);
		
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
		
		System.out.println("pinPage 23");
		PageId pgid23 = new PageId(23);
		Page aPage2 = new Page();
		SystemDefs.JavabaseBM.pinPage(pgid23, aPage2, false);
		
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
		
		System.out.println("pinPage 24");
		PageId pgid24 = new PageId(24);
		Page aPage3 = new Page();
		SystemDefs.JavabaseBM.pinPage(pgid24, aPage3, false);
		
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
		
		
		System.out.println("unpinPage 21");
		SystemDefs.JavabaseBM.unpinPage(pgid21, false);
		
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
		
		
		System.out.println("unpinPage 23");
		SystemDefs.JavabaseBM.unpinPage(pgid23, false);
		
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
		
		
		
		System.out.println("pinPage 26");
		PageId pgid26 = new PageId(26);
		Page aPage4 = new Page();
		SystemDefs.JavabaseBM.pinPage(pgid26, aPage4, false);

		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
		
		
		System.out.println("unpinPage 22");
		SystemDefs.JavabaseBM.unpinPage(pgid22, false);
		
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
		
		System.out.println("pinPage 27");
		PageId pgid27 = new PageId(27);
		Page aPage27 = new Page();
		SystemDefs.JavabaseBM.pinPage(pgid27, aPage27, false);

		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
	
		
		System.out.println("pinPage 28");
		PageId pgid28 = new PageId(28);
				
		SystemDefs.JavabaseBM.pinPage(pgid28, aPage4, false);
		
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
		

		
		System.out.println("unpinPage 28");
		SystemDefs.JavabaseBM.unpinPage(pgid28, false);
		
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
		
		System.out.println("unpinPage 27");
		SystemDefs.JavabaseBM.unpinPage(pgid27, false);
		
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
		
		System.out.println("unpinPage 26");
		SystemDefs.JavabaseBM.unpinPage(pgid26, false);
		
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
		
		System.out.println("unpinPage 24");
		SystemDefs.JavabaseBM.unpinPage(pgid24, false);
		
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
		
		System.out.println("pinPage 29");
		PageId pgid29 = new PageId(29);
				
		SystemDefs.JavabaseBM.pinPage(pgid29, aPage4, false);
		
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
		
		
		System.out.println("flushPage 29");
		SystemDefs.JavabaseBM.flushPage(pgid29);
		
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
		
		System.out.println("freePage 29");
		SystemDefs.JavabaseBM.freePage(pgid29);
		
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
		
		System.out.println("pinPage 29");
				
		SystemDefs.JavabaseBM.pinPage(pgid29, aPage4, false);
		
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}

		System.out.println("flush all..");
		SystemDefs.JavabaseBM.flushAllPages();
		for (int i=0; i<buffs; i++)
		{
			System.out.println(i + " :  " +  SystemDefs.JavabaseBM.getFrameTable()[i].getPageNo().getPid() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].isDirty() + " | " + SystemDefs.JavabaseBM.getFrameTable()[i].getPinCount());				
		}
	}
	catch (Exception e)
	{
		e.printStackTrace();
		return false;
	}
	
	System.out.print("\n  Test 3 is implemented. \n ");
	
	return true;
	}
	
	public static void main(String argv[])
	{

		BMDriver bmt = new BMDriver();
		
		boolean dbstatus;

		dbstatus = bmt.runTests();

		if (dbstatus != true)
		{
			System.out.println("Error encountered during buffer manager tests:\n");
			System.out.flush();
			Runtime.getRuntime().exit(1);
		}

		System.out.println("Done. Exiting...");
		Runtime.getRuntime().exit(0);
	}
}
