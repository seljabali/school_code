/*
 * @(#) BTIndexPage.java   98/05/14
 * Copyright (c) 1998 UW.  All Rights Reserved.
 *         Author: Xiaohu Li (xioahu@cs.wisc.edu)
 *
 */

package btree.page;

import global.PageId;
import global.RID;

import index.Key;
import index.KeyEntry;

import java.io.IOException;

import diskmgr.Page;
import exceptions.ConstructPageException;
import exceptions.DeleteRecException;
import exceptions.IteratorException;
import exceptions.LeafDeleteException;
import exceptions.LeafInsertRecException;
import exceptions.LeafRedistributeException;

/**
 * A BTLeafPage is a leaf page on a B+ tree. It holds abstract <key, RID> pairs;
 * it doesn't know anything about the keys (their lengths or their types),
 * instead relying on the abstract interface consisting of BT.java.
 */
public class BTLeafPage extends BTSortedPage
{

	/**
	 * pin the page with pageno, and get the corresponding BTLeafPage, also it
	 * sets the type to be NodeType.LEAF.
	 * 
	 * @param pageno
	 *            Input parameter. To specify which page number the BTLeafPage
	 *            will correspond to.
	 * @param keyType
	 *            either AttrType.attrInteger or AttrType.attrString. Input
	 *            parameter.
	 * @exception IOException
	 *                error from the lower layer
	 * @exception ConstructPageException
	 *                BTLeafPage constructor error
	 */
	public BTLeafPage(PageId pageno, int keyType) throws IOException,
			ConstructPageException
	{
		super(pageno, keyType);
		setType(LEAF);
	}

	/**
	 * associate the BTLeafPage instance with the Page instance, also it sets
	 * the type to be NodeType.LEAF.
	 * 
	 * @param page
	 *            input parameter. To specify which page the BTLeafPage will
	 *            correspond to.
	 * @param keyType
	 *            either AttrType.attrInteger or AttrType.attrString. Input
	 *            parameter.
	 * @exception IOException
	 *                error from the lower layer
	 * @exception ConstructPageException
	 *                BTLeafPage constructor error
	 */
	public BTLeafPage(Page page, int keyType) throws IOException,
			ConstructPageException
	{
		super(page, keyType);
		setType(LEAF);
	}

	/**
	 * new a page, associate the BTLeafPage instance with the Page instance,
	 * also it sets the type to be NodeType.LEAF.
	 * 
	 * @param keyType
	 *            either AttrType.attrInteger or AttrType.attrString. Input
	 *            parameter.
	 * @exception IOException
	 *                error from the lower layer
	 * @exception ConstructPageException
	 *                BTLeafPage constructor error
	 */
	public BTLeafPage(int keyType) throws IOException, ConstructPageException
	{
		super(keyType);
		setType(LEAF);
	}

	/**
	 * insertRecord READ THIS DESCRIPTION CAREFULLY. THERE ARE TWO RIDs WHICH
	 * MEAN TWO DIFFERENT THINGS. Inserts a key, rid value into the leaf node.
	 * This is accomplished by a call to SortedPage::insertRecord() Parameters:
	 * 
	 * @param key -
	 *            the key value of the data record. Input parameter.
	 * @param dataRid -
	 *            the rid of the data record. This is stored on the leaf page
	 *            along with the corresponding key value. Input parameter.
	 * 
	 * @return - the rid of the inserted leaf record data entry, i.e., the <key,
	 *         dataRid> pair.
	 * @exception LeafInsertRecException
	 *                error when insert
	 */
	public RID insertRecord(Key key, RID dataRid)
			throws LeafInsertRecException
	{
		KeyEntry entry;

		try
		{
			entry = new KeyEntry(key, dataRid);

			return insertRecord(entry);
		} catch (Exception e)
		{
			throw new LeafInsertRecException(e, "insert record failed");
		}
	} // end of insertRecord

	/**
	 * Iterators. One of the two functions: getFirst and getNext which provide
	 * an iterator interface to the records on a BTLeafPage.
	 * 
	 * @param rid
	 *            It will be modified and the first rid in the leaf page will be
	 *            passed out by itself. Input and Output parameter.
	 * @return return the first KeyDataEntry in the leaf page. null if no more
	 *         record
	 * @exception IteratorException
	 *                iterator error
	 */
	public KeyEntry getFirst(RID rid) throws IteratorException
	{

		KeyEntry entry;

		try
		{
			rid.pageNo = getCurPage();
			rid.slotNo = 0; // begin with first slot

			if (getSlotCnt() <= 0)
			{
				return null;
			}

			entry = new KeyEntry(getpage(), getSlotOffset(0),
					getSlotLength(0), keyType, LEAF);

			return entry;
		} catch (Exception e)
		{
			throw new IteratorException(e, "Get first entry failed");
		}
	} // end of getFirst

	/**
	 * Iterators. One of the two functions: getFirst and getNext which provide
	 * an iterator interface to the records on a BTLeafPage.
	 * 
	 * @param rid
	 *            It will be modified and the next rid will be passed out by
	 *            itself. Input and Output parameter.
	 * @return return the next KeyDataEntry in the leaf page. null if no more
	 *         record.
	 * @exception IteratorException
	 *                iterator error
	 */

