/*
 * @(#) BTIndexPage.java   98/05/14
 * Copyright (c) 1998 UW.  All Rights Reserved.
 *         Author: Xiaohu Li (xioahu@cs.wisc.edu)
 *
 */

package btree.page;

import global.PageId;
import global.Minibase;
import heap.HFPage;

import java.io.IOException;

import diskmgr.Page;
import exceptions.ConstructPageException;

/**
 * Intefrace of a B+ tree index header page. Here we use a HFPage as head page
 * of the file Inside the headpage, Logicaly, there are only seven elements
 * inside the head page, they are magic0, rootId, keyType, maxKeySize,
 * deleteFashion, and type(=NodeType.BTHEAD)
 */
public class BTHeaderPage extends HFPage
{

	public void setPageId(PageId pageno) throws IOException
	{
		setCurPage(pageno);
	}

	public PageId getPageId() throws IOException
	{
		return getCurPage();
	}

	/**
	 * set the magic0
	 * 
	 * @param magic
	 *            magic0 will be set to be equal to magic
	 */
	public void set_magic0(int magic) throws IOException
	{
		setPrevPage(new PageId(magic));
	}

	/**
	 * get the magic0
	 */
	public int get_magic0() throws IOException
	{
		return getPrevPage().pid;
	};

	/**
	 * set the rootId
	 */
	public void set_rootId(PageId rootID) throws IOException
	{
		setNextPage(rootID);
	};

	/**
	 * get the rootId
	 */
	public PageId get_rootId() throws IOException
	{
		return getNextPage();
	}

	/**
	 * set the key type
	 */
	public void set_keyType(short key_type) throws IOException
	{
		setSlot(3, (int) key_type, 0);
	}

	/**
	 * get the key type
	 */
	public short get_keyType() throws IOException
	{
		return (short) getSlotLength(3);
	}

	/**
	 * get the max keysize
	 */
	public void set_maxKeySize(int key_size) throws IOException
	{
		setSlot(1, key_size, 0);
	}

	/**
	 * set the max keysize
	 */
	public int get_maxKeySize() throws IOException
	{
		return getSlotLength(1);
	}

	/**
	 * set the delete fashion
	 */
	public void set_deleteFashion(int fashion) throws IOException
	{
		setSlot(2, fashion, 0);
	}

	/**
	 * get the delete fashion
	 */
	public int get_deleteFashion() throws IOException
	{
		return getSlotLength(2);
	}

	/**
	 * pin the page with pageno, and get the corresponding SortedPage
	 */
	public BTHeaderPage(PageId pageno) throws ConstructPageException
	{
		super();
		try
		{

			Minibase.JavabaseBM.pinPage(pageno, this, false/* Rdisk */);
		} catch (Exception e)
		{
			throw new ConstructPageException(e, "pinpage failed");
		}
	}

	/** associate the SortedPage instance with the Page instance */
	public BTHeaderPage(Page page)
	{

		super(page);
	}

	/**
	 * new a page, and associate the SortedPage instance with the Page instance
	 */
	public BTHeaderPage() throws ConstructPageException
	{
		super();
		try
		{
			Page apage = new Page();
			PageId pageId = Minibase.JavabaseBM.newPage(apage, 1);
			if (pageId == null)
				throw new ConstructPageException(null, "new page failed");
			this.init(pageId, apage);

		} catch (Exception e)
		{
			throw new ConstructPageException(e, "construct header page failed");
		}
	}

} // end of BTreeHeaderPage