	public KeyEntry getNext(RID rid) throws IteratorException
	{
		KeyEntry entry;
		int i;
		try
		{
			rid.slotNo++; // must before any return;
			i = rid.slotNo;

			if (rid.slotNo >= getSlotCnt())
			{
				return null;
			}

			entry = new KeyEntry(getpage(), getSlotOffset(i),
					getSlotLength(i), keyType, LEAF);

			return entry;
		} catch (Exception e)
		{
			throw new IteratorException(e, "Get next entry failed");
		}
	}

	/**
	 * getCurrent returns the current record in the iteration; it is like
	 * getNext except it does not advance the iterator.
	 * 
	 * @param rid
	 *            the current rid. Input and Output parameter. But Output=Input.
	 * @return return the current KeyDataEntry
	 * @exception IteratorException
	 *                iterator error
	 */
	public KeyEntry getCurrent(RID rid) throws IteratorException
	{
		rid.slotNo--;
		return getNext(rid);
	}

	/**
	 * delete a data entry in the leaf page.
	 * 
	 * @param dEntry
	 *            the entry will be deleted in the leaf page. Input parameter.
	 * @return true if deleted; false if no dEntry in the page
	 * @exception LeafDeleteException
	 *                error when delete
	 */
	public boolean delEntry(KeyEntry dEntry) throws DeleteRecException
	{
		KeyEntry entry;
		RID rid = new RID();

		try
		{
			for (entry = getFirst(rid); entry != null; entry = getNext(rid))
			{
				if (entry.equals(dEntry))
				{
					if (super.deleteSortedRecord(rid) == false)
						throw new DeleteRecException(null,
								"Delete record failed");
					return true;
				}

			}
			return false;
		} catch (Exception e)
		{
			throw new DeleteRecException(e, "delete entry failed");
		}

	} // end of delEntry

	/*
	 * used in full delete @param leafPage the sibling page of this. Input
	 * parameter. @param parentIndexPage the parant of leafPage and this. Input
	 * parameter. @param direction -1 if "this" is left sibling of leafPage ; 1
	 * if "this" is right sibling of leafPage. Input parameter. @param
	 * deletedKey the key which was already deleted, and cause redistribution.
	 * Input parameter. @exception LeafRedistributeException @return true if
	 * redistrbution success. false if we can not redistribute them.
	 */
	public boolean redistribute(BTLeafPage leafPage, BTIndexPage parentIndexPage,
			int direction, Key deletedKey)
			throws LeafRedistributeException
	{
		boolean st;
		// assertion: leafPage pinned
		try
		{
			if (direction == -1)
			{ // 'this' is the left sibling of leafPage
				if ((getSlotLength(getSlotCnt() - 1) + available_space() + 8 /* 2*sizeof(slot) */) > ((PAGE_SIZE - DPFIXED) / 2))
				{
					// cannot spare a record for its underflow sibling
					return false;
				} else
				{
					// move the last record to its sibling

					// get the last record
					KeyEntry lastEntry;
					lastEntry = new KeyEntry(getpage(),
							getSlotOffset(getSlotCnt() - 1),
							getSlotLength(getSlotCnt() - 1), keyType,
							LEAF);

					// get its sibling's first record's key for adjusting parent
					// pointer
					RID dummyRid = new RID();
					KeyEntry firstEntry;
					firstEntry = leafPage.getFirst(dummyRid);

					// insert it into its sibling
					leafPage.insertRecord(lastEntry);

					// delete the last record from the old page
					RID delRid = new RID();
					delRid.pageNo = getCurPage();
					delRid.slotNo = getSlotCnt() - 1;
					if (deleteSortedRecord(delRid) == false)
						throw new LeafRedistributeException(null,
								"delete record failed");

					// adjust the entry pointing to sibling in its parent
					if (deletedKey != null)
						st = parentIndexPage.adjustKey(lastEntry.key,
								deletedKey);
					else
						st = parentIndexPage.adjustKey(lastEntry.key,
								firstEntry.key);
					if (st == false)
						throw new LeafRedistributeException(null,
								"adjust key failed");
					return true;
				}
			} else
			{ // 'this' is the right sibling of pptr
				if ((getSlotLength(0) + available_space() + 8) > ((PAGE_SIZE - DPFIXED) / 2))
				{
					// cannot spare a record for its underflow sibling
					return false;
				} else
				{
					// move the first record to its sibling

					// get the first record
					KeyEntry firstEntry;
					firstEntry = new KeyEntry(getpage(),
							getSlotOffset(0), getSlotLength(0), keyType,
							LEAF);

					// insert it into its sibling
					RID dummyRid = new RID();
					leafPage.insertRecord(firstEntry);

					// delete the first record from the old page
					RID delRid = new RID();
					delRid.pageNo = getCurPage();
					delRid.slotNo = 0;
					if (deleteSortedRecord(delRid) == false)
						throw new LeafRedistributeException(null,
								"delete record failed");

					// get the current first record of the old page
					// for adjusting parent pointer.
					KeyEntry tmpEntry;
					tmpEntry = getFirst(dummyRid);

					// adjust the entry pointing to itself in its parent
					st = parentIndexPage
							.adjustKey(tmpEntry.key, firstEntry.key);
					if (st == false)
						throw new LeafRedistributeException(null,
								"adjust key failed");
					return true;
				}
			}
		} catch (Exception e)
		{
			throw new LeafRedistributeException(e, "redistribute failed");
		}
	} // end of redistribute

} // end of BTLeafPage

